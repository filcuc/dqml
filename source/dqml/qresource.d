module dqml.qresource;
import dqml.dothersideinterface;
import std.string;

abstract class QResource
{
    public static void registerResource(string filename)
    {
        dos_qresource_register(filename.toStringz());
    }

    private void* vptr;
}
