import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "common"

ComboBox {
    id: container

    property int fontSize: root.font.pointSize
    property int screenPadding: parent.Layout.margins
    property bool vkbd_installed: false

    function keyboardStatusChanged(state: bool) {
        vkbd_installed = state;
    }

    function actionPressed(id: int) {
        if (id == 0)
            root.activateVirtualKeyboard = !root.activateVirtualKeyboard;

    }

    background: null
    model: [{
        "value": root.activateVirtualKeyboard,
        "icon": "",
        "label": config.virtualKeyboard || "Virtual keyboard",
        "enabled": vkbd_installed
    }]

    indicator: Button {
        anchors.fill: parent
        onPressed: {
            container.popup.open();
        }

        Text {
            anchors.centerIn: parent
            renderType: Text.QtRendering
            text: ""
            font.family: iconFont
            color: container.focus ? root.palette.accent : root.palette.text
            font.pointSize: fontSize * 1.5
        }

        background: Rectangle {
            color: "transparent"
        }

    }

    delegate: Toggle {
        required property var modelData

        enabled: modelData['enabled']
        checked: modelData['value']
        icon: modelData['icon']
        text: modelData['label']
        Component.onCompleted: toggled.connect(container.actionPressed)
    }

    popup: PopupPanel {
        x: root.LayoutMirroring.enabled ? -parent.width : (2 * parent.width - width + parent.parent.spacing)
        interactive: false
        model: container.delegateModel
    }

}
