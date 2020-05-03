import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
//import "../components"
//import "../components/utils.js" as Utils

Page {
    id: root
    title: "Settings"

    Grid {
        width: parent.width - units.gu(2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: units.gu(1)
        columns: 2
        rowSpacing: units.gu(1.5)
        columnSpacing: units.gu(2)

        // Storing every translation on device
        Label {
            text: "Store translations on device:"
        color: "lightgray"
            font.bold: true
        }

        Switch {
            height: units.gu(3)
            enabled: false
        }

        // Suggestions
        Label {
            text: "Show word suggestions:"
            font.bold: true
            color: "lightgray"
        }

        Switch {
            height: units.gu(3)
            enabled: false
        }



        Label {
            text: "Clear history and favorites:"
            font.bold: true
        }

        Button {
            height: units.gu(2.3)
            text: "<b>Clear</b>"
            color: "red"
            onClicked: {
                u1dbControler._clearTranslateHitory()
            }
        }

    }

}
