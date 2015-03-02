module dqml.qguiapplication;

import dqml.internal.dotherside;


class QGuiApplication
{
  this()
  {
    dos_qguiapplication_create();
  }
  
  ~this()
  {
    dos_qguiapplication_delete();
  }
  
  void exec() 
  {
    dos_qguiapplication_exec();
  }
}
