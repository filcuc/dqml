module dqml.qcoreapplication;
import dqml.dothersideinterface;
import std.string;

abstract class QCoreApplication
{
    static string applicationDirPath()
    {
        char* array;
        dos_qcoreapplication_application_dir_path(array);
        string result = fromStringz(array).dup;
        dos_chararray_delete(array);
        return result;
    }
}
