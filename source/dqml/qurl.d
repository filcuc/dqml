module dqml.qurl;
import dqml.dothersideinterface;
import std.string;

class QUrl
{
    this(string url, ParsingMode parsingMode = ParsingMode.TolerantMode)
    {
        dos_qurl_create(this.vptr, url.toStringz(), parsingMode);
    }

    ~this()
    {
        dos_qurl_delete(this.vptr);
    }

    enum ParsingMode : int
    {
        TolerantMode = 0,
        StrictMode,
        DecodedMode
    }

    public void* voidPointer()
    {
        return this.vptr;
    }

    private void* vptr;
}
