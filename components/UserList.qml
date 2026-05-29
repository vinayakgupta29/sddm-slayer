import QtQuick 2.15
import QtQuick.Controls 2.15
import "common"

ComboBox {
    id: container

    property int fontSize: root.font.pointSize
    property int optionHeight: fontSize * 3

    signal userSelected()

    background: null
    model: userModel
    currentIndex: model.lastIndex
    textRole: "name"
    onActivated: userSelected()

    indicator: Button {
        anchors.fill: parent
        onPressed: {
            container.popup.open();
        }

        Text {
            anchors.centerIn: parent
            renderType: Text.QtRendering
            text: ""
            font.family: iconFont
            color: container.focus ? root.palette.accent : root.palette.text
            font.pointSize: fontSize * 1.4
        }

        background: Rectangle {
            color: "transparent"
        }

    }

    delegate: ItemDelegate {
        id: user_item

        implicitHeight: optionHeight
        implicitWidth: container.popup.width
        highlighted: container.currentIndex === index
        states: [
            State {
                name: "highlighted"
                when: index === container.highlightedIndex

                PropertyChanges {
                    target: user_item.background
                    color: "#777777"
                    opacity: 0.4
                }

            }
        ]

        Text {
            id: label

            width: parent.width
            padding: 10
            anchors.verticalCenter: user_item.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            renderType: Text.QtRendering
            text: model.realName != "" ? model.realName : model.name
            font.family: root.font.family
            font.pointSize: fontSize
            color: root.palette.buttonText
        }

        background: Rectangle {
            color: "transparent"
        }

    }

    popup: PopupPanel {
        width: container.parent.width
        y: -height
        model: container.delegateModel
    }

}
