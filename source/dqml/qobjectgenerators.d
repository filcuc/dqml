module dqml.qobjectgenerators;

import std.traits;
import std.algorithm;
import std.string;
import std.stdio;

struct QtPropertyData
{
    public string type;
    public string name;
    public string read;
    public string write;
    public string notify;
}

struct QtProperty(T)
{
    public QtPropertyData data;

    this(string name, string read, string write, string notify)
    {
        data.type = T.stringof;
        data.name = name;
        data.read = read;
        data.write = write;
        data.notify = notify;
    }
}

struct QtSlot {}
struct QtSignal {}

string GenerateVariantConversionCall(string typeName)
{
    switch (typeName)
    {
    case "string":
        return ".toString()";
    case "int":
        return ".toInt()";
    case "bool":
        return ".toBool()";
    case "float":
        return ".toFloat()";
    case "double":
        return ".toDouble()";
    case "QVariant":
        return "";
    default:
        throw new Exception("Unknown conversion function from Qvariant to " ~ typeName);
    }
}

string GenerateArgumentList(string[] typeNames)
{
    string result = "";
    for (int i = 0; i < typeNames.length; ++i)
    {
        auto typeName = typeNames[i];
        auto variantCall = GenerateVariantConversionCall(typeName);
        result ~= i > 0 ? "," : "";
        result ~= format("arguments[%d]%s", i+1, variantCall);
    }
    return result;
}

string GenerateSlotCall(FunctionInfo info)
{
    auto args = GenerateArgumentList(info.parameterTypes);
    auto call = format("%s(%s)", info.name, args);
    auto formatStr = info.returnType != "void" ? "arguments[0].setValue(%s)" : "%s";
    return format(formatStr, call);
}

string GenerateCaseBlock(FunctionInfo info)
{
    string result = "";
    result ~= format("case \"%s\":\n", info.name);
    result ~= format("%s;\n", GenerateSlotCall(info));
    result ~= "break;\n";
    return result;
}

string GenerateOnSlotCalled(QtInfo info)
{
    string result = "protected override void onSlotCalled(QVariant slotName, QVariant[] arguments)\n";
    result ~= "{\n";
    result ~= "switch(slotName.toString())\n";
    result ~= "{\n";
    foreach (slot; info.slots)
        result ~= GenerateCaseBlock(slot);
    result ~= "default: super.onSlotCalled(slotName, arguments);\n";
    result ~= "}\n"; //
    result ~= "}";
    return result;
}

string GenerateSignalCall(FunctionInfo info)
{
    string args = "";
    string vars = "";
    for (int i = 0; i < info.parameterTypes.length; ++i) {
        if (i > 0) {
            args ~= ",";
            vars ~= ",";
        }
        args ~= format("%s val%d", info.parameterTypes[i], i);
        vars ~= format("val%d", i);
    }

    string result = format("pragma(mangle,\"%s\")\n", info.mangle);
    result ~= format("public %s %s(%s) { emit(\"%s\", %s); }", info.returnType, info.name, args, info.name, vars);
    return result;
}

string GenerateSignals(QtInfo info)
{
    string result = "";
    foreach (signal; info.signals)
        result ~= GenerateSignalCall(signal) ~ "\n";
    return result;
}

string GenerateMetaType(string typeName)
{
    switch(typeName)
    {
    case "void":
        return "QMetaType.Void";
    case "int":
        return "QMetaType.Int";
    case "string":
        return "QMetaType.String";
    case "QObject":
        return "QMetaType.QObject";
    case "QVariant":
        return "QMetaType.QVariant";
    case "bool":
        return "QMetaType.Bool";
    case "float":
        return "QMetaType.Float";
    case "double":
        return "QMetaType.Double";
    default:
        throw new Exception(format("Unknown conversion from %s to QMetaType", typeName));
    }
}

string GenerateParameterNamesList(FunctionInfo info)
{
    string result = "";
    for (int i = 0; i < info.parameterNames.length; ++i)
    {
        if (i > 0)
            result ~= ", ";
        result ~= info.parameterNames[i];
    }
    return result;
}

string GenerateMetaTypesListForSlot(FunctionInfo info)
{
    string result = GenerateMetaType(info.returnType);
    result ~= ", ";
    result ~= GenerateMetaTypesListForSignal(info);
    return result;
}

string GenerateMetaTypesListForSignal(FunctionInfo info)
{
    string result = "";
    for (int i = 0; i < info.parameterTypes.length; ++i)
    {
        if (i > 0)
            result ~= ", ";
        result ~= GenerateMetaType(info.parameterTypes[i]);
    }
    return result;
}

struct FunctionInfo
{
    string name;
    string returnType;
    string[] parameterNames;
    string[] parameterTypes;
    string mangle;
}

struct QtInfo
{
    FunctionInfo[] slots;
    FunctionInfo[] signals;
    QtPropertyData[] properties;
}

public static QtInfo GetQtUDA(T)()
{
    QtInfo result;

    foreach (property; getUDAs!(T, QtProperty)) {
        result.properties ~= property.data;
    }

    foreach (member; __traits(derivedMembers, T)) {
        static if (__traits(compiles, __traits(getMember, T, member))
                   && isSomeFunction!(__traits(getMember, T, member))) {
            // Retrieve the UDA
            auto attributes = __traits(getAttributes, __traits(getMember, T, member));

            // Turn the tuple in an array of strings
            string[] attributeNames;
            foreach (attribute; attributes)
                attributeNames ~= typeof(attribute).stringof;

            bool isSlot = attributeNames.canFind("QtSlot");
            bool isSignal = attributeNames.canFind("QtSignal");

            // Extract the Function Return Type and Arguments
            if (isSlot || isSignal) {
                FunctionInfo info;
                info.mangle = __traits(getMember, T, member).mangleof;
                info.name = member;
                info.returnType = ReturnType!(__traits(getMember, T, member)).stringof;
                
                foreach (param; ParameterIdentifierTuple!(__traits(getMember, T, member)))
                    info.parameterNames ~= param.stringof;
                
                foreach (param; Parameters!(__traits(getMember, T, member)))
                    info.parameterTypes ~= param.stringof;

                if (isSlot)
                    result.slots ~= info;

                if (isSignal)
                    result.signals ~= info;
            }
        }
    }

    return result;
}

public static string GenerateMetaObject(string qobjectSuperClassName, QtInfo info)
{
    string result =
        "shared static this() { m_staticMetaObject = createMetaObject(); }\n" ~
        "private static QMetaObject m_staticMetaObject;\n" ~
        "public static QMetaObject staticMetaObject() { return m_staticMetaObject; }\n" ~
        "public override QMetaObject metaObject() { return staticMetaObject(); }\n"~
        "private static QMetaObject createMetaObject() {\n" ~
        "  QMetaObject superMetaObject = " ~ qobjectSuperClassName ~ ".staticMetaObject();\n" ~
        "  SignalDefinition[] signals = [];\n" ~
        "  SlotDefinition[] slots = [];\n" ~
        "  PropertyDefinition[] properties = [];\n";

    foreach(FunctionInfo signal; info.signals) {
        string name = signal.name;
        string parameterNames = GenerateParameterNamesList(signal);
        string parameterTypes = GenerateMetaTypesListForSignal(signal);
        result ~= format("  signals ~= SignalDefinition(\"%s\",[%s], [%s]);\n", signal.name, parameterNames, parameterTypes);
    }

    foreach(FunctionInfo slot; info.slots) {
        string name = slot.name;
        string returnType = GenerateMetaType(slot.returnType);
        string parameterNames = GenerateParameterNamesList(slot);
        string parameterTypes = GenerateMetaTypesListForSignal(slot);
        result ~= format("  slots ~= SlotDefinition(\"%s\", %s, [%s], [%s]);\n", slot.name, returnType, parameterNames, parameterTypes);
    }

    foreach(QtPropertyData property; info.properties) {
        string name = property.name;
        string type = GenerateMetaType(property.type);
        string read = property.read;
        string write = property.write;
        string notify = property.notify;
        result ~= format("  properties ~= PropertyDefinition(\"%s\", %s, \"%s\", \"%s\", \"%s\");\n", name, type, read, write, notify);
    }

    result ~=
        "  return new QMetaObject(superMetaObject, typeof(this).stringof, signals, slots, properties);\n}\n";
    return result;
}

public static string QObjectSuperClass(T)()
{
    foreach (Type; BaseClassesTuple!T) {
        static if (__traits(compiles, Type.staticMetaObject())) {
            return Type.stringof;
        }
    }
}

public mixin template Q_OBJECT()
{
    private static string GenerateCode()
    {
        alias outerType = typeof(this);
        alias info = GetQtUDA!outerType;
        string result;
        result ~= GenerateMetaObject(QObjectSuperClass!outerType, info);
        result ~= GenerateOnSlotCalled(info);
        result ~= GenerateSignals(info);
        return result;
    }
    mixin(GenerateCode);
}
