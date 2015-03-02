module dqml.qqmlcontext;

import dqml.internal.dotherside;
import dqml.qvariant;
import dqml.internal.chararray;

class QQmlContext
{
  this(void* data)
  {
    this.data = data;
  }

  void* rawData()
  {
    return data;
  }

  string baseUrl()
  {
    auto array = new CharArray();
    scope(exit) destroy(array);
    dos_qqmlcontext_baseUrl(data, array.dataRef(), array.sizeRef());
    return array.toString();
  }
  
  void setContextProperty(string name, QVariant value)
  {
    dos_qqmlcontext_setcontextproperty(data, name.ptr, value.rawData());
  }

  private void* data;
}
