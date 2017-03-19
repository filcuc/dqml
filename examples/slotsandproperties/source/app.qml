import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
    width: 400
    height: 300

    Component.onCompleted: visible = true

    ColumnLayout {
        anchors.fill: parent

        Label { text: "Current name is:" + contact.name }

        TextField { id: textField }

        Connections {
            target: contact
            onNameChanged: console.log("Name Changed", name)
	    onSurnameChanged: console.log("Surname Changed", surname)
        }

        Button{
            text: "Change Name"
            onClicked: contact.name = textField.text
        }
    }
}
