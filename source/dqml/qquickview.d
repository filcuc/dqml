module dqml.qquickview;

import dqml.dothersideinterface;
import dqml.qqmlcontext;
import dqml.qurl;
import std.string;

class QQuickView
{
    this()
    {
        this.vptr = dos_qquickview_create();
    }

    ~this()
    {
        dos_qquickview_delete(this.vptr);
    }

    public void* voidPointer()
    {
        return this.vptr;
    }

    public void show()
    {
        dos_qquickview_show(this.vptr);
    }

    public QQmlContext rootContext()
    {
        void* contextData = dos_qquickview_rootContext(this.vptr);
        return new QQmlContext(contextData);
    }

    public string source()
    {
        char* array = dos_qquickview_source(this.vptr);
        string result = fromStringz(array).dup;
        dos_chararray_delete(array);
        return result;
    }

    public void setSource(string filename)
    {
        immutable(char)* filenameAsCString = filename.toStringz();
        dos_qquickview_set_source(this.vptr, filenameAsCString);
    }

    public void setSource(QUrl url)
    {
        dos_qquickview_set_source_url(this.vptr, url.voidPointer);
    }

    enum ResizeMode : int
    {
        SizeViewToRootObject = 0,
        SizeRootObjectToView
    }

    void setResizeMode(ResizeMode resizeMode)
    {
        dos_qquickview_set_resize_mode(this.vptr, resizeMode);
    }

    private void* vptr;
}
