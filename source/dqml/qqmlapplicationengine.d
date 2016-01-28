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
        dos_qqmlapplicationengine_create(this.vptr);
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
        void* contextVPtr;
        dos_qqmlapplicationengine_context(this.vptr, contextVPtr);
        return new QQmlContext(contextVPtr);
    }

    public QObject[] rootObjects()
    {
        void** array;
        int array_length;
        dos_qqmlapplicationengine_rootObjects(this.vptr, array, array_length);

        QObject[] objects;
        objects.length = array_length;
        for (int i = 0; i < array_length; ++i)
            objects[i] = new QObject(array[i]);
        dos_qobjectptr_array_delete(array);
        return objects;
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
