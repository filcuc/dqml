module dqml.qvariant;

import dqml.global;
import dqml.dothersideinterface;
import dqml.qobject;
import std.string;

class QVariant
{
    public this()
    {
        this.vptr = dos_qvariant_create();
    }

    public this(int value)
    {
        this.vptr = dos_qvariant_create_int(value);
    }

    public this(bool value)
    {
        this.vptr = dos_qvariant_create_bool(value);
    }

    public this(string value)
    {
        this.vptr = dos_qvariant_create_string(value.toStringz());
    }

    public this(float value)
    {
        this.vptr = dos_qvariant_create_float(value);
    }

    public this(double value)
    {
        this.vptr = dos_qvariant_create_double(value);
    }

    public this(QObject value)
    {
        this.vptr = dos_qvariant_create_qobject(value.voidPointer());
    }

    public this(void* vptr, Ownership ownership)
    {
        this.vptr = ownership == Ownership.Take ? vptr : dos_qvariant_create_qvariant(vptr);
    }

    ~this()
    {
        dos_qvariant_delete(this.vptr);
    }

    public void* voidPointer()
    {
        return this.vptr;
    }

    public void setValue(int value)
    {
        dos_qvariant_setInt(this.vptr, value);
    }

    public void setValue(bool value)
    {
        dos_qvariant_setBool(this.vptr, value);
    }

    public void setValue(string value)
    {
        dos_qvariant_setString(this.vptr, value.toStringz());
    }

    public void setValue(QObject value)
    {
        dos_qvariant_setQObject(this.vptr, value.voidPointer());
    }

    public void setValue(float value)
    {
        dos_qvariant_setFloat(this.vptr, value);
    }

    public void setValue(double value)
    {
        dos_qvariant_setDouble(this.vptr, value);
    }

    public void getValue(ref int value)
    {
        value = toInt();
    }

    public void getValue(ref bool value)
    {
        value = toBool();
    }

    public void getValue(ref string value)
    {
        value = toString();
    }

    public void getValue(ref float value)
    {
        value = toFloat();
    }

    public void getValue(ref double value)
    {
        value = toDouble();
    }

    public bool isNull()
    {
        return dos_qvariant_isnull(this.vptr);
    }

    public bool toBool()
    {
        return dos_qvariant_toBool(this.vptr);
    }

    public int toInt()
    {
        return dos_qvariant_toInt(this.vptr);
    }

    public float toFloat()
    {
        return dos_qvariant_toFloat(this.vptr);
    }

    public double toDouble()
    {
        return dos_qvariant_toDouble(this.vptr);
    }

    public override string toString()
    {
        char* array = dos_qvariant_toString(this.vptr);
        string result = fromStringz(array).dup;
        dos_chararray_delete(array);
        return result;
    }

    private void* vptr = null;
}
