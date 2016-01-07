module dqml.qmetaobject;
import dqml.dothersideinterface;
import dqml.qmetatype;
import std.string;

public struct SignalDefinition
{
    this(string name, QMetaType[] types)
    {
        this.name = name;
        this.parametersTypes = types;
    }

    string name;
    QMetaType[] parametersTypes;
}

public struct SlotDefinition
{
    this(string name, QMetaType returnType, QMetaType[] parametersTypes)
    {
        this.name = name;
        this.returnType = returnType;
        this.parametersTypes = parametersTypes;
    }

    string name;
    QMetaType returnType;
    QMetaType[] parametersTypes;
}

public struct PropertyDefinition
{
    this(string name, QMetaType type, string readSlot, string writeSlot, string notifySignal)
    {
        this.name = name;
        this.type = type;
        this.readSlot = readSlot;
        this.writeSlot = writeSlot;
        this.notifySignal = notifySignal;
    }

    string name;
    QMetaType type;
    string readSlot;
    string writeSlot;
    string notifySignal;
}

public class QMetaObject
{
    public this(void* vptr)
    {
        this.vptr = vptr;
    }

    public this(QMetaObject superClass,
                string className,
                SignalDefinition[] signalDefinitions,
                SlotDefinition[] slotDefinitions,
                PropertyDefinition[] propertyDefinitions)
    {
        this.signalDefinitions = signalDefinitions;
        this.slotDefinitions = slotDefinitions;
        this.propertyDefinitions = propertyDefinitions;

        auto dosSignalDefinitionsArray = convert(signalDefinitions);
        DosSignalDefinitions dosSignalDefinitions;
        dosSignalDefinitions.count = cast(int) dosSignalDefinitionsArray.length;
        dosSignalDefinitions.definitions = dosSignalDefinitionsArray.ptr;

        auto dosSlotDefinitionsArray = convert(slotDefinitions);
        DosSlotDefinitions dosSlotDefinitions;
        dosSlotDefinitions.count = cast(int) dosSlotDefinitionsArray.length;
        dosSlotDefinitions.definitions = dosSlotDefinitionsArray.ptr;

        auto propertyDefinitionsArray = convert(propertyDefinitions);
        DosPropertyDefinitions dosPropertyDefinitions;
        dosPropertyDefinitions.count = cast(int) propertyDefinitionsArray.length;
        dosPropertyDefinitions.definitions = propertyDefinitionsArray.ptr;

        dos_qmetaobject_create(this.vptr,
                               superClass.vptr,
                               className.toStringz(),
                               dosSignalDefinitions,
                               dosSlotDefinitions,
                               dosPropertyDefinitions);
    }

    public ~this()
    {
        dos_qmetaobject_delete(this.vptr);
    }

    @property SignalDefinition[] signals() { return signalDefinitions; }
    @property SlotDefinition[] slots() { return slotDefinitions; }
    @property PropertyDefinition[] properties() { return propertyDefinitions; }

    private DosSignalDefinition[] convert(SignalDefinition[] definitions)
    {
        DosSignalDefinition[] result;
        foreach (SignalDefinition definition; definitions) {
            DosSignalDefinition dosDefinition;
            dosDefinition.name = definition.name.toStringz();
            dosDefinition.parametersCount = cast(int)definition.parametersTypes.length;
            dosDefinition.parametersTypes = cast(int*)definition.parametersTypes.ptr;
            result ~= dosDefinition;
        }
        return result;
    }

    private DosSlotDefinition[] convert(SlotDefinition[] definitions)
    {
        DosSlotDefinition[] result;
        foreach (SlotDefinition definition; definitions) {
            DosSlotDefinition dosDefinition;
            dosDefinition.name = definition.name.toStringz();
            dosDefinition.returnType = definition.returnType;
            dosDefinition.parametersCount = cast(int)definition.parametersTypes.length;
            dosDefinition.parametersTypes = cast(int*)definition.parametersTypes.ptr;
            result ~= dosDefinition;
        }
        return result;
    }

    private DosPropertyDefinition[] convert(PropertyDefinition[] definitions)
    {
        DosPropertyDefinition[] result;
        foreach (PropertyDefinition definition; definitions) {
            DosPropertyDefinition dosDefinition;
            dosDefinition.name = definition.name.toStringz();
            dosDefinition.type = definition.type;
            dosDefinition.readSlot = definition.readSlot.toStringz();
            dosDefinition.writeSlot = definition.writeSlot.toStringz();
            dosDefinition.notifySignal = definition.notifySignal.toStringz();
            result ~= dosDefinition;
        }
        return result;
    }

    public void* voidPointer()
    {
        return this.vptr;
    }

    private void* vptr;
    private PropertyDefinition[] propertyDefinitions;
    private SignalDefinition[] signalDefinitions;
    private SlotDefinition[] slotDefinitions;
}
