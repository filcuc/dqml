module dqml.qabstractlistmodel;

import dqml.dothersideinterface;
import dqml.global;
import dqml.qabstractitemmodel;
import dqml.qmetaobject;
import dqml.qmodelindex;
import core.memory;

abstract class QAbstractListModel : QAbstractItemModel
{
    shared static this()
    {
        m_staticMetaObject = new QMetaObject(dos_qabstractlistmodel_qmetaobject());
    }
    
    public static QMetaObject staticMetaObject() 
    {
        return m_staticMetaObject;
    }

    public override QMetaObject metaObject() 
    {
        return m_staticMetaObject;
    }
    
    public override int columnCount(QModelIndex parent)
    {
        return dos_qabstractlistmodel_columnCount(voidPointer(), parent.voidPointer());
    }
    
    public override QModelIndex index(int row, int column, QModelIndex parent)
    {
        auto result = dos_qabstractlistmodel_index(voidPointer(), row, column, parent.voidPointer());
        return new QModelIndex(result, Ownership.Take);
    }
    
    public override QModelIndex parent(QModelIndex child)
    {
        auto result = dos_qabstractlistmodel_parent(voidPointer(), child.voidPointer());
        return new QModelIndex(result, Ownership.Take);
    }
    
    protected override void* createVoidPointer()
    {
        DosQAbstractItemModelCallbacks callbacks;
        callbacks.rowCount = &rowCountCallback;
	callbacks.columnCount = &columnCountCallback;
	callbacks.data = &dataCallback;
	callbacks.setData = &setDataCallback;
	callbacks.headerData = &headerDataCallback;
	callbacks.roleNames = &roleNamesCallback;
	callbacks.flags = &flagsCallback;
	callbacks.index = &indexCallback;
	callbacks.parent = &parentCallback;
	callbacks.hasChildren = &hasChildrenCallback;
	callbacks.canFetchMore = &canFetchMoreCallback;
	callbacks.fetchMore = &fetchMoreCallback;

        return this.vptr = dos_qabstractlistmodel_create(cast(void*)this,
                                                         metaObject().voidPointer(),
                                                         &staticSlotCallback,
							 callbacks);
    }
    
    private static QMetaObject m_staticMetaObject;
}
