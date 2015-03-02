module dqml.qqmlapplicationengine;

import dqml.internal.dotherside;
import dqml.qqmlcontext;
import std.string;

class QQmlApplicationEngine
{
  this()
  {
    dos_qqmlapplicationengine_create(data);
  }
  
  ~this()
  {
    dos_qqmlapplicationengine_delete(data);
  }

  QQmlContext context()
  {
    void* contextData;
    dos_qqmlapplicationengine_context(data, contextData);
    return new QQmlContext(contextData);
  }
  
  void load(string filename)
  {
    dos_qqmlapplicationengine_load(data, filename.toStringz());
  }
  
  private void* data;
}
