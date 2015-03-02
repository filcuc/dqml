module dqml.qvariant;

import dqml.internal.dotherside;
import dqml.qobject;
import std.string;
import dqml.internal.chararray;

class QVariant
{

nothrow:

  this()
  {
    dos_qvariant_create(this.data);
  }
  
  this(int value)
  {
    dos_qvariant_create_int(this.data, value);
  }
  
  this(bool value)
  {
    dos_qvariant_create_bool(this.data, value);
  }
  
  this(string value)
  {
    dos_qvariant_create_string(this.data, value.toStringz());
  }
  
  this(QObject value)
  {
    dos_qvariant_create_qobject(this.data, value.data);
  }

  this(void* data, bool hasOwnership = false)
  {
    this.data = data;
    this.hasOwnership = hasOwnership;
  }

  ~this()
  {
    if (this.hasOwnership)
      dos_qvariant_delete(this.data);
  }

  void* rawData()
  {
    return data;
  }

  void setValue(int value)
  {
    dos_qvariant_setInt(this.data, value);
  }

  void setValue(bool value)
  {
    dos_qvariant_setBool(this.data, value);
  }

  void setValue(string value)
  {
    dos_qvariant_setString(this.data, value.toStringz());
  }

  void getValue(ref int value)
  {
    value = toInt();
  }

  void getValue(ref bool value)
  {
    value = toBool();
  }

  void getValue(ref string value)
  {
    value = toString();
  }
  
  bool isNull()
  {
    bool result;
    dos_qvariant_isnull(this.data, result);
    return result;
  }
  
  bool toBool()
  {
    bool result;
    dos_qvariant_toBool(this.data, result);
    return result;
  }
  
  int toInt()
  {
    int result;
    dos_qvariant_toInt(this.data, result);
    return result;
  }

  override string toString()
  {
    auto result = new CharArray();
    //scope(exit) destroy(result);
    dos_qvariant_toString(this.data, result.dataRef(), result.sizeRef());
    return result.toString();
  }

  private void* data = null;
  private bool hasOwnership = true;
}
