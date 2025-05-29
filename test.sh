#!/bin/bash

FONT_DIR="/home/zoro/Downloads/Delius_Unicase,Diphylleia,Macondo_Swash_Caps"
QML_FILE="preview_all_fonts.qml"

cat <<EOF >"$QML_FILE"
import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 1000
    height: 2000
    visible: true
    title: "All Font Previews"

    Rectangle {
        anchors.fill: parent
        color: "#111"

        Flickable {
            anchors.fill: parent
            contentHeight: childrenRect.height

            Column {
                width: parent.width
                spacing: 20
EOF

i=0
while IFS= read -r -d '' font_path; do
    [ -f "$font_path" ] || continue

    id="font$i"
    font_name=$(basename "$font_path")

    echo $font_name
    font_url="file://$font_path"

    echo "                FontLoader { id: $id; source: \"$font_url\" }" >>"$QML_FILE"
    echo "                Text { text: \"Wlcome Home! Great Slayer\"; font.family: $id.name; font.pointSize: 24; color: \"white\" }" >>"$QML_FILE"

    i=$((i + 1))
done < <(find "$FONT_DIR" -type f -name '*.ttf' -print0)
echo loop done
cat <<EOF >>"$QML_FILE"
            }
        }
    }
}
EOF

# Launch preview
qmlscene "$QML_FILE"
