import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "common"

ComboBox {
    id: container

    property int fontSize: root.font.pointSize

    background: null

    model: sessionModel
    textRole: "name"

    Component.onCompleted: {
        currentIndex = sessionModel.lastIndex
    }

    onActivated: {
        sessionModel.lastIndex = index
        currentIndex = index
    }

    indicator: Item {
        anchors.fill: parent

        Text {
            anchors.centerIn: parent

            renderType: Text.QtRendering

            text: "󰍹"

            font.family: iconFont
            font.pointSize: fontSize * 1.5

            color: container.focus
                   ? root.accent
                   : root.palette.text

            Text {
                visible: config.boolValue("displaySession")

                anchors {
                    left: parent.right
                    leftMargin: fontSize
                    verticalCenter: parent.verticalCenter
                }

                renderType: Text.QtRendering

                text: container.currentText

                font.family: root.font.family
                font.pointSize: fontSize

                color: root.palette.text
            }
        }

        MouseArea {
            anchors.fill: parent

            hoverEnabled: true

            onClicked: {
                container.popup.open()
            }
        }
    }

    delegate: ItemDelegate {
        id: session_item

        highlighted: container.currentIndex === index

        implicitHeight: fontSize * 3
        implicitWidth: label.width

        Layout.fillWidth: true

        background: Rectangle {
            radius: 6

            color: session_item.highlighted
                   ? root.accent
                   : "transparent"

            opacity: container.highlightedIndex === index
                     ? 0.4
                     : 1
        }

        Text {
            id: label

            padding: 10

            anchors.verticalCenter: parent.verticalCenter

            renderType: Text.QtRendering

            text: name

            font.family: root.font.family
            font.pointSize: fontSize

            color: root.palette.buttonText
        }

        onClicked: {
            container.currentIndex = index
            sessionModel.lastIndex = index
            container.popup.close()
        }
    }

    popup: Popup {
        y: container.height

        width: 220

        padding: 0

        background: Rectangle {
            radius: 8
            color: root.palette.button
        }

        contentItem: ListView {
            clip: true

            implicitHeight: contentHeight

            model: container.delegateModel
            delegate: container.delegate
        }
    }
}
