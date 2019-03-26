/* strangers.vala.c generated by valac 0.42.6, the Vala compiler
 * generated from strangers.vala, do not modify */



#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <stdlib.h>
#include <string.h>
#include <glib/gi18n-lib.h>
#include <gee.h>


#define TYPE_STRANGERS_DIALG (strangers_dialg_get_type ())
#define STRANGERS_DIALG(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_STRANGERS_DIALG, StrangersDialg))
#define STRANGERS_DIALG_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_STRANGERS_DIALG, StrangersDialgClass))
#define IS_STRANGERS_DIALG(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_STRANGERS_DIALG))
#define IS_STRANGERS_DIALG_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_STRANGERS_DIALG))
#define STRANGERS_DIALG_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_STRANGERS_DIALG, StrangersDialgClass))

typedef struct _StrangersDialg StrangersDialg;
typedef struct _StrangersDialgClass StrangersDialgClass;
typedef struct _StrangersDialgPrivate StrangersDialgPrivate;

#define TYPE_USER_MSG (user_msg_get_type ())
typedef struct _UserMsg UserMsg;
enum  {
	STRANGERS_DIALG_0_PROPERTY,
	STRANGERS_DIALG_NUM_PROPERTIES
};
static GParamSpec* strangers_dialg_properties[STRANGERS_DIALG_NUM_PROPERTIES];
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

#define TYPE_APP_WIN (app_win_get_type ())
#define APP_WIN(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_APP_WIN, AppWin))
#define APP_WIN_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_APP_WIN, AppWinClass))
#define IS_APP_WIN(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_APP_WIN))
#define IS_APP_WIN_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_APP_WIN))
#define APP_WIN_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_APP_WIN, AppWinClass))

typedef struct _AppWin AppWin;
typedef struct _AppWinClass AppWinClass;

#define TYPE_CHAT_CLIENT (chat_client_get_type ())
#define CHAT_CLIENT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_CHAT_CLIENT, ChatClient))
#define CHAT_CLIENT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_CHAT_CLIENT, ChatClientClass))
#define IS_CHAT_CLIENT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_CHAT_CLIENT))
#define IS_CHAT_CLIENT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_CHAT_CLIENT))
#define CHAT_CLIENT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_CHAT_CLIENT, ChatClientClass))

typedef struct _ChatClient ChatClient;
typedef struct _ChatClientClass ChatClientClass;

#define TYPE_MY_GRID (my_grid_get_type ())
#define MY_GRID(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_MY_GRID, MyGrid))
#define MY_GRID_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_MY_GRID, MyGridClass))
#define IS_MY_GRID(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_MY_GRID))
#define IS_MY_GRID_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_MY_GRID))
#define MY_GRID_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_MY_GRID, MyGridClass))

typedef struct _MyGrid MyGrid;
typedef struct _MyGridClass MyGridClass;
#define _g_free0(var) (var = (g_free (var), NULL))
typedef struct _MyGridPrivate MyGridPrivate;

struct _UserMsg {
	gint64 id;
	gint sex;
	gchar* name;
	gchar* desc;
	gint age;
	gchar* msg_offline;
	gchar* timestamp_offline;
};

struct _StrangersDialg {
	GObject parent_instance;
	StrangersDialgPrivate * priv;
	GtkDialog* dlg1;
	GtkEntry* key1;
	GtkListStore* store1;
	GList* persons;
};

struct _StrangersDialgClass {
	GObjectClass parent_class;
};

struct _MyGrid {
	GObject parent_instance;
	MyGridPrivate * priv;
	GtkEntry* port1;
	GtkGrid* mygrid;
	GeeHashMap* frds1;
	GtkCssProvider* provider1;
	GtkCssProvider* mark1;
	GtkCssProvider* name_css;
	gint mark_num;
	GtkCssProvider* button1;
	GtkCssProvider* link_css1;
	GtkButton* strangers_btn;
	GtkButton* user_btn;
	GtkButton* msend_btn;
	gchar* man_icon;
	gchar* woman_icon;
	gint64 uid;
	gint16 usex;
	gchar* uname;
	gchar* udesc;
	gint16 uage;
	gchar* host;
};

struct _MyGridClass {
	GObjectClass parent_class;
};


extern StrangersDialg* strangers1;
StrangersDialg* strangers1 = NULL;
static gpointer strangers_dialg_parent_class = NULL;
extern AppWin* app;
extern ChatClient* client;
extern MyGrid* grid1;

GType strangers_dialg_get_type (void) G_GNUC_CONST;
GType user_msg_get_type (void) G_GNUC_CONST;
UserMsg* user_msg_dup (const UserMsg* self);
void user_msg_free (UserMsg* self);
void user_msg_copy (const UserMsg* self,
                    UserMsg* dest);
void user_msg_destroy (UserMsg* self);
static void _user_msg_free0_ (gpointer var);
static inline void _g_list_free__user_msg_free0_ (GList* self);
StrangersDialg* strangers_dialg_new (void);
StrangersDialg* strangers_dialg_construct (GType object_type);
static void strangers_dialg_get_msgs (StrangersDialg* self);
void strangers_dialg_create_dialg (StrangersDialg* self);
GType app_win_get_type (void) G_GNUC_CONST;
static void __lambda14_ (StrangersDialg* self,
                  gint rid);
static gboolean __lambda15_ (StrangersDialg* self,
                      GtkTreeModel* m,
                      GtkTreePath* p,
                      GtkTreeIter* iter);
static gboolean ___lambda15__gtk_tree_model_foreach_func (GtkTreeModel* model,
                                                   GtkTreePath* path,
                                                   GtkTreeIter* iter,
                                                   gpointer self);
static void ___lambda14__gtk_dialog_response (GtkDialog* _sender,
                                       gint response_id,
                                       gpointer self);
static void __lambda16_ (StrangersDialg* self,
                  GtkTreeView* tree,
                  GtkTreePath* path,
                  GtkTreeViewColumn* col);
GType chat_client_get_type (void) G_GNUC_CONST;
void chat_client_move_stranger_to_friend (ChatClient* self,
                                          gint64 fid);
GType my_grid_get_type (void) G_GNUC_CONST;
void my_grid_add_friend (MyGrid* self,
                         UserMsg* user1,
                         gboolean tell);
static void ___lambda16__gtk_tree_view_row_activated (GtkTreeView* _sender,
                                               GtkTreePath* path,
                                               GtkTreeViewColumn* column,
                                               gpointer self);
void strangers_dialg_add_row (StrangersDialg* self,
                              UserMsg* u1);
void strangers_dialg_prepend_row (StrangersDialg* self,
                                  UserMsg* u1);
void chat_client_get_stranger_msgs_async (ChatClient* self);
void strangers_dialg_show (StrangersDialg* self);
static void strangers_dialg_finalize (GObject * obj);


static void
_user_msg_free0_ (gpointer var)
{
	(var == NULL) ? NULL : (var = (user_msg_free (var), NULL));
}


static inline void
_g_list_free__user_msg_free0_ (GList* self)
{
	g_list_free_full (self, (GDestroyNotify) _user_msg_free0_);
}


StrangersDialg*
strangers_dialg_construct (GType object_type)
{
	StrangersDialg * self = NULL;
	GtkListStore* _tmp0_;
	self = (StrangersDialg*) g_object_new (object_type, NULL);
	_tmp0_ = gtk_list_store_new (8, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_INT64, G_TYPE_STRING, G_TYPE_INT, G_TYPE_STRING, G_TYPE_STRING, -1);
	_g_object_unref0 (self->store1);
	self->store1 = _tmp0_;
	strangers_dialg_get_msgs (self);
	return self;
}


StrangersDialg*
strangers_dialg_new (void)
{
	return strangers_dialg_construct (TYPE_STRANGERS_DIALG);
}


static gpointer
_g_object_ref0 (gpointer self)
{
	return self ? g_object_ref (self) : NULL;
}


static gboolean
__lambda15_ (StrangersDialg* self,
             GtkTreeModel* m,
             GtkTreePath* p,
             GtkTreeIter* iter)
{
	gboolean result = FALSE;
	GtkListStore* _tmp0_;
	GtkTreeIter _tmp1_;
	g_return_val_if_fail (m != NULL, FALSE);
	g_return_val_if_fail (p != NULL, FALSE);
	g_return_val_if_fail (iter != NULL, FALSE);
	_tmp0_ = self->store1;
	_tmp1_ = *iter;
	gtk_list_store_set (_tmp0_, &_tmp1_, 7, "#FFFFFF", -1);
	result = FALSE;
	return result;
}


static gboolean
___lambda15__gtk_tree_model_foreach_func (GtkTreeModel* model,
                                          GtkTreePath* path,
                                          GtkTreeIter* iter,
                                          gpointer self)
{
	gboolean result;
	result = __lambda15_ ((StrangersDialg*) self, model, path, iter);
	return result;
}


static void
__lambda14_ (StrangersDialg* self,
             gint rid)
{
	GtkDialog* _tmp0_;
	GtkListStore* _tmp1_;
	_tmp0_ = self->dlg1;
	g_signal_emit_by_name (_tmp0_, "close");
	_tmp1_ = self->store1;
	gtk_tree_model_foreach (G_TYPE_CHECK_INSTANCE_TYPE (_tmp1_, gtk_tree_model_get_type ()) ? ((GtkTreeModel*) _tmp1_) : NULL, ___lambda15__gtk_tree_model_foreach_func, self);
}


static void
___lambda14__gtk_dialog_response (GtkDialog* _sender,
                                  gint response_id,
                                  gpointer self)
{
	__lambda14_ ((StrangersDialg*) self, response_id);
}


static void
__lambda16_ (StrangersDialg* self,
             GtkTreeView* tree,
             GtkTreePath* path,
             GtkTreeViewColumn* col)
{
	GtkTreeIter iter = {0};
	GtkTreeModel* model = NULL;
	GtkTreeModel* _tmp0_;
	GtkTreeModel* _tmp1_;
	GtkTreeModel* _tmp2_;
	GtkTreeIter _tmp3_ = {0};
	GValue idv = {0};
	GValue _tmp4_ = {0};
	GtkTreeModel* _tmp5_;
	GtkTreeIter _tmp6_;
	GValue _tmp7_ = {0};
	gint64 id = 0LL;
	ChatClient* _tmp8_;
	gint64 _tmp9_;
	GList* _tmp10_;
	g_return_if_fail (tree != NULL);
	g_return_if_fail (path != NULL);
	g_return_if_fail (col != NULL);
	_tmp0_ = gtk_tree_view_get_model (tree);
	_tmp1_ = _g_object_ref0 (_tmp0_);
	model = _tmp1_;
	_tmp2_ = model;
	gtk_tree_model_get_iter (_tmp2_, &_tmp3_, path);
	iter = _tmp3_;
	g_value_init (&_tmp4_, G_TYPE_INT64);
	idv = _tmp4_;
	_tmp5_ = model;
	_tmp6_ = iter;
	gtk_tree_model_get_value (_tmp5_, &_tmp6_, 3, &_tmp7_);
	G_IS_VALUE (&idv) ? (g_value_unset (&idv), NULL) : NULL;
	idv = _tmp7_;
	id = g_value_get_int64 (&idv);
	_tmp8_ = client;
	_tmp9_ = id;
	chat_client_move_stranger_to_friend (_tmp8_, _tmp9_);
	_tmp10_ = self->persons;
	{
		GList* u_collection = NULL;
		GList* u_it = NULL;
		u_collection = _tmp10_;
		for (u_it = u_collection; u_it != NULL; u_it = u_it->next) {
			UserMsg _tmp11_ = {0};
			UserMsg u = {0};
			user_msg_copy ((UserMsg*) u_it->data, &_tmp11_);
			u = _tmp11_;
			{
				UserMsg _tmp12_;
				gint64 _tmp13_;
				gint64 _tmp14_;
				_tmp12_ = u;
				_tmp13_ = _tmp12_.id;
				_tmp14_ = id;
				if (_tmp13_ == _tmp14_) {
					MyGrid* _tmp15_;
					UserMsg _tmp16_;
					_tmp15_ = grid1;
					_tmp16_ = u;
					my_grid_add_friend (_tmp15_, &_tmp16_, TRUE);
				}
				user_msg_destroy (&u);
			}
		}
	}
	G_IS_VALUE (&idv) ? (g_value_unset (&idv), NULL) : NULL;
	_g_object_unref0 (model);
}


static void
___lambda16__gtk_tree_view_row_activated (GtkTreeView* _sender,
                                          GtkTreePath* path,
                                          GtkTreeViewColumn* column,
                                          gpointer self)
{
	__lambda16_ ((StrangersDialg*) self, _sender, path, column);
}


void
strangers_dialg_create_dialg (StrangersDialg* self)
{
	AppWin* _tmp0_;
	GtkDialog* _tmp1_;
	GtkTreeView* view = NULL;
	GtkListStore* _tmp2_;
	GtkTreeView* _tmp3_;
	GtkCellRendererText* _tmp4_;
	GtkCellRendererText* _tmp5_;
	GtkCellRendererText* _tmp6_;
	GtkCellRendererText* _tmp7_;
	GtkCellRendererText* _tmp8_;
	GtkCellRendererText* _tmp9_;
	GtkCellRendererText* _tmp10_;
	GtkCellRendererText* _tmp11_;
	GtkCellRendererText* _tmp12_;
	GtkCellRendererText* _tmp13_;
	GtkCellRendererText* _tmp14_;
	GtkCellRendererText* _tmp15_;
	GtkCellRendererText* _tmp16_;
	GtkCellRendererText* _tmp17_;
	GtkScrolledWindow* scroll1 = NULL;
	GtkScrolledWindow* _tmp18_;
	GtkBox* content = NULL;
	GtkDialog* _tmp19_;
	GtkBox* _tmp20_;
	GtkBox* _tmp21_;
	GtkDialog* _tmp22_;
	GtkDialog* _tmp23_;
	g_return_if_fail (self != NULL);
	_tmp0_ = app;
	_tmp1_ = (GtkDialog*) gtk_dialog_new_with_buttons (_ ("Information of Strangers"), (GtkWindow*) _tmp0_, GTK_DIALOG_MODAL, NULL);
	g_object_ref_sink (_tmp1_);
	_g_object_unref0 (self->dlg1);
	self->dlg1 = _tmp1_;
	_tmp2_ = self->store1;
	_tmp3_ = (GtkTreeView*) gtk_tree_view_new_with_model ((GtkTreeModel*) _tmp2_);
	g_object_ref_sink (_tmp3_);
	view = _tmp3_;
	_tmp4_ = (GtkCellRendererText*) gtk_cell_renderer_text_new ();
	g_object_ref_sink (_tmp4_);
	_tmp5_ = _tmp4_;
	gtk_tree_view_insert_column_with_attributes (view, 0, _ ("Name"), (GtkCellRenderer*) _tmp5_, "text", 0, "background", 7, NULL);
	_g_object_unref0 (_tmp5_);
	_tmp6_ = (GtkCellRendererText*) gtk_cell_renderer_text_new ();
	g_object_ref_sink (_tmp6_);
	_tmp7_ = _tmp6_;
	gtk_tree_view_insert_column_with_attributes (view, 1, _ ("Said"), (GtkCellRenderer*) _tmp7_, "text", 1, "background", 7, NULL);
	_g_object_unref0 (_tmp7_);
	_tmp8_ = (GtkCellRendererText*) gtk_cell_renderer_text_new ();
	g_object_ref_sink (_tmp8_);
	_tmp9_ = _tmp8_;
	gtk_tree_view_insert_column_with_attributes (view, 2, _ ("Time"), (GtkCellRenderer*) _tmp9_, "text", 2, "background", 7, NULL);
	_g_object_unref0 (_tmp9_);
	_tmp10_ = (GtkCellRendererText*) gtk_cell_renderer_text_new ();
	g_object_ref_sink (_tmp10_);
	_tmp11_ = _tmp10_;
	gtk_tree_view_insert_column_with_attributes (view, 3, "ID", (GtkCellRenderer*) _tmp11_, "text", 3, "background", 7, NULL);
	_g_object_unref0 (_tmp11_);
	_tmp12_ = (GtkCellRendererText*) gtk_cell_renderer_text_new ();
	g_object_ref_sink (_tmp12_);
	_tmp13_ = _tmp12_;
	gtk_tree_view_insert_column_with_attributes (view, 4, _ ("Sex"), (GtkCellRenderer*) _tmp13_, "text", 4, "background", 7, NULL);
	_g_object_unref0 (_tmp13_);
	_tmp14_ = (GtkCellRendererText*) gtk_cell_renderer_text_new ();
	g_object_ref_sink (_tmp14_);
	_tmp15_ = _tmp14_;
	gtk_tree_view_insert_column_with_attributes (view, 5, _ ("Age"), (GtkCellRenderer*) _tmp15_, "text", 5, "background", 7, NULL);
	_g_object_unref0 (_tmp15_);
	_tmp16_ = (GtkCellRendererText*) gtk_cell_renderer_text_new ();
	g_object_ref_sink (_tmp16_);
	_tmp17_ = _tmp16_;
	gtk_tree_view_insert_column_with_attributes (view, 6, _ ("Description"), (GtkCellRenderer*) _tmp17_, "text", 6, "background", 7, NULL);
	_g_object_unref0 (_tmp17_);
	gtk_tree_view_set_headers_visible (view, TRUE);
	gtk_widget_show_all ((GtkWidget*) view);
	_tmp18_ = (GtkScrolledWindow*) gtk_scrolled_window_new (NULL, NULL);
	g_object_ref_sink (_tmp18_);
	scroll1 = _tmp18_;
	gtk_container_add ((GtkContainer*) scroll1, (GtkWidget*) view);
	gtk_widget_set_size_request ((GtkWidget*) scroll1, 480, 480);
	g_object_set ((GtkWidget*) view, "expand", TRUE, NULL);
	g_object_set ((GtkWidget*) scroll1, "expand", TRUE, NULL);
	_tmp19_ = self->dlg1;
	_tmp20_ = gtk_dialog_get_content_area (_tmp19_);
	_tmp21_ = _g_object_ref0 (G_TYPE_CHECK_INSTANCE_TYPE (_tmp20_, gtk_box_get_type ()) ? ((GtkBox*) _tmp20_) : NULL);
	content = _tmp21_;
	gtk_box_pack_start (content, (GtkWidget*) scroll1, TRUE, TRUE, (guint) 0);
	_tmp22_ = self->dlg1;
	gtk_dialog_add_button (_tmp22_, _ ("Close"), 2);
	_tmp23_ = self->dlg1;
	g_signal_connect_object (_tmp23_, "response", (GCallback) ___lambda14__gtk_dialog_response, self, 0);
	g_signal_connect_object (view, "row-activated", (GCallback) ___lambda16__gtk_tree_view_row_activated, self, 0);
	_g_object_unref0 (content);
	_g_object_unref0 (scroll1);
	_g_object_unref0 (view);
}


static gpointer
_user_msg_dup0 (gpointer self)
{
	return self ? user_msg_dup (self) : NULL;
}


void
strangers_dialg_add_row (StrangersDialg* self,
                         UserMsg* u1)
{
	UserMsg _tmp0_;
	UserMsg _tmp1_;
	UserMsg* _tmp2_;
	GtkTreeIter iter = {0};
	GtkListStore* _tmp3_;
	GtkTreeIter _tmp4_ = {0};
	gchar* sex = NULL;
	gchar* _tmp5_;
	UserMsg _tmp6_;
	gint _tmp7_;
	GtkListStore* _tmp12_;
	GtkTreeIter _tmp13_;
	UserMsg _tmp14_;
	const gchar* _tmp15_;
	UserMsg _tmp16_;
	const gchar* _tmp17_;
	UserMsg _tmp18_;
	const gchar* _tmp19_;
	UserMsg _tmp20_;
	gint64 _tmp21_;
	const gchar* _tmp22_;
	UserMsg _tmp23_;
	gint _tmp24_;
	UserMsg _tmp25_;
	const gchar* _tmp26_;
	g_return_if_fail (self != NULL);
	g_return_if_fail (u1 != NULL);
	_tmp0_ = *u1;
	_tmp1_ = _tmp0_;
	_tmp2_ = _user_msg_dup0 (&_tmp1_);
	self->persons = g_list_append (self->persons, _tmp2_);
	_tmp3_ = self->store1;
	gtk_list_store_append (_tmp3_, &_tmp4_);
	iter = _tmp4_;
	_tmp5_ = g_strdup (_ ("Unknown"));
	sex = _tmp5_;
	_tmp6_ = *u1;
	_tmp7_ = _tmp6_.sex;
	if (_tmp7_ == 1) {
		gchar* _tmp8_;
		_tmp8_ = g_strdup (_ ("Man"));
		_g_free0 (sex);
		sex = _tmp8_;
	} else {
		UserMsg _tmp9_;
		gint _tmp10_;
		_tmp9_ = *u1;
		_tmp10_ = _tmp9_.sex;
		if (_tmp10_ == 2) {
			gchar* _tmp11_;
			_tmp11_ = g_strdup (_ ("Woman"));
			_g_free0 (sex);
			sex = _tmp11_;
		}
	}
	_tmp12_ = self->store1;
	_tmp13_ = iter;
	_tmp14_ = *u1;
	_tmp15_ = _tmp14_.name;
	_tmp16_ = *u1;
	_tmp17_ = _tmp16_.msg_offline;
	_tmp18_ = *u1;
	_tmp19_ = _tmp18_.timestamp_offline;
	_tmp20_ = *u1;
	_tmp21_ = _tmp20_.id;
	_tmp22_ = sex;
	_tmp23_ = *u1;
	_tmp24_ = _tmp23_.age;
	_tmp25_ = *u1;
	_tmp26_ = _tmp25_.desc;
	gtk_list_store_set (_tmp12_, &_tmp13_, 0, _tmp15_, 1, _tmp17_, 2, _tmp19_, 3, _tmp21_, 4, _tmp22_, 5, _tmp24_, 6, _tmp26_, 7, "#FFFFFF", -1);
	_g_free0 (sex);
}


void
strangers_dialg_prepend_row (StrangersDialg* self,
                             UserMsg* u1)
{
	UserMsg _tmp0_;
	UserMsg _tmp1_;
	UserMsg* _tmp2_;
	GtkTreeIter iter = {0};
	GtkListStore* _tmp3_;
	GtkTreeIter _tmp4_ = {0};
	gchar* sex = NULL;
	gchar* _tmp5_;
	UserMsg _tmp6_;
	gint _tmp7_;
	GtkListStore* _tmp12_;
	GtkTreeIter _tmp13_;
	UserMsg _tmp14_;
	const gchar* _tmp15_;
	UserMsg _tmp16_;
	const gchar* _tmp17_;
	UserMsg _tmp18_;
	const gchar* _tmp19_;
	UserMsg _tmp20_;
	gint64 _tmp21_;
	const gchar* _tmp22_;
	UserMsg _tmp23_;
	gint _tmp24_;
	UserMsg _tmp25_;
	const gchar* _tmp26_;
	GtkStyleContext* sc1 = NULL;
	MyGrid* _tmp27_;
	GtkButton* _tmp28_;
	GtkStyleContext* _tmp29_;
	GtkStyleContext* _tmp30_;
	MyGrid* _tmp31_;
	GtkCssProvider* _tmp32_;
	g_return_if_fail (self != NULL);
	g_return_if_fail (u1 != NULL);
	_tmp0_ = *u1;
	_tmp1_ = _tmp0_;
	_tmp2_ = _user_msg_dup0 (&_tmp1_);
	self->persons = g_list_prepend (self->persons, _tmp2_);
	_tmp3_ = self->store1;
	gtk_list_store_prepend (_tmp3_, &_tmp4_);
	iter = _tmp4_;
	_tmp5_ = g_strdup (_ ("Unknown"));
	sex = _tmp5_;
	_tmp6_ = *u1;
	_tmp7_ = _tmp6_.sex;
	if (_tmp7_ == 1) {
		gchar* _tmp8_;
		_tmp8_ = g_strdup (_ ("Man"));
		_g_free0 (sex);
		sex = _tmp8_;
	} else {
		UserMsg _tmp9_;
		gint _tmp10_;
		_tmp9_ = *u1;
		_tmp10_ = _tmp9_.sex;
		if (_tmp10_ == 2) {
			gchar* _tmp11_;
			_tmp11_ = g_strdup (_ ("Woman"));
			_g_free0 (sex);
			sex = _tmp11_;
		}
	}
	_tmp12_ = self->store1;
	_tmp13_ = iter;
	_tmp14_ = *u1;
	_tmp15_ = _tmp14_.name;
	_tmp16_ = *u1;
	_tmp17_ = _tmp16_.msg_offline;
	_tmp18_ = *u1;
	_tmp19_ = _tmp18_.timestamp_offline;
	_tmp20_ = *u1;
	_tmp21_ = _tmp20_.id;
	_tmp22_ = sex;
	_tmp23_ = *u1;
	_tmp24_ = _tmp23_.age;
	_tmp25_ = *u1;
	_tmp26_ = _tmp25_.desc;
	gtk_list_store_set (_tmp12_, &_tmp13_, 0, _tmp15_, 1, _tmp17_, 2, _tmp19_, 3, _tmp21_, 4, _tmp22_, 5, _tmp24_, 6, _tmp26_, 7, "#F75656", -1);
	_tmp27_ = grid1;
	_tmp28_ = _tmp27_->strangers_btn;
	_tmp29_ = gtk_widget_get_style_context ((GtkWidget*) _tmp28_);
	_tmp30_ = _g_object_ref0 (_tmp29_);
	sc1 = _tmp30_;
	_tmp31_ = grid1;
	_tmp32_ = _tmp31_->button1;
	gtk_style_context_add_provider (sc1, (GtkStyleProvider*) _tmp32_, (guint) GTK_STYLE_PROVIDER_PRIORITY_USER);
	gtk_style_context_add_class (sc1, "off");
	_g_object_unref0 (sc1);
	_g_free0 (sex);
}


static void
strangers_dialg_get_msgs (StrangersDialg* self)
{
	ChatClient* _tmp0_;
	MyGrid* _tmp1_;
	GtkButton* _tmp2_;
	g_return_if_fail (self != NULL);
	(self->persons == NULL) ? NULL : (self->persons = (_g_list_free__user_msg_free0_ (self->persons), NULL));
	self->persons = NULL;
	_tmp0_ = client;
	chat_client_get_stranger_msgs_async (_tmp0_);
	_tmp1_ = grid1;
	_tmp2_ = _tmp1_->strangers_btn;
	gtk_widget_show_all ((GtkWidget*) _tmp2_);
}


void
strangers_dialg_show (StrangersDialg* self)
{
	GtkStyleContext* sc1 = NULL;
	MyGrid* _tmp0_;
	GtkButton* _tmp1_;
	GtkStyleContext* _tmp2_;
	GtkStyleContext* _tmp3_;
	MyGrid* _tmp4_;
	GtkCssProvider* _tmp5_;
	GtkDialog* _tmp6_;
	g_return_if_fail (self != NULL);
	strangers_dialg_create_dialg (self);
	_tmp0_ = grid1;
	_tmp1_ = _tmp0_->strangers_btn;
	_tmp2_ = gtk_widget_get_style_context ((GtkWidget*) _tmp1_);
	_tmp3_ = _g_object_ref0 (_tmp2_);
	sc1 = _tmp3_;
	_tmp4_ = grid1;
	_tmp5_ = _tmp4_->button1;
	gtk_style_context_remove_provider (sc1, (GtkStyleProvider*) _tmp5_);
	gtk_style_context_remove_class (sc1, "off");
	_tmp6_ = self->dlg1;
	gtk_widget_show_all ((GtkWidget*) _tmp6_);
	_g_object_unref0 (sc1);
}


static void
strangers_dialg_class_init (StrangersDialgClass * klass)
{
	strangers_dialg_parent_class = g_type_class_peek_parent (klass);
	G_OBJECT_CLASS (klass)->finalize = strangers_dialg_finalize;
}


static void
strangers_dialg_instance_init (StrangersDialg * self)
{
}


static void
strangers_dialg_finalize (GObject * obj)
{
	StrangersDialg * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, TYPE_STRANGERS_DIALG, StrangersDialg);
	_g_object_unref0 (self->dlg1);
	_g_object_unref0 (self->key1);
	_g_object_unref0 (self->store1);
	(self->persons == NULL) ? NULL : (self->persons = (_g_list_free__user_msg_free0_ (self->persons), NULL));
	G_OBJECT_CLASS (strangers_dialg_parent_class)->finalize (obj);
}


GType
strangers_dialg_get_type (void)
{
	static volatile gsize strangers_dialg_type_id__volatile = 0;
	if (g_once_init_enter (&strangers_dialg_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (StrangersDialgClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) strangers_dialg_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (StrangersDialg), 0, (GInstanceInitFunc) strangers_dialg_instance_init, NULL };
		GType strangers_dialg_type_id;
		strangers_dialg_type_id = g_type_register_static (G_TYPE_OBJECT, "StrangersDialg", &g_define_type_info, 0);
		g_once_init_leave (&strangers_dialg_type_id__volatile, strangers_dialg_type_id);
	}
	return strangers_dialg_type_id__volatile;
}



