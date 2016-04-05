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

extern(C) void createSafeObject(T)(int id, void* wrapper, ref void* dObject, ref void* dosQObject)
{
    QObject qobject = createObject!T();
    GC.addRoot(cast(void*)qobject);
    GC.setAttr(cast(void*)qobject, GC.BlkAttr.NO_MOVE);
    dObject = cast(void*)(qobject);
    dosQObject = qobject.voidPointer();
    qobject.setVoidPointer(wrapper);
    qobject.setDisableDosCalls(true);
}

extern(C) void deleteSafeObject(int id, void* object)
{
    GC.clrAttr(object, GC.BlkAttr.NO_MOVE);
    GC.removeRoot(object);
}

int qmlRegisterType(T)(string uri, int major, int minor, string qmlName) if (__traits(compiles, createObject!T))
{
    auto createFunction = &(createSafeObject!T);
    auto deleteFunction = &deleteSafeObject;
    auto staticMetaObject = T.staticMetaObject();

    DosQmlRegisterType args;
    args.uri = uri.toStringz();
    args.major = major;
    args.minor = minor;
    args.qml = qmlName.toStringz();
    args.staticMetaObject = staticMetaObject.voidPointer();
    args.createFunction = createFunction;
    args.deleteFunction = deleteFunction;

    return dos_qdeclarative_qmlregistertype(args);
}

int qmlRegisterSingletonType(T)(string uri, int major, int minor, string qmlName) if (__traits(compiles, createObject!T))
{
    auto createFunction = &(createSafeObject!T);
    auto deleteFunction = &deleteSafeObject;
    auto staticMetaObject = T.staticMetaObject();

    DosQmlRegisterType args;
    args.uri = uri.toStringz();
    args.major = major;
    args.minor = minor;
    args.qml = qmlName.toStringz();
    args.staticMetaObject = staticMetaObject.voidPointer();
    args.createFunction = createFunction;
    args.deleteFunction = deleteFunction;

    return dos_qdeclarative_qmlregistersingletontype(args);
}
