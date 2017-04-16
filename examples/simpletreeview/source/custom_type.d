module custom_type;

import dqml;

@QtProperty!string("text", "text", "setText", "textChanged")
@QtProperty!int("indentation", "indentation", "setIndentation", "indentationChanged")
class CustomType : QObject
{
    mixin Q_OBJECT;

public:
    this(QObject parent = null)
    {
    	super();
    	_indentation = 0;
    }

    this(CustomType other)
	{
	    _text = other._text;
	    _indentation = other._indentation;
	}

	@QtSlot()
    string text()
	{
	    return _text;
	}

    @QtSlot()
    void setText(string value)
	{
	    if (_text != value)
        {
            _text = value;
            textChanged(text);
        }
	}

    @QtSignal()
    public void textChanged(string);

    @QtSlot()
    int indentation()
	{
	    return _indentation;
	}

	@QtSlot()
    void setIndentation(int value)
	{
		if (_indentation != value)
        {
            _indentation = value;
            indentationChanged(indentation);
        }
	}

    @QtSignal()
    public void indentationChanged(int);

private:
    string _text;
    int _indentation;
}
