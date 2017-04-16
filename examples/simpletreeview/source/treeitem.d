module treeitem;

import dqml.qvariant;

class TreeItem
{
public:
    this(QVariant[] data, TreeItem parentItem = null)
    {
        m_parentItem = parentItem;
        m_itemData = data;
    }

    ~this()
    {
        foreach (c; m_childItems)
            destroy(c);
    }

    void appendChild(TreeItem child)
    {
        m_childItems ~= child;
    }

    TreeItem child(int row)
    {
        return m_childItems[row];
    }

    int childCount() const
    {
        return cast(int) m_childItems.length;
    }

    int columnCount() const
    {
        return cast(int) m_itemData.length;
    }

    QVariant data(int column)
    {
        return m_itemData[column];
    }

    int row() const
    {
        import std.algorithm : countUntil;
        if (m_parentItem)
            return cast(int) m_parentItem.m_childItems.countUntil(this);

        return 0;
    }

    TreeItem parentItem()
    {
        return m_parentItem;
    }

private:
    TreeItem[] m_childItems;
    QVariant[] m_itemData;
    TreeItem   m_parentItem;
}
