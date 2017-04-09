import std.stdio;
import dqml;
import std.path : dirSeparator;

void main()
{
    try
    {
        auto app = new QGuiApplication();
        scope(exit) destroy(app);

        auto engine = new QQmlApplicationEngine();
        scope(exit) destroy(engine);

        QResource.registerResource(app.applicationDirPath
            ~ dirSeparator ~ "app.rcc");

        engine.load(new QUrl("qrc:///app.qml"));

        app.exec();
    }
    catch(Throwable)
    {}
}
