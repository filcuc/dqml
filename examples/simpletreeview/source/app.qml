import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import CustomModule 1.0

ApplicationWindow {
    visible: true
    title: qsTr("Simple Tree View")

    TreeView {
        anchors.fill: parent
        model: theModel
        itemDelegate: Item {
            Text {
                anchors.fill: parent
                color: styleData.textColor
                elide: styleData.elideMode
                text: styleData.value.indentation + " : " + styleData.value.text
            }
        }

        TableViewColumn {
            role: "title"
            title: "Title"
        }

        TableViewColumn {
            role: "summary"
            title: "Summary"
        }
    }
}
