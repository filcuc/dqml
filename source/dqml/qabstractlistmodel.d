module dqml.qabstractlistmodel;

import dqml.global;
import dqml.dothersideinterface;
import dqml.qobject;
import dqml.qmodelindex;
import dqml.qvariant;
import dqml.qmetaobject;
import std.string;
import core.memory;

class QAbstractItemModel : QObject
{
    shared static this()
    {
        m_staticMetaObject = new QMetaObject(dos_qabstractitemmodel_qmetaobject());
    }

    this()
    {
        super(true);
        GC.setAttr(cast(void*)this, GC.BlkAttr.NO_MOVE);
        this.vptr = dos_qabstractitemmodel_create(cast(void*)this,
                                                  metaObject().voidPointer(),
                                                  &staticSlotCallback,
                                                  &rowCountCallback,
                                                  &columnCountCallback,
                                                  &dataCallback,
                                                  &setDataCallback,
                                                  &roleNamesCallback,
                                                  &flagsCallback,
                                                  &headerDataCallback,
                                                  &indexCallback,
                                                  &parentCallback);
    }

    ~this()
    {
        dos_qobject_delete(this.vptr);
    }

    public static QMetaObject staticMetaObject() {
        return m_staticMetaObject;
    }

    public override QMetaObject metaObject() {
        return m_staticMetaObject;
    }

    public int rowCount(QModelIndex parentIndex)
    {
        return 0;
    }

    public int columnCount(QModelIndex parentIndex)
    {
        return 1;
    }

    public QVariant data(QModelIndex index, int role)
    {
        return null;
    }

    public bool setData(QModelIndex index, QVariant value, int role)
    {
        return false;
    }

    public string[int] roleNames()
    {
        return null;
    }

    public int flags(QModelIndex index)
    {
        return 0;
    }

    public QVariant headerData(int section, int orienation, int role)
    {
        return null;
    }
    
    public QModelIndex parent(QModelIndex child)
    {
        return new QModelIndex();
    }
    
    public QModelIndex index(int row, int column, QModelIndex parent)
    {
        return createIndex(row, column, null);
    }

    protected final void beginInsertRows(QModelIndex parent, int first, int last)
    {
        dos_qabstractitemmodel_beginInsertRows(this.vptr, parent.voidPointer(), first, last);
    }

    protected final void endInsertRows()
    {
        dos_qabstractitemmodel_endInsertRows(this.vptr);
    }

    protected final void beginRemoveRows(QModelIndex parent, int first, int last)
    {
        dos_qabstractitemmodel_beginRemoveRows(this.vptr, parent.voidPointer(), first, last);
    }

    protected final void endRemoveRows()
    {
        dos_qabstractitemmodel_endRemoveRows(this.vptr);
    }
    
    protected final void beginInsertColumns(QModelIndex parent, int first, int last)
    {
        dos_qabstractitemmodel_beginInsertColumns(this.vptr, parent.voidPointer(), first, last);
    }

    protected final void endInsertColumns()
    {
        dos_qabstractitemmodel_endInsertColumns(this.vptr);
    }

    protected final void beginRemoveColumns(QModelIndex parent, int first, int last)
    {
        dos_qabstractitemmodel_beginRemoveColumns(this.vptr, parent.voidPointer(), first, last);
    }

    protected final void endRemoveColumns()
    {
        dos_qabstractitemmodel_endRemoveColumns(this.vptr);
    }

    protected final void beginResetModel()
    {
        dos_qabstractitemmodel_beginResetModel(this.vptr);
    }

    protected final void endResetModel()
    {
        dos_qabstractitemmodel_endResetModel(this.vptr);
    }
    
    protected final QModelIndex createIndex(int row, int column, void* data)
    {
        auto index = dos_qabstractitemmodel_createIndex(this.vptr, row, column, data);
        return new QModelIndex(index, Ownership.Take);
    }

    protected final void dataChanged(QModelIndex topLeft, QModelIndex bottomRight, int[] roles)
    {
        dos_qabstractitemmodel_dataChanged(this.vptr,
                                           topLeft.voidPointer(),
                                           bottomRight.voidPointer(),
                                           roles.ptr,
                                           cast(int)(roles.length));
    }

    private extern (C) static void rowCountCallback(void* modelPtr,
                                                    void* indexPtr,
                                                    ref int result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        auto index = new QModelIndex(indexPtr, Ownership.Clone);
        result = model.rowCount(index);
    }

    private extern (C) static void columnCountCallback(void* modelPtr,
                                                       void* indexPtr,
                                                       ref int result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        auto index = new QModelIndex(indexPtr, Ownership.Clone);
        result = model.columnCount(index);
    }

    private extern (C) static void dataCallback(void* modelPtr,
                                                void* indexPtr,
                                                int role,
                                                void* result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        auto index = new QModelIndex(indexPtr, Ownership.Clone);
        auto value = model.data(index, role);
        if (value is null)
            return;
        dos_qvariant_assign(result, value.voidPointer());
    }

    private extern (C) static void setDataCallback(void* modelPtr,
                                                   void* indexPtr,
                                                   void* valuePtr,
                                                   int role,
                                                   ref bool result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        auto index = new QModelIndex(indexPtr, Ownership.Clone);
        auto value = new QVariant(valuePtr, Ownership.Clone);
        result = model.setData(index, value, role);
    }

    private extern (C) static void roleNamesCallback(void* modelPtr,
                                                     void* result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        auto roles = model.roleNames();
        foreach(int key; roles.keys) {
            dos_qhash_int_qbytearray_insert(result, key, roles[key].toStringz());
        }
    }

    private extern (C) static void flagsCallback(void* modelPtr,
                                                 void* indexPtr,
                                                 ref int result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        auto index = new QModelIndex(indexPtr, Ownership.Clone);
        result = model.flags(index);
    }

    private extern (C) static void headerDataCallback(void* modelPtr,
                                                      int section,
                                                      int orientation,
                                                      int role,
                                                      void* result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        QVariant value = model.headerData(section, orientation, role);
        if (value is null)
            return;
        dos_qvariant_assign(result, value.voidPointer());
    }
    
    private extern (C) static void indexCallback(void* modelPtr,
                                                 int row,
                                                 int column,
                                                 void* parentIndex,
                                                 void* result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        QModelIndex value = model.index(row, column, new QModelIndex(parentIndex, Ownership.Clone));
        dos_qmodelindex_assign(result, value.voidPointer());
    }
    
    private extern (C) static void parentCallback(void* modelPtr,
                                                 void* childIndex,
                                                 void* result)
    {
        auto model = cast(QAbstractItemModel)(modelPtr);
        QModelIndex value = model.parent(new QModelIndex(childIndex, Ownership.Clone));
        dos_qmodelindex_assign(result, value.voidPointer());
    }

    private static QMetaObject m_staticMetaObject;
}
