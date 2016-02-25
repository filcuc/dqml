module dqml.qmodelindex;
import dqml.dothersideinterface;
import dqml.qvariant;

class QModelIndex
{
    this()
    {
        dos_qmodelindex_create(this.vptr);
    }

    this(void* vptr)
    {
        this();
        dos_qmodelindex_assign(this.vptr, vptr);
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
        int result = -1;
        dos_qmodelindex_row(this.vptr, result);
        return result;
    }

    public int column()
    {
        int result = -1;
        dos_qmodelindex_column(this.vptr, result);
        return result;
    }

    public bool isValid()
    {
        bool result = false;
        dos_qmodelindex_isValid(this.vptr, result);
        return result;
    }

    public QVariant data(int role)
    {
        auto result = new QVariant();
        dos_qmodelindex_data(this.vptr, role, result.voidPointer());
        return result;
    }

    public QModelIndex parent()
    {
        auto result = new QModelIndex();
        dos_qmodelindex_parent(this.vptr, result.vptr);
        return result;
    }

    public QModelIndex child(int row, int column)
    {
        auto result = new QModelIndex();
        dos_qmodelindex_child(this.vptr, row, column, result.vptr);
        return result;
    }

    public QModelIndex sibling(int row, int column)
    {
        auto result = new QModelIndex();
        dos_qmodelindex_sibling(this.vptr, row, column, result.vptr);
        return result;
    }

    private void* vptr = null;
}
