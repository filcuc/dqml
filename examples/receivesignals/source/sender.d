import dqml;
import core.atomic : cas, atomicLoad;
import core.thread : Thread, dur;

@QtProperty!string("message", "message", "setMessage", "messageChanged")
class Sender : QObject
{
    mixin Q_OBJECT;

    public this (uint delayInMilliseconds = 100)
    {
        m_delay = delayInMilliseconds;
        m_broadcasting = false;
        m_message = "No message set";
    }

    @QtSlot()
    public string message()
    {
        return m_message;
    }

    @QtSlot()
    public void setMessage(string message)
    {
        if (m_message == message)
            return;
        writeln("Message changed to ", message);
        m_message = message;
        messageChanged(message);
    }

    @QtSignal()
    public void messageChanged(string message);

	@QtSignal()
	public void broadcast(string message);

	@QtSlot()
	public void start()
    {
        if(cas(&m_broadcasting, false, true))
            new Thread(&workerFunc).start();
    }

	@QtSlot()
	public void stop()
    {
        cas(&m_broadcasting, true, false);
    }

	private void workerFunc()
	{
		while (atomicLoad(m_broadcasting))
		{
			broadcast(m_message);
			Thread.sleep(dur!"msecs"(m_delay));
		}
	}

	private uint m_delay;
	private shared bool m_broadcasting;
    private string m_message;
}
