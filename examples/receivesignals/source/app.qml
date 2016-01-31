import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
    id: main

    width: 400
    height: 60

    title: "Signalling test"

    signal broadcast(string message)

    Component.onCompleted: {
        visible = true
        receiver.register(main)
    }

    Column {
        width: parent.width

        Row {
            width: parent.width

            TextField {
                id: message

                width: parent.width - 200

                placeholderText: qsTr("Message")
            }

            Button {
                width: 200

                text: qsTr("Broadcast message")
                onClicked: broadcast(message.text)
            }
        }

        Button {
            id: controller

            onClicked: {
                if (state == "Silent") state = "Broadcasting"
                else state = "Silent"
            }

            state: "Silent"
            states: [
                State {
                    name: "Silent"
                    PropertyChanges { target: controller; text: qsTr("Start broadcasting numbers") }
                    StateChangeScript { script: numberBroadcaster.stop() }
                },
                State {
                    name: "Broadcasting"
                    PropertyChanges { target: controller; text: qsTr("Stop broadcasting numbers") }
                    StateChangeScript { script: numberBroadcaster.start() }
                }
            ]
        }
    }
}
