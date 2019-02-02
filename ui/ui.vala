using Gtk;
using Gdk;
using Pango;
using Gee;
using Json;

static AppWin app;
static MyGrid grid1;
static LoginDialog login1;
static RpcClient rpc1;
static AddUserDialog adduser1;

public struct UserData {
	public int64 id;
	public int16 sex;
	public string name;
	public string desc;
	public int16 age;
	public string msg_offline;
	public string timestamp_offline;
}
public class MyGrid: GLib.Object{
	Gtk.ListBox friends;
	Gtk.ListBox msgs = null;
	Gtk.Entry entry1;
	public Gtk.Entry port1;
	int64 to;
	bool running = true;
	//public MyBrowser browser;

	public Gtk.Grid mygrid;
	Gee.HashMap<string,UserData?> frds1;
	Gee.HashMap<string,weak Gtk.Grid?> frd_boxes;
	public Gtk.CssProvider provider1;
	public Gtk.CssProvider mark1;
	public int mark_num=0;
	public Gtk.CssProvider button1;
	public Gtk.CssProvider link_css1;
	public Gtk.Button strangers_btn;
	public Gtk.Button user_btn;

	public string man_icon = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S,prog_path,"..","share","icons","powerchat","man.png");
	public string woman_icon = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S,prog_path,"..","share","icons","powerchat","woman.png");
	public int64 uid;
	public int16 usex;
	public string uname;
	public string udesc;
	public int16 uage;
	
	public string host;
	Gtk.CssProvider cssp;
	Gtk.ScrolledWindow msg_win;
	public MyGrid(){
		//this.browser = new MyBrowser();
		this.frds1 = new Gee.HashMap<string,UserData?>();
		this.frd_boxes = new Gee.HashMap<string,weak Gtk.Grid?>();
		this.mygrid = new Gtk.Grid();
		this.mygrid.set_column_spacing(5);
		this.cssp = new Gtk.CssProvider();
		var sc = this.mygrid.get_style_context ();
		sc.add_provider(this.cssp,Gtk.STYLE_PROVIDER_PRIORITY_USER);
		this.cssp.load_from_data("""grid{
	padding:5px 5px 5px 5px;
	background-color:#BABABA;
}
list{
	background-color:#FFFFFF;
	color:#000000;
}
""");

		this.provider1 = new Gtk.CssProvider();
		this.provider1.load_from_data("""grid{color:#FF0000;}
""");

		this.mark1 = new Gtk.CssProvider();
		this.mark1.load_from_data("""grid{background:#F59433;}
""");

		this.button1 = new Gtk.CssProvider();
		this.button1.load_from_data("""button{color:#FF0000;}
""");
		this.link_css1 = new Gtk.CssProvider();
		this.link_css1.load_from_data("label>link{color:#0000FF;}");

		var scrollWin1 = new Gtk.ScrolledWindow(null,null);
		scrollWin1.width_request = 240;
		scrollWin1.expand = true;
		this.mygrid.attach(scrollWin1,0,0,2,3);
		this.friends = new Gtk.ListBox();
		scrollWin1.add(this.friends);
		var t1 = new Gtk.Label(_("My Friends"));
		this.friends.add(t1);
		var r0 = (t1.parent as Gtk.ListBoxRow);
		r0.set_selectable(false);
		r0.name = "0";
		this.friends.border_width = 3;
		var sc1 = this.friends.get_style_context ();
		sc1.add_provider(this.cssp,Gtk.STYLE_PROVIDER_PRIORITY_USER);

		this.friends.set_sort_func((row1,row2)=>{
			if(row1.name=="0"){
				return -1;
			}
			var rsc1 = this.frd_boxes[row1.name].get_style_context();
			var rsc2 = this.frd_boxes[row2.name].get_style_context();
			if(rsc1.has_class("off")){
				if(rsc2.has_class("off")){
					if(row1.name.to_int64() > row2.name.to_int64()){
						return 1;
					}else{
						return -1;
					}
				}else{
					//print("row1 is off row2 on\\n");
					return 1;
				}
			}else{
				if(rsc2.has_class("off")){
					//print("row1 is on row2 off\n");
					return -1;
				}else if(row1.name.to_int64() > row2.name.to_int64()){
					return 1;
				}else{
					return -1;
				}
			}
		});

		var b1 = new Gtk.Button.with_label(_("Find Persons"));
		this.mygrid.attach(b1,0,3,1,1);

		strangers_btn = new Gtk.Button.with_label(_("Strangers"));
		this.mygrid.attach(strangers_btn,1,3,1,1);

		user_btn = new Gtk.Button.with_label(_("Current User"));
		this.mygrid.attach(user_btn,2,0,1,1);
		user_btn.hexpand = true;

		var pwd_btn = new Gtk.Button.with_label(_("UpdatePasswd"));
		this.mygrid.attach(pwd_btn,3,0,1,1);
		pwd_btn.clicked.connect(()=>{
			this.update_pwd();
		});

		var b4 = new Gtk.Label(_("Proxy Port"));
		b4.hexpand = true;
		this.mygrid.attach(b4,4,0,1,1);

		port1 = new Gtk.Entry();
		port1.set_text(proxy_port.to_string());
		port1.tooltip_text = _("Click `Modify` button to edit.\nSet 0 to restore default value.");
		port1.max_length = 5;
		port1.width_request = 50;
		port1.editable=false;
		this.mygrid.attach(port1,5,0,1,1);

		var b6 = new Gtk.Button.with_label(_("Modify"));
		this.mygrid.attach(b6,6,0,1,1);

		this.msg_win = new Gtk.ScrolledWindow(null,null);
		this.msg_win.height_request = 450;
		this.msg_win.expand = true;
		this.mygrid.attach(this.msg_win,2,1,5,1);

		var grid1 = new Gtk.Grid();
		this.mygrid.attach(grid1,2,2,5,2);
		//文件拖放区
		Gtk.EventBox dropbox = new Gtk.EventBox();
		dropbox.set_size_request(100,40);
		grid1.attach(dropbox,0,0,4,1);
		dropbox.add(new Gtk.Label(_("Send File or Image: Drag a file here")));
		Gtk.drag_dest_set (dropbox, Gtk.DestDefaults.ALL, null, Gdk.DragAction.COPY);
		Gtk.drag_dest_add_uri_targets(dropbox);
		dropbox.drag_data_received.connect((context, x,y,data, info, time)=>{
			var uris = data.get_uris();
			if(uris.length>1){
				this.add_text(_("too many files"));
				return;
			}
			var fname = GLib.Filename.from_uri(uris[0]);
			if(FileUtils.test(fname, FileTest.IS_REGULAR)==false){
				this.add_text(_("this is not a file"));
				return;
			}
			if( rpc1.send_file(this.to, fname) ){
				string text1 = @"<a href='$(uris[0])'>$(GLib.Path.get_basename(fname))</a>";
				this.add_left_name_icon(this.uname,this.usex);
				this.add_text(text1,true,true);
			}else{
				Gtk.main_quit();
			}
		});

		this.entry1 = new Gtk.Entry();
		grid1.attach(this.entry1,0,1,3,1);
		this.entry1.hexpand = true;

		var b7 = new Gtk.Button.with_label(_("Send"));
		grid1.attach(b7,3,1,1,1);

		this.mygrid.show.connect(()=>{
			//var mutex1 = new GLib.Mutex();
			stdout.printf("grid show\n");
			var thread = new GLib.Thread<bool>("tell",()=>{
				var ids = this.frds1.keys;
				foreach( string k1 in ids){
					//mutex1.lock();
					//print("%s\n",k1);
					if(k1 == this.uid.to_string())
						continue;
					GLib.Idle.add(()=>{
						if( rpc1.tell(k1.to_int64())==false ){
							Gtk.main_quit();
						}
						//mutex1.unlock();
						return false;
					});
				}
				return true;
			});
			strangers1 = new StrangersDialg();
			uint16 port2;
			if(rpc1.get_proxy(out port2)){
				proxy_port = port2;
				this.port1.text = proxy_port.to_string();
			}else{
				Gtk.main_quit();
			}
			rpc1.get_host(out this.host);
			app.title = _("Everyone Publish!")+@"($(this.mark_num))"+" - "+this.host;
			app.update_tooltip();
		});

		b1.clicked.connect(()=>{
			search1 = new SearchDialg();
			search1.show();
			return;
		});

		b6.clicked.connect (() => {
			// 修改代理端口
			if(port1.editable==false){
				port1.editable = true;
				b6.set_label(_("Save"));
			}else{
				port1.editable=false;
				b6.set_label(_("Modify"));
				var ret = rpc1.set_proxy( (uint16)port1.text.to_int64() );
				if(ret==false)
					Gtk.main_quit();
			}
		});
        strangers_btn.clicked.connect (() => {
			strangers1.show();
		});
        user_btn.clicked.connect (() => {
			// Emitted when the button has been activated:
			var dlg_user = new Gtk.MessageDialog(app, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK,null);
			dlg_user.text = this.uname+_(" Details");
			var sex=_("Man");
			if (this.usex==2)
				sex=_("Woman");
			var blog_dir = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S,Environment.get_home_dir(),"ChatShare");
            dlg_user.secondary_text = @"ID:$(this.uid)\n"+_("Age:")+@"$(this.uage)\n"+_("Sex:")+@"$(sex)\n"+_("Description:")+@"$(this.udesc)\n"
					+ _("Blog Directory:")+blog_dir;
            dlg_user.show();
            dlg_user.response.connect((rid)=>{
				dlg_user.destroy();
			});
		});
		this.entry1.activate.connect( ()=>{
			this.send_msg();
		} );
			
        b7.clicked.connect (() => {
			// 发送信息
			this.send_msg();
		});

		this.friends.row_selected.connect((r)=>{
			var id = r.name.to_int64();
			if (id==0)
				return;
			this.to = id;
			var u = this.frds1[id.to_string()];
			//stdout.printf(@"selected $(id) $(u.name) $(u.sex)\n");
			if (this.msgs!=null){
				this.msg_win.remove(this.msgs);
			}
			this.msgs = this.boxes[id.to_string()];
			this.msg_win.add(this.msgs);
			Gtk.Grid grid = this.frd_boxes[id.to_string()];
			var sc3 = grid.get_style_context();
			sc3.remove_provider(this.mark1);
			if ( sc3.has_class("mark") ){
				sc3.remove_class("mark");
				this.mark_num--;
				if (this.mark_num==0)
					app.clear_notify();
				app.title = _("Everyone Publish!")+@"($(this.mark_num))"+" - "+this.host;
				app.show_all();
			}else{
				this.msg_win.show_all();
			}
		});
	}
	public void send_msg(){
		// 发送信息
		if(this.to==0)
			return;
		if( false == rpc1.ChatTo(this.to,this.entry1.text) ){
			Gtk.main_quit();
		}
		//var u = this.frds1[this.uid.to_string()];
		this.add_left_name_icon(this.uname,this.usex);
		this.add_text(this.entry1.text);
		this.entry1.text = "";
		GLib.Idle.add(()=>{
			var adj1 = this.msgs.get_adjustment();
			adj1.value = adj1.upper;
			return false;
		});
	}
	public void update_pwd(){
		var dlg_pwd = new Gtk.Dialog.with_buttons(_("Update Password"),app,Gtk.DialogFlags.MODAL);
		var grid = new Gtk.Grid();
		grid.attach(new Gtk.Label(_("Input your new password")),0,0,2,1);
		
		grid.attach(new Gtk.Label(_("Old Password:")),0,1);
		var pwd1 = new Gtk.Entry();
		pwd1.set_visibility(false);
		grid.attach(pwd1,1,1);
		
		grid.attach(new Gtk.Label(_("New Password:")),0,2);
		var pwd2 = new Gtk.Entry();
		pwd2.set_visibility(false);
		grid.attach(pwd2,1,2);
		
		grid.attach(new Gtk.Label(_("Confirm Password:")),0,3);
		var pwd3 = new Gtk.Entry();
		pwd3.set_visibility(false);
		grid.attach(pwd3,1,3);
		
		var content = dlg_pwd.get_content_area () as Gtk.Box;
		content.pack_start(grid);
		
		dlg_pwd.add_button(_("Update"),2);
		dlg_pwd.add_button(_("Cancel"),3);
		
		dlg_pwd.response.connect((rid)=>{
			if(rid==3){
				dlg_pwd.destroy();
			}else if(rid==2){
				if (pwd2.text != pwd3.text){
					dlg_pwd.title = _("Confirm Fail!");
					return;
				}
				rpc1.update_pwd(this.uname,pwd1.text,pwd2.text);
				dlg_pwd.destroy();
			}
		});
		dlg_pwd.show_all();
	}
	Gee.HashMap<string,Gtk.ListBox?> boxes = new Gee.HashMap<string,Gtk.ListBox?>();
	//Gtk.ListBox hides = new Gtk.ListBox();
	public void add_listbox_id(int64 uid){
		var box = new Gtk.ListBox();
		this.boxes[uid.to_string()] = box;
		box.selection_mode = Gtk.SelectionMode.NONE;
		box.expand = true;
		box.border_width = 3;
		//this.msgs.modify_bg(Gtk.StateType.NORMAL,color1);
		//this.msg_win.add(box);
		var u1 = this.frds1[uid.to_string()];
		var t2 = new Gtk.Label(_("Chat To: ")+u1.name);
		box.add(t2);
		(t2.parent as Gtk.ListBoxRow).set_selectable(false);

		if (this.msgs!=null){
			this.msg_win.remove(this.msgs);
		}
		this.msgs = box;
		this.msg_win.add(this.msgs);
		this.to = uid;
		if (u1.timestamp_offline.length > 10){
			//insert offline message
			add_right_name_icon(u1.name,u1.sex);
			add_text(_("Rewrite Offline Message:")+@"[$(u1.timestamp_offline)]\n$(u1.msg_offline)");
			this.msg_mark(u1.id.to_string());
		}
		this.msg_win.show_all();

		var sc2 = box.get_style_context ();
		sc2.add_provider(this.cssp,Gtk.STYLE_PROVIDER_PRIORITY_USER);
	}

	public void release_resource(){
		this.running = false;
		//this.conn.close();
	}
	string pressed = "";
	public void add_friend(UserData user1){
		if(this.frds1.has_key(user1.id.to_string()))
			return;
		else
			this.frds1[user1.id.to_string()] = user1;
		if( false==rpc1.tell(user1.id) ){
			Gtk.main_quit();
		}
		string iconp;
		if (user1.sex==1)
			iconp = this.man_icon;
		else
			iconp = this.woman_icon;
		var pix1 = new Gdk.Pixbuf.from_file(iconp);
        var grid2 = new Gtk.Grid();
        var img2 = new Gtk.Image();
        img2.set_from_pixbuf(pix1);
        grid2.attach(img2,0,0);

        var l2 = new Gtk.Label(user1.name);
		l2.xalign = (float)0;
		l2.hexpand = true;
        grid2.attach(l2,1,0);

        var b2 = new Gtk.Button.with_label("WEB");
        b2.set_tooltip_text(@"http://localhost:$(server_port)");
        grid2.attach(b2,2,0);
        grid2.set_column_spacing(5);
        
        var b3 = new Gtk.Button.with_label("TCP");
        b3.set_tooltip_text(_("TCP Tunnel, PORT:")+@"$(server_port)");
        grid2.attach(b3,3,0);

        this.frd_boxes[@"$(user1.id)"] = grid2;
        this.friends.add(grid2);
        //var row2 = new Gtk.ListBoxRow();
        //row2.add(grid2);
        var row2 = grid2.get_parent() as Gtk.ListBoxRow;
        row2.name = @"$(user1.id)";
        //this.friends.add(row2);
        //grid2.parent.name = @"$(user1.id)";
        grid2.show_all();

        img2.tooltip_text = @"$(user1.age)岁\n$(user1.desc)";

        b2.clicked.connect(()=>{
			//stdout.printf(@"open %$(uint64.FORMAT)\n",user1.id);
			if( false == rpc1.set_http_id(user1.id) ){
				Gtk.main_quit();
			}
		});
		
		b3.clicked.connect(()=>{
			//stdout.printf(@"open %$(uint64.FORMAT)\n",user1.id);
			if( false == rpc1.set_tcp_id(user1.id) ){
				Gtk.main_quit();
			}
		});
		this.friends.button_release_event.connect((e)=>{
			if(e.button!=3)
				return false;

			//stdout.printf("button:%u %f\n",e.button,e.y);
			Gtk.ListBoxRow r = this.friends.get_row_at_y((int)e.y);
			this.friends.select_row(r);
			popup1.set_id( r.name );
			popup1.popup_at_pointer(e);
			return true;
		});

		this.add_listbox_id(user1.id);
	}
	public void remove_friend(string fid){
		var grid = this.frd_boxes[fid];
		this.frd_boxes.unset(fid);
		this.frds1.unset(fid);
		if( false == rpc1.remove_friend(fid.to_int64()) ){
			Gtk.main_quit();
		}
		//hide row
		Gtk.ListBoxRow r = grid.get_parent() as Gtk.ListBoxRow;
		r.set_selectable(false);
		r.name="";
		//r.hide();
		this.friends.remove( r );
	}
	public void add_right_name_icon(string name,int16 sex){
		string iconp;
		if (sex==1)
			iconp = this.man_icon;
		else
			iconp = this.woman_icon;
        var pix1 = new Gdk.Pixbuf.from_file(iconp);
        var grid2 = new Gtk.Grid();
        var img2 = new Gtk.Image();
        img2.set_from_pixbuf(pix1);
        grid2.attach(img2,1,0);
        grid2.halign = Gtk.Align.END;
		var l2 = new Gtk.Label(name);
		l2.xalign = (float)1;
        grid2.attach(l2,0,0);
        grid2.set_column_spacing(5);
		this.msgs.add(grid2);
		grid2.show_all();
    }
    public void add_left_name_icon(string name,int16 sex){
		string iconp;
		if (sex==1)
			iconp = this.man_icon;
		else
			iconp = this.woman_icon;
        var grid1 = new Gtk.Grid();
        var pix1 = new Gdk.Pixbuf.from_file(iconp);
        var img1 = new Gtk.Image();
        img1.set_from_pixbuf(pix1);
        grid1.attach(img1,0,0);
		var l1 = new Gtk.Label(name);
		l1.xalign = (float)0;
        grid1.attach(l1,1,0);
        grid1.set_column_spacing(5);
		this.msgs.add(grid1);
		grid1.show_all();
    }
    public void add_image(string pathname){
        var p1 = new Gdk.Pixbuf.from_file(pathname);
        var image = new Gtk.Image();
        if(p1.width>300){
            var xs = (double)300/(double)p1.width;
            var h2 = (int)(p1.height*xs);
            var p2 = new Gdk.Pixbuf(Gdk.Colorspace.RGB,true,8,300,h2);
            p1.scale(p2, 0, 0, 300, h2, 0.0, 0.0, xs, xs,Gdk.InterpType.NEAREST);
            image.set_from_pixbuf(p2);
        }else{
            image.set_from_pixbuf(p1);
        }
		this.msgs.add(image);
		image.show();
    }
    public void add_text(string text,bool center=false ,bool markup=false){
        var lb = new Gtk.Label("");
        if(markup){
			lb.set_markup(text);
			var sc1 = lb.get_style_context();
			sc1.add_provider(this.link_css1,Gtk.STYLE_PROVIDER_PRIORITY_USER);
		} else
			lb.set_label(text);
		lb.wrap = true;
        lb.wrap_mode = Pango.WrapMode.CHAR;
        if(!center){
            lb.xalign = (float)0;
        }
        lb.width_request = 300;
        lb.max_width_chars = 15;
        var grid=new Gtk.Grid();
        var lb1 = new Gtk.Label("");
        lb1.width_request = 5;
        grid.attach(lb1,0,0);
        grid.attach(lb,1,0);
        var lb2 = new Gtk.Label("");
        lb2.width_request = 5;
        grid.attach(lb2,2,0);
        grid.halign = Gtk.Align.CENTER;
		this.msgs.add(grid);
		grid.show_all();
    }
	private void add_operate_buttons(string pathname){
		var dir1 = GLib.Path.get_dirname(pathname);
		var grid = new Gtk.Grid();
		var lb1 = new Gtk.Label(" ");
		var lb2 = new Gtk.Label(" ");
		lb1.expand=true;
		lb2.expand=true;
		var bt_open = new Gtk.Button.with_label(_("OpenFile"));
		var bt_dir = new Gtk.Button.with_label(_("OpenDir"));
		var bt_del = new Gtk.Button.with_label(_("RemoveFile"));
		grid.attach(lb1,0,0);
		grid.attach(bt_open,1,0);
		grid.attach(bt_dir,2,0);
		grid.attach(bt_del,3,0);
		grid.attach(lb2,4,0);
		
		this.msgs.add( grid );
		grid.show_all();
		
		bt_open.clicked.connect(()=>{
			rpc1.open_path(pathname);
		});
		bt_dir.clicked.connect(()=>{
			rpc1.open_path(dir1);
		});
		bt_del.clicked.connect(()=>{
			GLib.FileUtils.remove(pathname);
		});
	}
	//callback in rpc msg
	public void rpc_callback(int8 typ,int64 from,string msg){
		//Msg　开头可以带着类型标记 JSON/TEXT
		//print(@"ID: $(from) ,Msg: $(msg)\n");
		//from==0  "Offline id"
		if(from==0){
			if(msg.length<=8){
				return;
			}
			if(msg[0:8]=="Offline "){
				string off_id = msg[8:msg.length];
				//print("ID:%s : %s\n",off_id,msg);
				var grid = this.frd_boxes[off_id];
				var sc = grid.get_style_context();
				sc.add_provider(this.provider1,Gtk.STYLE_PROVIDER_PRIORITY_USER);
				if (sc.has_class("off")==false){
					sc.add_class("off");
				}
				this.friends.invalidate_sort ();
				//show msg
				var tmp = this.msgs;
				this.msgs = this.boxes[off_id];
				this.add_text(_("[Offline]"),false);
				this.msgs = tmp;
				GLib.Idle.add(()=>{
					var adj1 = this.msgs.get_adjustment();
					adj1.value = adj1.upper;
					return false;
				});
				return;
			}
			//print("Cmd:%i From:%"+int64.FORMAT+" Msg:%s\n",typ,from,msg);
			return;
		}
		//from>0
		string typ1 = msg[0:4];
		string msg1 = msg[4:msg.length];
		string fname="";
		int16 fsex=2;
		var u = this.frds1[from.to_string()];
		var display = this.boxes[from.to_string()];
		var bak_msgs = this.msgs;
		if( u!=null ){
			//print(@"has_key:$(u.name)\n");
			fname = u.name;
			fsex = u.sex;
			this.msgs = display;
		}else if (typ1 == "TEXT"){
			fname = @"ID:$(from)";
			bool ret = rpc1.offline_msg_with_id(from,msg1,(ux)=>{
				strangers1.prepend_row(ux);
			});
			if (ret==false)
				Gtk.main_quit();
			this.msgs = bak_msgs;
			return;
		}else if(typ1=="JSON"){
			fname = @"ID:$(from)";
		}

		switch(typ1){
		case "TEXT":
			//GLib.Idle.add(()=>{
			//this.msgs = display;
			this.add_right_name_icon(fname,fsex);
			this.add_text(msg1);
			//this.msgs = bak_msgs;
				//return false;
			//});
			msg_mark(from.to_string());
			break;
		case "JSON":
			var p2 = new Json.Parser();
			if(p2.load_from_data(msg1)==false){
				break;
			}
			var node2 = p2.get_root();
			if (node2==null){
				break;
			}
			var obj2 = node2.get_object();
			string name1 = obj2.get_string_member("Name");
			string mime1 = obj2.get_string_member("Mime");
			this.add_right_name_icon(fname,fsex);
			if(mime1[0:5]=="image"){
				this.add_image(name1);
			}
			this.add_text(GLib.Path.get_basename(name1),true);
			add_operate_buttons(name1);
			msg_mark(from.to_string());
			this.msgs.show_all();
			break;
		case "LOGI":
			if( u==null )
				break;
			Gtk.Grid grid = this.frd_boxes[from.to_string()];
			var sc3 = grid.get_style_context();
			sc3.remove_provider(this.provider1);
			sc3.remove_class("off");
			this.friends.invalidate_sort ();
			break;
		}
		GLib.Idle.add(()=>{
			var adj1 = this.msgs.get_adjustment();
			adj1.value = adj1.upper;
			return false;
		});
		this.msgs = bak_msgs;
	}
	public void msg_mark(string uid){
		Gtk.ListBoxRow r = this.frd_boxes[uid].get_parent() as Gtk.ListBoxRow;
		if(app.counter%2==1){
			app.tray_notify();
		}
		if(r.is_selected())
			return;
		Gtk.Grid grid = this.frd_boxes[uid];
		var sc3 = grid.get_style_context();
		sc3.add_provider(this.mark1,Gtk.STYLE_PROVIDER_PRIORITY_USER);
		if ( sc3.has_class("mark")==false ){
			sc3.add_class("mark");
			this.mark_num++;
			if(this.mark_num==1)
				app.tray_notify();
			
			app.title = _("Everyone Publish!")+@"($(this.mark_num))"+" - "+this.host;
			app.show_all();
		}else{
			grid.show_all();
		}
		//print(@"mark: $(uid)\n");
	}
}

public class AppWin:Gtk.ApplicationWindow{
	Gtk.StatusIcon tray1;
	Gdk.Pixbuf icon1;
	Gdk.Pixbuf icon2;
	Gtk.VBox box1;
	Gtk.Application application1;
	public int counter=0;
	public AppWin(){
		// Sets the title of the Window:
		var dt1 = new DateTime.now_local();
		
		application1 = new Gtk.Application(@"app.powerchat.id$(dt1.to_unix())",GLib.ApplicationFlags.FLAGS_NONE);
		application1.register();
		application1.add_window(this as Gtk.Window);
		this.title = _("Everyone Publish!");

		// Center window at startup:
		this.window_position = Gtk.WindowPosition.CENTER;

		// Sets the default size of a window:
		this.set_default_size(640,480);
		// Whether the titlebar should be hidden during maximization.
		this.hide_titlebar_when_maximized = true;

        this.set_resizable(false);
        var icon_path = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S,prog_path,"..","share","icons","powerchat","tank.png");
        this.set_icon_from_file(icon_path);
        this.icon1 = new Gdk.Pixbuf.from_file(icon_path);
        this.icon2 = new Gdk.Pixbuf.from_file(GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S,prog_path,"..","share","icons","powerchat","msg.png"));
        this.tray1 = new Gtk.StatusIcon.from_pixbuf(this.icon1);
		this.tray1.set_visible(false);
		this.tray1.activate.connect(()=>{
			if (counter%2 == 0)
				this.hide();
			else
				this.show();
			counter++;
		});
		
		this.show.connect(()=>{
			this.tray1.set_visible(true);
			if(grid1.mark_num==0){
				this.clear_notify();
			}
		});
		// Method called on pressing [X]
		this.set_destroy_with_parent(false);
		this.delete_event.connect((e)=>{ 
			counter++;
			return this.hide_on_delete ();
		});
		this.box1 = new Gtk.VBox(false,0);
		this.add(this.box1);
		//this.create_menubar();
		setup_menubar();
	}
	public void update_tooltip(){
		this.tray1.set_tooltip_text(_("Everyone Publish!")+" - "+grid1.host+"\n"+_("(Click to Hide/Show)"));
	}
	public void tray_notify(){
		this.tray1.set_from_pixbuf(this.icon2);
	}
	public void clear_notify(){
		this.tray1.set_from_pixbuf(this.icon1);
	}
	public void append(Gtk.Widget w){
		this.box1.pack_start(w);
	}
	public void setup_menubar(){
        var menu1 = new GLib.Menu();
        var item1 = new GLib.MenuItem(_("Homepage"),"app.homepage");
        menu1.append_item(item1);
        
        item1 = new GLib.MenuItem(_("About"),"app.about");
        menu1.append_item(item1);
        
        item1 = new GLib.MenuItem(_("Pay"),"app.pay");
        menu1.append_item(item1);
        
        var menubar =new GLib.Menu();
        menubar.append_submenu(_("Help"),menu1);
        
        menu1 = new GLib.Menu();
        item1 = new GLib.MenuItem(_("PreviewWeb"),"app.preview-web");
        menu1.append_item(item1);
        
        item1 = new GLib.MenuItem(_("OpenBlogDir"),"app.blog-dir");
        menu1.append_item(item1);
        
        item1 = new GLib.MenuItem(_("Quit"),"app.quit");
        menu1.append_item(item1);
        
        menubar.append_submenu(_("Operate"),menu1);
        
        application1.set_menubar(menubar as GLib.MenuModel);
        
        add_actions();
    }
    private void add_actions () {
		SimpleAction act2 = new SimpleAction ("about", null);
		act2.activate.connect (() => {
			application1.hold ();
			var dlg_about = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK,null);
			dlg_about.text = _("Copy Right:");
            dlg_about.secondary_text = "Fu Huizhong <fuhuizn@163.com>";
            dlg_about.show();
            dlg_about.response.connect((rid)=>{
				dlg_about.destroy();
			});
			application1.release ();
		});
        act2.set_enabled(true);
		application1.add_action (act2);
		
		SimpleAction act3 = new SimpleAction ("homepage", null);
		act3.activate.connect (() => {
			application1.hold ();
			//Gtk.show_uri(null,"https://gitee.com/rocket049/powerchat",Gdk.CURRENT_TIME);
			rpc1.open_path("https://gitee.com/rocket049/powerchat");
			application1.release ();
		});
        act3.set_enabled(true);
		application1.add_action (act3);
		
		SimpleAction act4 = new SimpleAction ("pay", null);
		act4.activate.connect (() => {
			application1.hold ();
			//Gtk.show_uri(null,"https://gitee.com/rocket049/powerchat/wikis/powerchat?sort_id=1325779",Gdk.CURRENT_TIME);
			rpc1.open_path("https://gitee.com/rocket049/powerchat/wikis/powerchat?sort_id=1325779");
			application1.release ();
		});
        act4.set_enabled(true);
		application1.add_action (act4);
		
		SimpleAction act5 = new SimpleAction ("preview-web", null);
		act5.activate.connect (() => {
			application1.hold ();
			//Gtk.show_uri(null,@"http://localhost:$(proxy_port)/",Gdk.CURRENT_TIME);
			rpc1.open_path(@"http://localhost:$(proxy_port)/");
			application1.release ();
		});
        act5.set_enabled(true);
		application1.add_action (act5);
		
		SimpleAction act6 = new SimpleAction ("blog-dir", null);
		act6.activate.connect (() => {
			application1.hold ();
			var home1 = GLib.Environment.get_home_dir();
			var blog1 = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S,home1,"ChatShare");
			rpc1.open_path(blog1);
			application1.release ();
		});
        act6.set_enabled(true);
		application1.add_action (act6);
		
		SimpleAction act7 = new SimpleAction ("quit", null);
		act7.activate.connect (() => {
			application1.hold ();
			// Print "Bye!" to our console:
			print ("Bye!\n");
			grid1.release_resource();
			// Terminate the mainloop: (main returns 0)
			Gtk.main_quit ();
			application1.release ();
		});
        act7.set_enabled(true);
		application1.add_action (act7);
	}
}

public class LoginDialog :GLib.Object{
	public Gtk.Entry name;
	public Gtk.Entry passwd;
	public Gtk.Dialog dlg1;
	//public Thread<int> thread;
	public LoginDialog(){
		this.dlg1 = new Gtk.Dialog.with_buttons(_("login"),app,Gtk.DialogFlags.MODAL);
		var grid = new Gtk.Grid();
		grid.attach(new Gtk.Label(_("Input name and password:")),0,0,2,1);
		grid.attach(new Gtk.Label(_("Login Name：")),0,1,1,1);
		grid.attach(new Gtk.Label(_("Password：")),0,2,1,1);
		this.name = new Gtk.Entry();
		grid.attach(this.name,1,1,1,1);
		this.passwd = new Gtk.Entry();
		this.passwd.set_visibility(false);
		grid.attach(this.passwd,1,2,1,1);
		var content = this.dlg1.get_content_area () as Gtk.Box;
		content.pack_start(grid);
		content.show_all();
		this.dlg1.add_button(_("Login"),2);
		this.dlg1.add_button(_("Register"),4);
		this.dlg1.add_button(_("Cancel"),3);

		this.dlg1.response.connect((rid)=>{
			if (rid==2){
				//stdout.printf("next %d\n%s\n%s\n",rid,this.name.text,this.passwd.text);
				UserData u;
				var res = rpc1.login(this.name.text,this.passwd.text,out u);
				if (res>0){
					stdout.printf("login ok\n");
					grid1.uid = res;
					grid1.uname = u.name;
					grid1.usex = u.sex;
					grid1.uage = u.age;
					grid1.udesc = u.desc;
					grid1.user_btn.label = _("About: ")+u.name;
				}else{
					this.dlg1.title = _("Name/Password Error!");
					stdout.printf("login fail\n");
					return;
				}
				if(rpc1.get_friends_async()==false){
					print("RPC error");
					Gtk.main_quit();
				}
				app.show_all();
				this.dlg1.hide();
			}else if(rid==4){
				this.dlg1.hide();
				adduser1 = new AddUserDialog();
				adduser1.show();
			}else{
				Gtk.main_quit();
			}
		});
	}
	public int run(){
		return this.dlg1.run();
	}
	public void hide(){
		this.dlg1.hide();
	}
}
public static string prog_path;
public void set_my_locale(string path1){
	var dir1 = GLib.Path.get_dirname(path1);
	prog_path = dir1;
	var textpath = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S,prog_path,"..","share","locale");
	GLib.Intl.setlocale(GLib.LocaleCategory.ALL,"");
	GLib.Intl.textdomain("powerchat");
	GLib.Intl.bindtextdomain("powerchat",textpath);
	GLib.Intl.bind_textdomain_codeset ("powerchat", "UTF-8");
}
static uint16 server_port=7890;
static uint16 proxy_port;
public static int main(string[] args){
	set_my_locale(args[0]);
	if (!Thread.supported()) {
		stderr.printf("Cannot run without threads.\n");
		return 1;
	}
	if(args.length==2){
		server_port = (uint16)args[1].to_int64();
	}
	//proxy_port = server_port + 2000;
	rpc1 = new RpcClient();
	if (rpc1.connect("localhost",server_port)==false){
		return -1;
	}
	rpc1.c.notification.connect((s,m,p)=>{
		//stdout.printf("notify: %s\n",m);
		if (m!="msg")
			return;
		try{
			var typ = (int8) p.lookup_value("T",null).get_int64();
			var from = p.lookup_value("From",null).get_int64();
			var msg = p.lookup_value("Msg",null).get_string();
			grid1.rpc_callback(typ,from,msg);
		}catch(Error e){
			stdout.printf ("Error: %s\n", e.message);
		}
	});

	Gtk.init(ref args);
	grid1 = new MyGrid();
	app = new AppWin();
	app.append(grid1.mygrid);

	login1 = new LoginDialog();
	login1.dlg1.show_all();

	popup1 = new MyFriendMenu();
	GLib.Timeout.add_seconds(60,()=>{
		rpc1.ping();
		return true;
	});
	Gtk.main ();
	rpc1.quit();
	rpc1.c.close();
	return 0;
}
