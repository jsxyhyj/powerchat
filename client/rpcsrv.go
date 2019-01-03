package main

import (
	"bytes"
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net"
	"net/rpc"
	"os"
	"reflect"
	"strconv"
	"strings"
	"time"

	"github.com/powerman/rpc-codec/jsonrpc2"

	"github.com/rocket049/go-jsonrpc2glib"
)

var (
	cmdChan chan MsgType = make(chan MsgType, 1)
)

type PClient struct {
	conn      net.Conn
	myconn    *jsonrpc2glib.MyConn
	token     []byte
	id        int64
	httpId    int64
	proxyPort int
	fileSend  *FileSender
}

func (c *PClient) setToken(tk []byte) {
	c.token = make([]byte, len(tk))
	copy(c.token, tk)
}

func (c *PClient) setConn(connection net.Conn, conn2 net.Conn) {
	c.conn = connection
	c.myconn = jsonrpc2glib.NewMyConn(conn2)
}

func (c *PClient) setID(ident int64) {
	c.id = ident
}

//rpc service
func (c *PClient) SetHttpId(ident int64, res *int) error {
	c.httpId = ident
	return nil
}

//rpc service
type NUParam struct {
	Name  string
	Sex   int
	Birth int
	Desc  string
	Pwd   string
}

func (c *PClient) NewUser(p NUParam, res *int) error {
	pwdmd5 := md5.Sum([]byte(p.Name + p.Pwd))
	e := make([]byte, 32)
	hex.Encode(e, pwdmd5[:])
	var user1 = &UserInfo{0, p.Name, p.Sex,
		fmt.Sprintf("%d-01-01", p.Birth), p.Desc, string(e)}
	b, err := json.Marshal(user1)
	if err != nil {
		log.Println(err)
		return err
	}
	msg, _ := MsgEncode(CmdRegister, 0, 0, b)
	c.conn.Write(msg)
	return nil
}

type LogParam struct {
	Name string
	Pwd  string
}
type LogDgam struct {
	Name   string
	Pwdmd5 []byte
}

//rpc service
func (c *PClient) Login(p LogParam, res *FriendData) error {
	buf := bytes.NewBufferString(p.Name)
	buf.WriteString(p.Pwd)
	var pwdmd5 = md5.Sum(buf.Bytes())
	e := make([]byte, 32)
	hex.Encode(e, pwdmd5[:])
	bbuf := bytes.NewBufferString("")
	bbuf.Write(c.token)
	bbuf.Write(e)
	b := md5.Sum(bbuf.Bytes())
	dgam := &LogDgam{Name: p.Name, Pwdmd5: b[:]}
	bmsg, _ := json.Marshal(dgam)
	msg, _ := MsgEncode(CmdLogin, 0, 0, bmsg)
	c.conn.Write(msg)
	resp, ok := <-cmdChan
	if ok == false {
		return errors.New("internal error 1")
	}
	if resp.Cmd != CmdLogResult {
		return errors.New("internal error 2")
	}
	s := string(resp.Msg[0:4])
	if strings.HasPrefix(s, "FAIL") {
		return errors.New("login fail 3")
	}
	var u UserBaseInfo
	err := json.Unmarshal(resp.Msg, &u)
	if err != nil {
		return err
	}
	c.id = u.Id
	id = u.Id

	//*res = make([]int64, 1)
	//(*res)[0] = v
	*res = FriendData{Id: u.Id, Name: u.Name, Sex: u.Sex,
		Age:        time.Now().Year() - u.Birthday.Year(),
		Desc:       u.Desc,
		MsgOffline: msgOfflineData{"", ""}}
	//load manual config
	cfg1 := readManual(c.id)
	if cfg1 != nil {
		sPort, ok := cfg1["ProxyPort"]
		if ok == false {
			return nil
		}
		log.Println(reflect.TypeOf(sPort).Name())
		port, err := strconv.ParseInt(sPort, 10, 32)
		if err == nil {
			proxyPort = int(port)
		} else {
			log.Println(err)
		}
		log.Println("proxy port:", proxyPort, ",manual:", port)
	}

	return nil
}

type msgOfflineData struct {
	Timestamp string
	Msg       string
}
type FriendData struct {
	Id         int64
	Name       string
	Sex        int
	Age        int
	Desc       string
	MsgOffline msgOfflineData
}
type UserBaseInfo struct {
	Id         int64
	Name       string
	Sex        int
	Birthday   time.Time
	Desc       string
	MsgOffline string
}

func (c *PClient) GetFriends(p []byte, res *[]FriendData) error {
	req, _ := MsgEncode(CmdGetFriends, c.id, 0, []byte("\n"))
	c.conn.Write(req)
	resp, ok := <-cmdChan
	if ok == false {
		return errors.New("internal error 1")
	}
	if resp.Cmd != CmdRetFriends {
		return errors.New("internal error 2")
	}
	//json
	frds := make(map[int64]UserBaseInfo)
	err := json.Unmarshal(resp.Msg, &frds)
	if err != nil {
		return err
	}

	ret := []FriendData{}
	for _, v := range frds {
		var offmsg msgOfflineData
		if len(v.MsgOffline) > 17 {
			json.Unmarshal([]byte(v.MsgOffline), &offmsg)
		}
		ret = append(ret, FriendData{Id: v.Id, Name: v.Name, Sex: v.Sex,
			Age: time.Now().Year() - v.Birthday.Year(), Desc: v.Desc, MsgOffline: offmsg})
	}
	*res = ret
	log.Println("GetFriends")
	return nil
}

func (c *PClient) QueryID(uid []int64, res *FriendData) error {
	req, _ := MsgEncode(CmdQueryID, c.id, uid[0], []byte("\n"))
	c.conn.Write(req)
	resp, ok := <-cmdChan
	if ok == false {
		return errors.New("query internal error 1")
	}
	if resp.Cmd != CmdReturnQueryID {
		return errors.New("query internal error 2")
	}
	var v UserBaseInfo
	err := json.Unmarshal(resp.Msg, &v)
	if err != nil {
		return err
	}
	*res = FriendData{Id: v.Id, Name: v.Name, Sex: v.Sex,
		Age: time.Now().Year() - v.Birthday.Year(), Desc: v.Desc}
	return nil
}

//move stranger
func (c *PClient) MoveStrangerToFriend(fid []int64, res *int) error {
	req, _ := MsgEncode(CmdMoveStranger, c.id, fid[0], []byte("\n"))
	c.conn.Write(req)
	return nil
}

//stranger messages
func (c *PClient) GetStrangerMsgs(p []byte, res *[]FriendData) error {
	req, _ := MsgEncode(CmdGetStrangers, c.id, 0, []byte("\n"))
	c.conn.Write(req)
	resp, ok := <-cmdChan
	if ok == false {
		return errors.New("internal error 1")
	}
	if resp.Cmd != CmdReturnStrangers {
		return errors.New("internal error 2")
	}
	//json
	frds := make(map[int64]UserBaseInfo)
	err := json.Unmarshal(resp.Msg, &frds)
	if err != nil {
		return err
	}

	ret := []FriendData{}
	for _, v := range frds {
		var offmsg msgOfflineData
		if len(v.MsgOffline) > 17 {
			json.Unmarshal([]byte(v.MsgOffline), &offmsg)
		}
		ret = append(ret, FriendData{Id: v.Id, Name: v.Name, Sex: v.Sex,
			Age: time.Now().Year() - v.Birthday.Year(), Desc: v.Desc, MsgOffline: offmsg})
	}
	*res = ret
	log.Println("GetStrangerMsgs")
	return nil
}

func (c *PClient) SearchPersons(key []string, res *[]FriendData) error {
	req, _ := MsgEncode(CmdSearchPersons, c.id, 0, []byte(key[0]))
	c.conn.Write(req)
	resp, ok := <-cmdChan
	if ok == false {
		return errors.New("internal error 1")
	}
	if resp.Cmd != CmdReturnPersons {
		return errors.New("internal error 2")
	}
	//json
	frds := make(map[int64]UserBaseInfo)
	err := json.Unmarshal(resp.Msg, &frds)
	if err != nil {
		return err
	}
	ret := []FriendData{}
	for _, v := range frds {
		ret = append(ret, FriendData{Id: v.Id, Name: v.Name, Sex: v.Sex,
			Age: time.Now().Year() - v.Birthday.Year(), Desc: v.Desc})
	}
	*res = ret
	return nil
}

type ChatMessage struct {
	To  int64
	Msg string
}

//rpc service
func (c *PClient) ChatTo(p ChatMessage, res *int) error {
	msg, _ := MsgEncode(CmdChat, 0, p.To, []byte("TEXT"+p.Msg))
	c.conn.Write(msg)
	return nil
}

//rpc service
func (c *PClient) Tell(uid []int64, res *int) error {
	msg, _ := MsgEncode(CmdChat, 0, uid[0], []byte("LOGI"))
	c.conn.Write(msg)
	return nil
}

//rpc service
func (c *PClient) HttpConnect(uid []int64, res *int) error {
	httpId = uid[0]
	c.httpId = uid[0]
	//fmt.Println("httpID:", uid)
	return nil
}

//rpc service
func (c *PClient) ProxyPort(port []int, res *int) error {
	var port1 int = servePort + 2000
	if port[0] != 0 {
		port1 = port[0]
	}
	c.proxyPort = port1
	proxyPort = port1
	cfg1 := make(map[string]string)
	cfg1["ProxyPort"] = fmt.Sprintf("%d", port1)
	saveManual(c.id, cfg1)
	*res = port1
	return nil
}

type MsgReturn struct {
	T    uint8
	From int64
	To   int64
	Msg  string
}

//rpc notify the client
func (c *PClient) notifyMsg(msg *MsgType) error {
	res := MsgReturn{T: uint8(msg.Cmd),
		From: msg.From,
		To:   msg.To,
		Msg:  string(msg.Msg)}
	return c.myconn.Notify("msg", &res)
}

type NotifyDgram struct {
	Jsonrpc string
	Method  string
	Params  *MsgReturn
}

type SFParam struct {
	To       int64
	PathName string
}

//rpc service
func (c *PClient) SendFile(param SFParam, res *int) error {
	if c.fileSend != nil {
		if c.fileSend.Status() {
			return errors.New("working,try later.")
		}
	}

	var sender = new(FileSender)
	sender.Prepare(param.PathName, param.To, c.conn)
	ok, _ := sender.SendFileHeader()
	if ok == false {
		return errors.New("Blocked,try later.")
	}
	c.fileSend = sender
	sender.SendFileBody()
	return nil
}

func (c *PClient) startServe() {
	rpc.Register(c)
	//jsonrpc2glib.ServeGlib(conn1, nil)
	rpc.ServeCodec(jsonrpc2.NewServerCodec(c.myconn, nil))
	log.Println("rpc serve connection error")
	close(cmdChan)
	os.Exit(1)
}

//rpc service
func (c *PClient) AddFriend(param []int64, res *int) error {
	req, _ := MsgEncode(CmdAddFriend, 0, param[0], []byte("\n"))
	c.conn.Write(req)
	return nil
}

//rpc service
func (c *PClient) RemoveFriend(param []int64, res *int) error {
	req, _ := MsgEncode(CmdRemoveFriend, c.id, param[0], []byte("\n"))
	c.conn.Write(req)
	return nil
}

//rpc service
func (c *PClient) GetProxyPort(param []byte, res *int) error {
	*res = proxyPort
	return nil
}

//rpc service block
func (c *PClient) Quit(param []byte, res *int) error {
	log.Println("rpc serve normal exit")
	os.Exit(0)
	return nil
}
