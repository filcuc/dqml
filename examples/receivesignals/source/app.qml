import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
    id: main
    width: 400
    height: 60

    Component.onCompleted: visible = true

    RowLayout {
        anchors.fill: parent

        Item { Layout.fillWidth: true; }
        Button { text: "Start"; onClicked: sender.start(); }
        TextField {
            Layout.fillWidth: true;
            text: "";
            placeholderText: "Input your message here.."
            onEditingFinished: sender.message = text
        }
        Button { text: "Stop";  onClicked: sender.stop(); }
        Item { Layout.fillWidth: true; }
    }
}
