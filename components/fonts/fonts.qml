// fonts.qml
pragma Singleton
import QtQuick 2.15

Item {
    FontLoader {
        id: doomFont
        source: Qt.resolvedUrl("./Diphylleia-Regular.ttf")
    }

    readonly property string doomFont: doomFont.name
}
