module dqml.qsignal;

import std.stdio;
import std.conv;
import std.string;
import dqml.internal.dotherside;
import dqml.internal.qmetatype;
import dqml.qobject;
import dqml.qvariant;


class ISignal
{}

class QSignal(Args...) : ISignal
{
  nothrow:

  this(QObject qObject, string name)
  {
    this.qObject = qObject;
    this.name = name;
    foreach(i, arg; Args)
      parameterMetaTypes[i] = GetMetaType!arg();
  }

  void opCall(Args args)
  {
    QVariant[] parameters = new QVariant[args.length];
    void*[] parametersPtrs = new void*[args.length];
    foreach(i, arg; args)
    {
      auto variant = new QVariant(arg);
      parameters[i] = variant;
      parametersPtrs[i] = variant.rawData();
    }

    dos_qobject_signal_emit(this.qObject.data,
			    this.name.toStringz(),
			    cast(int)parametersPtrs.length,
			    parametersPtrs.ptr);
  }

  int[] GetParameterMetaTypes() 
  { 
    return parameterMetaTypes;
  }

  private QObject qObject;
  private string name;
  private int[] parameterMetaTypes = new int[Args.length];
}

public QSignal!(Args) CreateQSignal(Args...)(QObject qObject, string name)
{
  return new QSignal!(Args)(qObject, name);
}
