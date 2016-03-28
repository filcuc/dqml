module dqml.qmodelindex;

import dqml.global;
import dqml.dothersideinterface;
import dqml.qvariant;


class QModelIndex
{
    this()
    {
        this.vptr = dos_qmodelindex_create();
    }

    this(void* vptr, Ownership ownership)
    {
        this.vptr = ownership == Ownership.Take ? vptr :  dos_qmodelindex_create_qmodelindex(vptr);
    }

    ~this()
    {
        dos_qmodelindex_delete(this.vptr);
    }

    public void* voidPointer()
    {
        return this.vptr;
    }

    public int row()
    {
        return dos_qmodelindex_row(this.vptr);
    }

    public int column()
    {
        return dos_qmodelindex_column(this.vptr);
    }

    public bool isValid()
    {
        return dos_qmodelindex_isValid(this.vptr);
    }

    public QVariant data(int role)
    {
        void* data = dos_qmodelindex_data(this.vptr, role);
        return new QVariant(data, Ownership.Take);
    }

    public QModelIndex parent()
    {
        void* parent = dos_qmodelindex_parent(this.vptr);
        return new QModelIndex(parent, Ownership.Take);
    }

    public QModelIndex child(int row, int column)
    {
        void* child = dos_qmodelindex_child(this.vptr, row, column);
        return new QModelIndex(child, Ownership.Take);
    }

    public QModelIndex sibling(int row, int column)
    {
        void* sibling = dos_qmodelindex_sibling(this.vptr, row, column);
        return new QModelIndex(sibling, Ownership.Take);
    }

    private void* vptr = null;
}
