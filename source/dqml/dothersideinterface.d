module dqml.dothersideinterface;

extern(C)
{
    // QCoreApplication
    char* dos_qcoreapplication_application_dir_path();

    // QApplication
    void dos_qapplication_create();
    void dos_qapplication_exec();
    void dos_qapplication_delete();
    void dos_qapplication_quit();

    // QGuiApplication
    void dos_qguiapplication_create();
    void dos_qguiapplication_exec();
    void dos_qguiapplication_delete();
    void dos_qguiapplication_quit();

    // QQmlApplicationEngine
    void* dos_qqmlapplicationengine_create();
    void  dos_qqmlapplicationengine_load(void*, immutable (char)* filename);
    void  dos_qqmlapplicationengine_load_url(void*, void*);
    void  dos_qqmlapplicationengine_load_data(void*, immutable (char)* data);
    void  dos_qqmlapplicationengine_add_import_path(void* vptr, immutable (char)* path);
    void* dos_qqmlapplicationengine_context(void*);
    void  dos_qqmlapplicationengine_delete(void*);

    // QQuickView
    void* dos_qquickview_create();
    void  dos_qquickview_show(void*);
    char* dos_qquickview_source(void*);
    void  dos_qquickview_set_source(void*, immutable (char)* filename);
    void  dos_qquickview_set_source_url(void*, void*);
    void  dos_qquickview_set_resize_mode(void*, int);
    void* dos_qquickview_rootContext(void*);
    void  dos_qquickview_delete(void*);

    // CharArray
    void dos_chararray_delete(char*);

    // QQmlContext
    char* dos_qqmlcontext_baseUrl(void*);
    void  dos_qqmlcontext_setcontextproperty(void*, immutable (char)*, void*);

    // QVariant
    void*  dos_qvariant_create();
    void*  dos_qvariant_create_int(int);
    void*  dos_qvariant_create_bool(bool);
    void*  dos_qvariant_create_string(immutable(char)*);
    void*  dos_qvariant_create_qobject(void*);
    void*  dos_qvariant_create_float(float);
    void*  dos_qvariant_create_double(double);
    void*  dos_qvariant_create_qvariant(void*);
    int    dos_qvariant_toInt(void*);
    bool   dos_qvariant_toBool(void*);
    char*  dos_qvariant_toString(void*);
    float  dos_qvariant_toFloat(void*);
    double dos_qvariant_toDouble(void*);
    void*  dos_qvariant_toQObject(void*);
    void   dos_qvariant_setInt(void*, int);
    void   dos_qvariant_setBool(void*, bool);
    void   dos_qvariant_setString(void*, immutable(char)*);
    void   dos_qvariant_setFloat(void*, float);
    void   dos_qvariant_setDouble(void*, double);
    void   dos_qvariant_setQObject(void*, void*);
    bool   dos_qvariant_isnull(void*);
    void   dos_qvariant_delete(void*);
    void   dos_qvariant_assign(void*, void*);

    // QObject
    void* dos_qobject_qmetaobject();
    void* dos_qobject_create(void*, void*,
                             void function (void*, void*, int , void**));
    void  dos_qobject_signal_emit(void*, immutable(char)* name,
                                 int parametersCount,
                                 void** parameters);
    bool  dos_qobject_signal_connect(void*,
                                    immutable(char)*,
                                    void*,
                                    immutable(char)*,
                                    int);
    bool  dos_qobject_signal_disconnect(void*,
                                       immutable(char)*,
                                       void*,
                                       immutable(char)*);
    char* dos_qobject_objectName(void*);
    void  dos_qobject_delete(void*);

    // QModelIndex
    void* dos_qmodelindex_create();
    void* dos_qmodelindex_create_qmodelindex(void* other);
    void  dos_qmodelindex_delete(void* index);
    int   dos_qmodelindex_row(void*);
    int   dos_qmodelindex_column(void*);
    bool  dos_qmodelindex_isValid(void* index);
    void* dos_qmodelindex_data(void* index, int role);
    void* dos_qmodelindex_parent(void* index);
    void* dos_qmodelindex_child(void* index, int r, int c);
    void* dos_qmodelindex_sibling(void* index, int r, int c);
    void  dos_qmodelindex_assign(void* leftSide, void* rightSide);
    void* dos_qmodelindex_internalPointer(void* index);

    // QHashIntByteArray
    void* dos_qhash_int_qbytearray_create();
    void  dos_qhash_int_qbytearray_delete(void*);
    void  dos_qhash_int_qbytearray_insert(void*, int, immutable(char)*);
    char* dos_qhash_int_qbytearray_value(void*, int);

    
    struct DosQAbstractItemModelCallbacks
    {
        void function (void*, void*, ref int) rowCount;
        void function (void*, void*, ref int) columnCount;
        void function (void*, void*, int, void*) data;
        void function (void*, void*, void*, int, ref bool) setData;
        void function (void*, void*) roleNames;
        void function (void*, void*, ref int) flags;
        void function (void*, int, int, int, void*) headerData;
        void function (void*, int, int, void*, void*) index;
        void function (void*, void*, void*) parent;
        void function (void*, void*, ref bool) hasChildren;
        void function (void*, void*, ref bool) canFetchMore;
        void function (void*, void*) fetchMore;
    }
    
    // QAbstractItemModel
    void* dos_qabstractitemmodel_qmetaobject();
    void* dos_qabstractitemmodel_create(void*, void*,
                                        void function (void*, void*, int, void**),
                                        const ref DosQAbstractItemModelCallbacks callbacks);
    void  dos_qabstractitemmodel_beginInsertRows(void* vptr, void* parent, int first, int last);
    void  dos_qabstractitemmodel_endInsertRows(void* vptr);
    void  dos_qabstractitemmodel_beginRemoveRows(void* vptr, void* parent, int first, int last);
    void  dos_qabstractitemmodel_endRemoveRows(void* vptr);
    void  dos_qabstractitemmodel_beginInsertColumns(void* vptr, void* parent, int first, int last);
    void  dos_qabstractitemmodel_endInsertColumns(void* vptr);
    void  dos_qabstractitemmodel_beginRemoveColumns(void* vptr, void* parent, int first, int last);
    void  dos_qabstractitemmodel_endRemoveColumns(void* vptr);
    void  dos_qabstractitemmodel_beginResetModel(void* vptr);
    void  dos_qabstractitemmodel_endResetModel(void* vptr);
    void  dos_qabstractitemmodel_dataChanged(void* vptr, void* topLeft, void* bottomRight, int* rolesPtr, int rolesLength);
    void* dos_qabstractitemmodel_createIndex(void* vptr, int row, int column, void* pointer);
    bool  dos_qabstractitemmodel_setData(void* vptr, void* modelIndex, void* valueVariant, int role);
    void* dos_qabstractitemmodel_roleNames(void* vptr);
    int   dos_qabstractitemmodel_flags(void *vptr, void* modelIndex);
    void* dos_qabstractitemmodel_headerData(void *vptr, int section, int orientation, int role);
    bool  dos_qabstractitemmodel_hasChildren(void *vptr, void* parent);
    bool  dos_qabstractitemmodel_hasIndex(void *vptr, int row, int column, void* parent);
    bool  dos_qabstractitemmodel_canFetchMore(void *vptr, void* parent);
    void  dos_qabstractitemmodel_fetchMore(void *vptr, void* parent);

    // QAbstractListModel
    void* dos_qabstractlistmodel_qmetaobject();
    void* dos_qabstractlistmodel_create(void*, void*,
                                        void function (void*, void*, int, void**),
                                        const ref DosQAbstractItemModelCallbacks callbacks);
                                        
    void* dos_qabstractlistmodel_index(void *vptr, int row, int column, void* parentIndex);
    void* dos_qabstractlistmodel_parent(void *vptr, void* childIndex);
    int   dos_qabstractlistmodel_columnCount(void *vptr, void* parentIndex);
    
    // QAbstractTableModel
    void* dos_qabstracttablemodel_qmetaobject();
    void* dos_qabstracttablemodel_create(void*, void*,
                                         void function (void*, void*, int, void**),
                                         const ref DosQAbstractItemModelCallbacks callbacks);
                                        
    void* dos_qabstracttablemodel_index(void *vptr, int row, int column, void* parentIndex);
    void* dos_qabstracttablemodel_parent(void *vptr, void* childIndex);
    
    // QResource
    void dos_qresource_register(immutable(char)* filename);

    // QUrl
    void* dos_qurl_create(immutable(char)*, int);
    void  dos_qurl_delete(void*);
    char* dos_qurl_to_string(void* vptr);
    
    // QMetaObjectFactory
    struct DosParameterDefinition
    {
        immutable(char)* name;
        int metaType;
    }
    
    struct DosSignalDefinition
    {
        immutable(char)* name;
        int parametersCount;
        DosParameterDefinition* parameters;
    }

    struct DosSignalDefinitions
    {
        int count;
        DosSignalDefinition* definitions;
    }

    struct DosSlotDefinition
    {
        immutable(char)* name;
        int returnType;
        int parametersCount;
        DosParameterDefinition* parameters;
    }

    struct DosSlotDefinitions
    {
        int count;
        DosSlotDefinition* definitions;
    }

    struct DosPropertyDefinition
    {
        immutable(char)* name;
        int type;
        immutable(char)* readSlot;
        immutable(char)* writeSlot;
        immutable(char)* notifySignal;
    }

    struct DosPropertyDefinitions
    {
        int count;
        DosPropertyDefinition* definitions;
    }

    void* dos_qmetaobject_create(void* superclass,
                                 immutable(char)* className,
                                 const ref DosSignalDefinitions signalDefinitions,
                                 const ref DosSlotDefinitions slotDefinitions,
                                 const ref DosPropertyDefinitions propertyDefinitions);
    void  dos_qmetaobject_delete(void*);


    struct DosQmlRegisterType
    {
      int major;
      int minor;
      immutable(char)* uri;
      immutable(char)* qml;
      void* staticMetaObject;
      void function(int, void*, ref void*, ref void*) createFunction;
      void function(int, void*) deleteFunction;
    }

    int dos_qdeclarative_qmlregistertype(const ref DosQmlRegisterType args);
    int dos_qdeclarative_qmlregistersingletontype(const ref DosQmlRegisterType args);
}
