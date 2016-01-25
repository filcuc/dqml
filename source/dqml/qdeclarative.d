module dqml.qdeclarative;
import dqml.dothersideinterface;
import dqml.qobject;
import std.string;
import std.traits;
import std.stdio;
import core.memory;

QObject createObject(T)()
{
    return new T();
}

extern(C) void createSafeObject(T)(ref void* dObject, ref void* cppObject)
{
    QObject object = createObject!T();
    dObject = cast(void*)(object);
    cppObject = object.voidPointer();
    GC.addRoot(dObject);
    GC.setAttr(dObject, GC.BlkAttr.NO_MOVE);
}

extern(C) void deleteSafeObject(void* object)
{
    GC.removeRoot(object);
    GC.clrAttr(object, GC.BlkAttr.NO_MOVE);
}

int qmlRegisterType(T)(string uri, int major, int minor, string qmlName) if (__traits(compiles, createObject!T))
{
    int result = -1;
    auto createFunction = &(createSafeObject!T);
    auto deleteFunction = &deleteSafeObject;
    auto staticMetaObject = T.staticMetaObject();

    dos_qdeclarative_qmlregistertype(uri.toStringz(), major, minor, qmlName.toStringz(),
                                     result, staticMetaObject.voidPointer(),
                                     createFunction, deleteFunction);
    return result;
}
