import std.stdio;
import std.traits;
import dqml;
import contact;
import std.conv;

void main()
{
    try
    {
        auto app = new QApplication();
        scope(exit) destroy(app);

        int result = qmlRegisterType!Contact("ContactModule", 1, 0, "Contact");

        auto engine = new QQmlApplicationEngine();
        scope(exit) destroy(engine);

        engine.load("app.qml");
        app.exec();
    }
    catch(Throwable)
    {}
}
