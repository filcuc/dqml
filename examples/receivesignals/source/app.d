
import dqml;
import sender;
import receiver;

void main()
{
	auto app = new QApplication;
	scope(exit) destroy(app);

    auto sender = new Sender();
    scope(exit) destroy(sender);

    auto receiver = new Receiver();
    scope(exit) destroy(receiver);

    receiver.register(sender);

    auto temp = new QVariant(sender);
    auto temp2 = new QVariant(receiver);

	auto engine = new QQmlApplicationEngine;
	scope (exit) destroy(engine);

    engine.rootContext().setContextProperty("sender", temp);
    engine.rootContext().setContextProperty("receiver", temp2);
	engine.load("app.qml");

	app.exec();
}
