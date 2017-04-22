module treemodel;

import dqml.qabstractitemmodel;
import dqml.qmodelindex;
import dqml.qvariant;
import dqml.qobject;
import dqml.qt;

import treeitem;
import custom_type : CustomType;

class TreeModel : QAbstractItemModel
{
public:
	
	enum TreeModelRoles
	{
		Name = UserRole + 1,
		Description
	}

	alias flags = QAbstractItemModel.flags;

	this(const string data, QObject parent = null)
	{
		super();
		m_roleNameMapping[TreeModelRoles.Name]        = "title";
		m_roleNameMapping[TreeModelRoles.Description] = "summary";

		QVariant[] rootData;
		rootData ~= new QVariant("Title" ~ "Summary");
		rootItem = new TreeItem(rootData);
		import std.string : split;
		setupModelData(data.split("\n"), rootItem);
	}

	~this()
	{
		destroy(rootItem);
	}

	/* QAbstractItemModel interface */
	override QVariant data(QModelIndex index, int role) const
	{
		if (!index.isValid())
			return new QVariant();

		if (role != TreeModelRoles.Name && role != TreeModelRoles.Description)
			return new QVariant();

		TreeItem item = cast(TreeItem)(index.internalPointer());

		return item.data(role - UserRole - 1);
	}

	override int flags(QModelIndex index)
	{
		if (!index.isValid())
			return 0;

		return super.flags(index);
	}

	override QModelIndex index(int row, int column,
					  QModelIndex parent = new QModelIndex())
	{
		if (!hasIndex(row, column, parent))
			return new QModelIndex();

		TreeItem parentItem;

		if (!parent.isValid())
			parentItem = rootItem;
		else
			parentItem = cast(TreeItem)(parent.internalPointer());

		TreeItem childItem = parentItem.child(row);
		if (childItem)
			return createIndex(row, column, cast(void*) childItem);
		else
			return new QModelIndex();
	}

	override QModelIndex parent(QModelIndex index)
	{
		if (!index.isValid())
			return new QModelIndex();

		TreeItem childItem = cast(TreeItem)(index.internalPointer());
		TreeItem parentItem = childItem.parentItem();

		if (parentItem == rootItem)
			return new QModelIndex();

		return createIndex(parentItem.row(), 0, cast(void*) parentItem);
	}

	override int rowCount(QModelIndex parent = new QModelIndex())
	{
		TreeItem parentItem;
		if (parent.column() > 0)
			return 0;

		if (!parent.isValid())
			parentItem = rootItem;
		else
			parentItem = cast(TreeItem)(parent.internalPointer());

		return parentItem.childCount();
	}

	override int columnCount(QModelIndex parent = new QModelIndex())
	{
		if (parent.isValid())
			return (cast(TreeItem)(parent.internalPointer())).columnCount();
		else
			return rootItem.columnCount();
	}

	override string[int] roleNames()
	{
		return m_roleNameMapping;
	}

private:

	QVariant newCustomType(const string text, int position)
	{
		CustomType t = new CustomType(this);
		t.setText(text);
		t.setIndentation(position);
		auto v = new QVariant();
		v.setValue(t);
		return v;
	}

	void setupModelData(const string[] lines, TreeItem parent)
	{
		TreeItem[] parents;
		int[] indentations;
		parents ~= parent;
		indentations ~= 0;

		int number = 0;

		while (number < lines.length) {
			int position = 0;
			while (position < lines[number].length) {
				if (lines[number][position] != ' ')
					break;
				position++;
			}

			import std.string : split, strip, squeeze;
			string lineData = lines[number][position..$].strip.squeeze;

			import std.array : empty, back, popBack;
			if (!lineData.empty) {
				// Read the column data from the rest of the line.
				string[] columnStrings = lineData.split("\t");
				QVariant[] columnData;
				for (int column = 0; column < columnStrings.length; ++column)
					columnData ~= newCustomType(columnStrings[column], position);

				if (position > indentations.back) {
					// The last child of the current parent is now the new parent
					// unless the current parent has no children.
					if (parents.back.childCount() > 0) {
						parents ~= parents.back.child(parents.back.childCount()-1);
						indentations ~= position;
					}
				} else {
					while (position < indentations.back && parents.length > 0) {
						parents.popBack;
						indentations.popBack;
					}
				}

				// Append a new item to the current parent's list of children.
				parents.back.appendChild(new TreeItem(columnData, parents.back));
			}

			++number;
		}
	}

	TreeItem    rootItem;
	string[int] m_roleNameMapping;
}
