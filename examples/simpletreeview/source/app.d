import dqml;
import treemodel;
import custom_type : CustomType;

void main()
{
    try
    {
        auto app = new QGuiApplication();
        scope(exit) destroy(app);

        import std.file : readText;
        auto model = new TreeModel(readText("default.txt"));
        scope(exit) destroy(model);

        auto variant = new QVariant();
        variant.setValue(model);

        auto engine = new QQmlApplicationEngine();
        scope(exit) destroy(engine);

        engine.rootContext().setContextProperty("theModel", variant);
        int result = qmlRegisterType!CustomType("CustomModule", 1, 0, "CustomType");
        engine.load("app.qml");
        app.exec();
    }
    catch(Throwable)
    {}
}
