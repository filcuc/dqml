module dqml.qguiapplication;

import dqml.dothersideinterface;
import dqml.qcoreapplication;
import std.string;

class QGuiApplication : QCoreApplication
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

    void quit()
    {
        dos_qguiapplication_quit();
    }
}
