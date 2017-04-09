module dqml.qmetaobject;

import dqml.dothersideinterface;
import dqml.qmetatype;
import std.string;
import core.stdc.stdlib;

T* mallocArray(T)(int size) 
{
    if (size == 0)
        return null;
    return cast(T*) malloc(T.sizeof * size);
}

public struct ParameterDefinition
{
    this(string name, QMetaType metaType)
    {
        this.name = name;
        this.metaType = metaType;
    }
    
    string name;
    QMetaType metaType;
}

public struct SignalDefinition
{
    this(string name, string[] parametersNames, QMetaType[] parametersTypes)
    {
        this.name = name;
        for (int i = 0; i < parametersNames.length; ++i)
            parameters ~= ParameterDefinition(parametersNames[i], parametersTypes[i]);
    }

    string name;
    ParameterDefinition[] parameters;
}

public struct SlotDefinition
{
    this(string name, QMetaType returnType, string[] parametersNames, QMetaType[] parametersTypes)
    {
        this.name = name;
        this.returnType = returnType;
        for (int i = 0; i < parametersNames.length; ++i)
            parameters ~= ParameterDefinition(parametersNames[i], parametersTypes[i]);
    }

    string name;
    QMetaType returnType;
    ParameterDefinition[] parameters;
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

        auto dosSignalDefinitions = mallocDefinitions(signalDefinitions);
        scope(exit) freeDefinitions(dosSignalDefinitions);
        
        auto dosSlotDefinitions = mallocDefinitions(slotDefinitions);
        scope(exit) freeDefinitions(dosSlotDefinitions);
        
        auto dosPropertyDefinitions = mallocDefinitions(propertyDefinitions);
        scope(exit) freeDefinitions(dosPropertyDefinitions);
        
        this.vptr = dos_qmetaobject_create(superClass.vptr,
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

    public void* voidPointer()
    {
        return this.vptr;
    }
    
    private DosSignalDefinitions mallocDefinitions(SignalDefinition[] definitions)
    {
        DosSignalDefinitions result;
        result.count = cast(int)definitions.length;
        result.definitions = mallocArray!DosSignalDefinition(result.count);
        
        for (int i = 0; i < result.count; ++i)
        {
            SignalDefinition signalProto = definitions[i];
            DosSignalDefinition* signalDef = result.definitions + i;
            signalDef.name = toStringz(signalProto.name);
            signalDef.parametersCount = cast(int)signalProto.parameters.length;
            signalDef.parameters = mallocArray!DosParameterDefinition(signalDef.parametersCount);
            for (int j = 0; j < signalDef.parametersCount; ++j)
            {
                ParameterDefinition parameterProto = signalProto.parameters[j];
                DosParameterDefinition* parameterDef = signalDef.parameters + j;
                parameterDef.name = toStringz(parameterProto.name);
                parameterDef.metaType = parameterProto.metaType;
            }
        }
        
        return result;
    }
    
    private void freeDefinitions(DosSignalDefinitions definitions) 
    {
        for (int i = 0; i < definitions.count; ++i)
            free((definitions.definitions + i).parameters);
        free(definitions.definitions);
    }
    
    private DosSlotDefinitions mallocDefinitions(SlotDefinition[] definitions)
    {
        DosSlotDefinitions result;
        result.count = cast(int)definitions.length;
        result.definitions = mallocArray!DosSlotDefinition(result.count);
        
        for (int i = 0; i < result.count; ++i)
        {
            SlotDefinition slotProto = definitions[i];
            DosSlotDefinition* slotDef = result.definitions + i;
            slotDef.name = toStringz(slotProto.name);
            slotDef.returnType = slotProto.returnType;
            slotDef.parametersCount = cast(int)slotProto.parameters.length;
            slotDef.parameters = mallocArray!DosParameterDefinition(slotDef.parametersCount);
            for (int j = 0; j < slotDef.parametersCount; ++j)
            {
                ParameterDefinition parameterProto = slotProto.parameters[j];
                DosParameterDefinition* parameterDef = slotDef.parameters + j;
                parameterDef.name = toStringz(parameterProto.name);
                parameterDef.metaType = parameterProto.metaType;
            }
        }
        
        return result;
    }
    
    private void freeDefinitions(DosSlotDefinitions definitions)
    {
        for (int i = 0; i < definitions.count; ++i)
            free((definitions.definitions + i).parameters);
        free(definitions.definitions);
    }
    
    private DosPropertyDefinitions mallocDefinitions(PropertyDefinition[] definitions)
    {
        DosPropertyDefinitions result;
        result.count = cast(int)definitions.length;
        result.definitions = mallocArray!DosPropertyDefinition(result.count);
        for (int i = 0; i < result.count; ++i)
        {
            PropertyDefinition proto = definitions[i];
            DosPropertyDefinition* def = result.definitions + i;
            def.name = toStringz(proto.name);
            def.type = proto.type;
            def.readSlot = toStringz(proto.readSlot);
            def.writeSlot = toStringz(proto.writeSlot);
            def.notifySignal = toStringz(proto.notifySignal);
        }
        return result;
    }
    
    private void freeDefinitions(DosPropertyDefinitions definitions)
    {
        free(definitions.definitions);
    }

    private void* vptr;
    private PropertyDefinition[] propertyDefinitions;
    private SignalDefinition[] signalDefinitions;
    private SlotDefinition[] slotDefinitions;
}
