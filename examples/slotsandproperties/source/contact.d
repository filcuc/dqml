import dqml;

@QtProperty(string.stringof, "name", "name", "setName", "nameChanged")
@QtProperty(string.stringof, "surname", "surname", "setSurname", "surnameChanged")
class Contact : QObject
{
    mixin Q_OBJECT;

    this()
    {}

    ~this()
    {}

    @QtSlot()
    public string name()
    {
        return m_name;
    }

    @QtSlot()
    public void setName(string name)
    {
        if (m_name == name)
            return;
        m_name = name;
        nameChanged(name);
    }

    @QtSignal()
    public void nameChanged(string name);

    @QtSlot()
    public string surname()
    {
        return m_surname;
    }

    @QtSlot()
    public void setSurname(string surname)
    {
        if (m_surname == surname)
            return;
        m_surname = surname;
        surnameChanged(surname);
    }

    @QtSignal()
    void surnameChanged(string surname);

    private string m_name;
    private string m_surname;
}
