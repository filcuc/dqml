module dqml.qslot;

import std.stdio;
import std.container;
import std.conv;
import std.typecons;
import std.traits;
import dqml.qvariant;
import dqml.internal.qmetatype;


class ISlot
{
  nothrow void Execute(QVariant[]  arguments) {}
}

QSlot!(T) CreateQSlot(T)(T t) if (isCallable!(T))
{
  return new QSlot!(T)(t);
}

class QSlot(T) : ISlot
{ 

  alias ReturnType!T SlotReturnType;
  alias ParameterTypeTuple!T Arguments;
  
  this(T callable)
  {
    _callable = callable;
    
    _parameterMetaTypes[0] = GetMetaType!SlotReturnType();
    foreach (i, arg; Arguments) {
      _parameterMetaTypes[i+1] = GetMetaType!arg();
    }
  }
  
  nothrow override void Execute(QVariant[]  arguments)
  {
    Arguments argumentsTuple;
    
    try
    {
      foreach (i, arg; argumentsTuple) {
        arguments[i + 1].getValue(argumentsTuple[i]);
      }
    
      static if (is(SlotReturnType == void))
      {
        opCall(argumentsTuple);
      }
      else
      {
        auto result = opCall(argumentsTuple);
        arguments[0].setValue(result);
      }
    }
    catch(Exception e)
    {

    }
  }
  
  ReturnType!T opCall(Arguments arguments)
  {
    return _callable(arguments);
  }
  
   nothrow int[] GetParameterMetaTypes() { return _parameterMetaTypes; }
  
  private T _callable;
  private int[] _parameterMetaTypes = new int[Arguments.length + 1];
}
