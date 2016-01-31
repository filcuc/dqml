
import dqml;

void main()
{
	auto application = new QApplication;
	scope(exit) destroy(application);

	auto receiver = new Receiver;
	scope(exit) destroy(receiver);

	auto receiverVariant = new QVariant;
	receiverVariant.setValue(receiver);

	auto numberBroadcaster = new NumberBroadcaster;
	scope(exit) destroy(numberBroadcaster);

	auto numberBroadcasterVariant = new QVariant;
	numberBroadcasterVariant.setValue(numberBroadcaster);

	receiver.register(numberBroadcaster);

	auto engine = new QQmlApplicationEngine;
	scope (exit) destroy(engine);
	engine.rootContext.setContextProperty("receiver", receiverVariant);
	engine.rootContext.setContextProperty("numberBroadcaster", numberBroadcasterVariant);
	engine.load("app.qml");

	application.exec;
}

class Receiver : QObject
{
    mixin Q_OBJECT;

private:
	import std.stdio;

public:
	@QtSlot()
	void register(QObject sender)
	{
		connect!receive(sender, "broadcast");
	}

	@QtSlot()
	void receive(string message)
	{
		writeln("Received \"" ~ message ~ "\"");
	}
}

class NumberBroadcaster : QObject
{
    mixin Q_OBJECT;

private:
	import core.atomic : cas, atomicLoad;
	import core.thread : Thread, dur;

	import std.random : uniform;
	import std.conv : to;

	uint m_delay;
	shared bool broadcasting;

	void workerFunc()
	{
		while (atomicLoad(broadcasting))
		{
			broadcast(to!string(uniform(0, 255)));
			Thread.sleep(dur!"msecs"(m_delay));
		}
	}

public:
	@QtSignal()
	void broadcast(string message);

	@QtSlot()
	void start() { if(cas(&broadcasting, false, true)) new Thread(&workerFunc).start(); }

	@QtSlot()
	void stop() { cas(&broadcasting, true, false); }

	this (uint delayInMilliseconds = 100) { m_delay = delayInMilliseconds; }
}
