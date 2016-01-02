import std.stdio;
import std.traits;
import dqml;
import dqml.dothersideinterface;
import dqml.qobjectgenerators;


@QtProperty(string.stringof, "name", "name", "setName", "nameChanged")
class QObject2Subclass : QObject
{
  mixin Q_OBJECT;

  @QtSlot() public string GetName() { return m_name; }
  @QtSlot() public void SetName(string name) { m_name = name; }
  @QtSignal() public void nameChanged(string name);

  private string m_name;
}

void main()
{
  try {
    SignalDefinition nameNotifySignal;
    nameNotifySignal.name = "nameChanged";
    nameNotifySignal.parametersTypes = [];
    SlotDefinition nameReadSlot;
    nameReadSlot.name = "name";
    nameReadSlot.returnType = QMetaType.String;
    nameReadSlot.parametersTypes = [];
    SlotDefinition nameWriteSlot;
    nameWriteSlot.name = "setName";
    nameWriteSlot.returnType = QMetaType.String;
    nameWriteSlot.parametersTypes = [];
    PropertyDefinition nameProperty;
    nameProperty.name = "name";
    nameProperty.type = QMetaType.String;
    nameProperty.readSlot = "name";
    nameProperty.writeSlot = "setName";
    nameProperty.notifySignal = "nameChanged";
    auto factory = new QMetaObjectFactory([nameNotifySignal], [nameReadSlot, nameWriteSlot], [nameProperty]);
    scope(exit) destroy(factory);

    auto temp = new QObject();
    auto temp2 = new QObject2Subclass();
    temp2.nameChanged("prova");
    writeln("Is null", temp.metaObject() is null, temp2.metaObject() is null);
  }
  catch {}
}
