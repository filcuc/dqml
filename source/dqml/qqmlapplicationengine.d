module dqml.qqmlapplicationengine;

import dqml.dothersideinterface;
import dqml.qqmlcontext;
import dqml.qurl;
import dqml.qobject;
import std.string;

class QQmlApplicationEngine
{
    this()
    {
        this.vptr = dos_qqmlapplicationengine_create();
    }

    ~this()
    {
        dos_qqmlapplicationengine_delete(this.vptr);
    }

    public void* voidPointer()
    {
        return this.vptr;
    }

    public QQmlContext rootContext()
    {
        void* contextVPtr = dos_qqmlapplicationengine_context(this.vptr);
        return new QQmlContext(contextVPtr);
    }

    public void load(string filename)
    {
        dos_qqmlapplicationengine_load(this.vptr, filename.toStringz());
    }

    public void load(QUrl url)
    {
        dos_qqmlapplicationengine_load_url(this.vptr, url.voidPointer());
    }

    public void addImportPath(string path)
    {
        dos_qqmlapplicationengine_add_import_path(this.vptr, path.toStringz());
    }

    private void* vptr;
}
