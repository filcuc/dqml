import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import ContactModule 1.0


ApplicationWindow
{
    width: 400
    height: 300
    title: "Hello World"

    Contact {
        id: contact
        objectName: "contact"
        firstName: "Filippo"
        lastName: "Cucchetto"
    }

    Label { anchors.centerIn: parent; text: contact.firstName + " " + contact.lastName }

    Component.onCompleted: visible = true
}
