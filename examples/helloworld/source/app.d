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
    auto temp2 = new QObject2Subclass();
    temp2.nameChanged("prova");
    writeln(temp2.metaObject() is null);
  }
  catch {}
}
