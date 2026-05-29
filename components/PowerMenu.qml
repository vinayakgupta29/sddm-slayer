import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "common"

ComboBox {
    id: container

    property int fontSize: root.font.pointSize
    property bool forcePowerOptions: false

    background: null

    model: [
        {
            icon: "",
            label: config.suspend || text_const.suspend,
            enabled: sddm.canSuspend
        },
        {
            icon: "󰍷",
            label: config.hibernate || text_const.hibernate,
            enabled: sddm.canHibernate
        },
        {
            icon: "",
            label: config.reboot || text_const.reboot,
            enabled: sddm.canReboot
        },
        {
            icon: "",
            label: config.poweroff || text_const.shutdown,
            enabled: sddm.canPowerOff
        }
    ]

    textRole: "label"

    function actionPressed(index) {
        if (index === 0)
            sddm.suspend()
        else if (index === 1)
            sddm.hibernate()
        else if (index === 2)
            sddm.reboot()
        else if (index === 3)
            sddm.powerOff()
    }

    onActivated: {
        actionPressed(index)
    }

    indicator: Item {
        anchors.fill: parent

        Text {
            anchors.centerIn: parent

            renderType: Text.QtRendering

            text: "󰐥"

            font.family: iconFont
            font.pointSize: fontSize * 1.5

            color: container.focus
                   ? root.accent
                   : root.palette.text
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                container.popup.open()
            }
        }
    }

    delegate: ItemDelegate {
        id: power_option

        required property var model


        width: 220
        height: fontSize * 3

        background: Rectangle {
            anchors.fill: parent

            radius: 6

            color: power_option.highlighted
                   ? root.accent
                   : "transparent"
        }

        Row {
            anchors {
                left: parent.left
                leftMargin: 12
                verticalCenter: parent.verticalCenter
            }

            spacing: fontSize

            Text {
                visible: config.boolValue("iconsInMenus")

                renderType: Text.QtRendering

                text: model.icon

                font.family: iconFont
                font.pointSize: fontSize

                color: "white"
            }

            Text {
                renderType: Text.QtRendering

                text: model.label

                font.family: root.font.family
                font.pointSize: fontSize

                color: "white"
            }
        }

        onClicked: {
            container.currentIndex = index
            container.actionPressed(index)
            container.popup.close()
        }
    }

popup: Popup {
    y: container.height

    width: 260

    x: -width + container.width

    padding: 6

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

