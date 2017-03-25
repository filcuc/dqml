module dqml.qabstracttablemodel;

import dqml.dothersideinterface;
import dqml.global;
import dqml.qabstractitemmodel;
import dqml.qmetaobject;
import dqml.qmodelindex;
import core.memory;

abstract class QAbstractTableModel : QAbstractItemModel
{
    shared static this()
    {
        m_staticMetaObject = new QMetaObject(dos_qabstracttablemodel_qmetaobject());
    }
    
    public static QMetaObject staticMetaObject() 
    {
        return m_staticMetaObject;
    }

    public override QMetaObject metaObject() 
    {
        return m_staticMetaObject;
    }
    
    public override QModelIndex index(int row, int column, QModelIndex parent)
    {
        auto result = dos_qabstracttablemodel_index(voidPointer(), row, column, parent.voidPointer());
        return new QModelIndex(result, Ownership.Take);
    }
    
    public override QModelIndex parent(QModelIndex child)
    {
        auto result = dos_qabstracttablemodel_parent(voidPointer(), child.voidPointer());
        return new QModelIndex(result, Ownership.Take);
    }
    
    protected override void* createVoidPointer()
    {
        return dos_qabstracttablemodel_create(cast(void*)this,
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
    
    private static QMetaObject m_staticMetaObject;
}
