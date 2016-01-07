module dqml.qobject;

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

public class QObject
{
    shared static this()
    {
        void* vptr;
        dos_qobject_qmetaobject(vptr);
        m_staticMetaObject = new QMetaObject(vptr);
    }

    public this()
    {
        this(false);
    }

    protected this(bool disableDosCalls)
    {
        this.disableDosCalls = disableDosCalls;
        if (!this.disableDosCalls)
        {
           dos_qobject_create(this.vptr, cast(void*)this,
                              &staticMetaObjectCallback,
                              &staticSlotCallback);
        }
    }

    public this(void* vptr)
    {
        this.vptr = vptr;
        this(true);
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

    @property public string objectName()
    {
        char* array;
        dos_qobject_objectName(this.vptr, array);
        string result = fromStringz(array).dup;
        dos_chararray_delete(array);
        return result;
    }

    public QObject findChild(string name, FindChildOptions options = FindChildOptions.Recursively)
    {
        void* child;
        dos_qobject_findChild(this.vptr, name.toStringz, options, child);
        if (child is null) return null;
        return new QObject(child);
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

    protected extern (C) static void staticMetaObjectCallback(void* qObjectPtr, ref void* result)
    {
        QObject qObject = cast(QObject) qObjectPtr;
        result = qObject.metaObject().voidPointer();
    }


    protected extern (C) static void staticSlotCallback(void* qObjectPtr,
                                                        void* rawSlotName,
                                                        int numParameters,
                                                        void** parametersArray)
    {
        QVariant[] parameters = new QVariant[numParameters];
        for (int i = 0; i < numParameters; ++i)
            parameters[i] = new QVariant(parametersArray[i]);
        QObject qObject = cast(QObject) qObjectPtr;
        QVariant slotName = new QVariant(rawSlotName);
        qObject.onSlotCalled(slotName, parameters);
    }

    protected static bool connect(QObject sender,
                                  string signal,
                                  QObject receiver,
                                  string method,
                                  ConnectionType type = ConnectionType.Auto)
    {
        bool result;
        dos_qobject_signal_connect(sender.voidPointer,
                                   signal.toStringz,
                                   receiver.voidPointer,
                                   method.toStringz,
                                   type,
                                   result);
        return result;
    }

    protected static bool disconnect(QObject sender,
                                     string signal,
                                     QObject receiver,
                                     string method)
    {
        bool result;
        dos_qobject_signal_disconnect(sender.voidPointer,
                                      signal.toStringz,
                                      receiver.voidPointer,
                                      method.toStringz,
                                      result);
        return result;
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
