import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import "../components"
//import "../components/utils.js" as Utils

Page {
    id: root
//    title: "Settings"

    property alias textToDisplay: textArea.text
    property int fontSizeFind: 1

    // function to find font size.
    function findFontSize() {
        for(var x=1; textArea.contentHeight < (root.height - units.gu(10)); x++) {
            fontSizeFind += 1
        }
    }

    // addind this delay for just to improve UI experience.
    Timer {
        id: textApearingDelay
        interval: 300
        running: false
        onTriggered: textArea.opacity = 1
    }

    // rotate screen this created little flick on the screen this is wht above Timer/Delay
    OrientationHelper {
        id: orientHelper
        transitionEnabled: false
        orientationAngle: parent.width > parent.height ? 0 : 90

        Text {
            id: textArea
            anchors.fill: parent
            anchors.margins: units.gu(1)
            wrapMode: Text.Wrap
            font.pixelSize: fontSizeFind
            color: "white"
            opacity: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            Behavior on opacity {
                PropertyAnimation {duration: 300}
            }

            Component.onCompleted: {
                findFontSize()
                textApearingDelay.start()
            }

        }
    }


    // touch the screen to go back
    MouseArea {
        anchors.fill: parent
        onClicked: mainPageStack.pop()
    }


}
