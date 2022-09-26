import QtQuick 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
    id: main
    width: 400
    height: 150

    Component.onCompleted: visible = true

    Connections {
        target: receiver
        onMessageReceived: {
            var date = new Date()
            var text = date.getHours()
                + ":" + date.getMinutes()
                + ":" + date.getSeconds()
                + ":" + date.getMilliseconds()
                + " - " + message + "\n"
            textArea.append(text)
        }
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true

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

        TextArea {
            id: textArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: 100
            readOnly: true
        }
    }
}
