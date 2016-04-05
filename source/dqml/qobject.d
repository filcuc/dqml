module dqml.qobject;

import dqml.global;
import std.stdio;
import std.format;
import std.conv;
import std.container;
import std.traits;
import std.string;
import std.algorithm;
import dqml.qmetaobject;
import dqml.qobjectgenerators;
import dqml.dothersideinterface;
import dqml.qmetatype;
import dqml.qvariant;
import core.memory;

public class QObject
{
    shared static this()
    {
        m_staticMetaObject = new QMetaObject(dos_qobject_qmetaobject());
    }

    public this(bool disableDosCalls = false)
    {
        this.disableDosCalls = disableDosCalls;
        if (!this.disableDosCalls)
        {
            GC.setAttr(cast(void*)this, GC.BlkAttr.NO_MOVE);
            this.vptr = dos_qobject_create(cast(void*)this,
                                           metaObject().voidPointer(),
                                           &staticSlotCallback);
        }
    }

    ~this()
    {
        if (!this.disableDosCalls)
        {
            dos_qobject_delete(this.vptr);
            this.vptr = null;
        }
    }

    public void* voidPointer()
    {
        return this.vptr;
    }

    public void setVoidPointer(void* vptr)
    {
        this.vptr = vptr;
    }

    public void setDisableDosCalls(bool value)
    {
        this.disableDosCalls = value;
    }

    @property public string objectName()
    {
        char* array = dos_qobject_objectName(this.vptr);
        string result = fromStringz(array).dup;
        dos_chararray_delete(array);
        return result;
    }

    public static QMetaObject staticMetaObject()
    {
        return m_staticMetaObject;
    }

    public QMetaObject metaObject()
    {
        return staticMetaObject();
    }

    protected void onSlotCalled(QVariant slotName, QVariant[] parameters)
    {
    }

    protected bool connect(QObject sender,
                           string signal,
                           string method,
                           ConnectionType type = ConnectionType.Auto)
    {
        return QObject.connect(sender, signal, this, method, type);
    }

    protected bool disconnect(QObject sender,
                              string signal,
                              string method)
    {
        return QObject.disconnect(sender, signal, this, method);
    }

    protected void emit(T)(string signalName, T t)
    {
        emit(signalName, new QVariant(t));
    }

    protected void emit(string signalName, QVariant value)
    {
        QVariant[] array = [value];
        emit(signalName, array);
    }

    protected void emit(string signalName, QVariant[] arguments = null)
    {
        int length = cast(int)arguments.length;
        void*[] array = null;
        if (length > 0) {
            array = new void*[length];
            foreach (int i, QVariant v; arguments)
                array[i] = v.voidPointer();
        }
        dos_qobject_signal_emit(this.vptr,
                                signalName.toStringz(),
                                length,
                                array.ptr);
    }

    protected extern (C) static void staticSlotCallback(void* qObjectPtr,
                                                        void* rawSlotName,
                                                        int numParameters,
                                                        void** parametersArray)
    {
        QVariant[] parameters = new QVariant[numParameters];
        for (int i = 0; i < numParameters; ++i)
            parameters[i] = new QVariant(parametersArray[i], Ownership.Clone);
        QObject qObject = cast(QObject) qObjectPtr;
        QVariant slotName = new QVariant(rawSlotName, Ownership.Clone);
        qObject.onSlotCalled(slotName, parameters);
        dos_qvariant_assign(parametersArray[0], parameters[0].voidPointer());
    }

    protected static bool connect(QObject sender,
                                  string signal,
                                  QObject receiver,
                                  string method,
                                  ConnectionType type = ConnectionType.Auto)
    {
        return dos_qobject_signal_connect(sender.voidPointer,
                                          signal.toStringz,
                                          receiver.voidPointer,
                                          method.toStringz,
                                          type);

    }

    protected static bool disconnect(QObject sender,
                                     string signal,
                                     QObject receiver,
                                     string method)
    {
        return dos_qobject_signal_disconnect(sender.voidPointer,
                                             signal.toStringz,
                                             receiver.voidPointer,
                                             method.toStringz);
    }

    template connect(alias slot)
    {
        protected static bool connect(QObject sender,
                                      string signalName,
                                      QObject receiver,
                                      ConnectionType type = ConnectionType.Auto)
        {
            return connect(sender,
                           SIGNAL!slot(signalName),
                           receiver,
                           SLOT!slot);
        }

        protected bool connect(QObject sender,
                               string signalName,
                               ConnectionType type = ConnectionType.Auto)
        {
            return connect!slot(sender, signalName, this);
        }
    }

    template disconnect(alias slot)
    {
        protected static bool disconnect(QObject sender,
                                         string signalName,
                                         QObject receiver)
        {
            return disconnect(sender,
                              SIGNAL!slot(signalName),
                              receiver,
                              SLOT!slot);
        }

        protected bool disconnect(QObject sender,
                                  string signalName)
        {
            return disconnect!slot(sender, signalName, this);
        }
    }

    protected void* vptr;
    protected bool disableDosCalls;
    private static QMetaObject m_staticMetaObject;
}

enum FindChildOptions : int
{
    DirectOnly = 0,
    Recursively
}

enum ConnectionType : int
{
    Auto = 0,
    Direct,
    Queued,
    BlockingQueued,

    Unique = 0x80
}

template SIGNAL(alias slot)
{
    string SIGNAL(string signalName)
    {
        return "2" ~ signalName ~ QObjectSignalParameters!slot;
    }
}

template SLOT(alias slot)
{
    enum string SLOT = "1" ~ __traits(identifier, slot) ~ QObjectSignalParameters!slot;
}

template QObjectSignalParameters(alias slot)
{
    enum string QObjectSignalParameters = (Parameters!slot).stringof.replace("string", "QString");
}
