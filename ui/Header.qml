import QtQuick 2.3
import Ubuntu.Components 1.1
//import Ubuntu.Components.Popups 1.0

Row {
    height: units.gu(5)
    spacing: units.gu(1)

    signal toClicked
    signal fromClicked

    property color clickBGcolor: "#a7b4d1"


    Rectangle {
        width: root.width / 2 - units.gu(8)
        height: parent.height
        color: "transparent"
        Item {
            id: leftPane
            height: parent.height
//            width: root.width / 2 - units.gu(5)
            width: parent.width
            anchors.right: parent.right
            //                            color: "green"
            Behavior on width {
                NumberAnimation {
                    duration: 200
                }
            }
            clip: true
            onWidthChanged: width === units.gu(0) ? [width = root.width / 2 - units.gu(8),languageSwap()] : null

            Label {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.Center
                //                                text: "Polish ⌄"
                text: currentLanguageUsed.contents.from + " ⌄"
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 1
                fontSize: "large"
            }

        }

        MouseArea {
            anchors.fill: parent
//            activeFocusOnPress: true
            onClicked: {
//                print("From: " + currentLanguageUsed.contents.from)
//                Qt.inputMethod.hide();
                translateTextArea.focus = false
                if(popoversMain.state === "showFromList"){
                    popoversMain.state = ""
                } else {
                    popoversMain.state = "showFromList"
                }
//                if (popoverListFROM.isOpen === true) {
//                    popoverListFROM.isOpen = false
//                    popoverHeaderMenu.isOpen = false
//                } else {
//                    popoverListFROM.isOpen = true
//                    popoverListTO.isOpen = false
//                    popoverHeaderMenu.isOpen = false
//                }
                fromClicked()
            }
            onPressed: parent.color = clickBGcolor
            onReleased: parent.color = "transparent"

        }
    }

    Rectangle {
        id: switchButtonBG
        width: units.gu(5)
        height: parent.height
        radius: width / 2
        color: "transparent"
//        Behavior on color {
//            ColorAnimation {
//                duration: 100
//            }
//        }

        Icon {
            width: units.gu(4)
            height: width
            anchors.centerIn: parent
            name: "user-switch"
            color: "white"
            Behavior on rotation {
                NumberAnimation{
                    duration: 200
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
//                    Qt.inputMethod.hide();
                    leftPane.width = units.gu(0)
                    rightPane.width = units.gu(0)
                    parent.rotation = parent.rotation === 0 ? 180 : 0
                    popoversMain.state = ""
//                    popoverListTO.isOpen = false
//                    popoverListFROM.isOpen = false
//                    popoverHeaderMenu.isOpen = false
                }
                onPressed: switchButtonBG.color = clickBGcolor
                onReleased: switchButtonBG.color = "transparent"
            }
        }
    }


    Rectangle {
        width: root.width / 2 - units.gu(7)
        height: parent.height
        color: "transparent"

        Item {
            id: rightPane
//            width: root.width / 2 - units.gu(10)
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            //                            color: "yellow"
            clip: true
            Behavior on width {
                NumberAnimation {
                    duration: 200
                }
            }
            onWidthChanged: width === units.gu(0) ? width = root.width / 2 - units.gu(7) : null


            // TODO fix problems with cat text for long launguage label...
            Label {
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.Center
                text: currentLanguageUsed.contents.to + " ⌄"
//                text: width > parent.width ? currentLanguageUsed.contents.to.slice(0,(currentLanguageUsed.contents.to.length - 5)) + ".. ⌄" : currentLanguageUsed.contents.to + " ⌄"
                fontSize: "large"
//                wrapMode: Text.WrapAnywhere
//                maximumLineCount: 1
//                onTextChanged: {
//                    if(width > parent.width) {
//                        print("ooo: " + parent.width - width)
//                    }
//                }

            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
//                print("To: " + currentLanguageUsed.contents.to)
//                PopupUtils.open(popoverWithFlickable, parent)
//                Qt.inputMethod.hide();
                translateTextArea.focus = false
                if(popoversMain.state === "showToList"){
                    popoversMain.state = ""
                } else {
                    popoversMain.state = "showToList"
                }

//                if (popoverListTO.isOpen === true) {
//                    popoverListTO.isOpen = false
//                } else {
//                    popoverListTO.isOpen = true
//                    popoverListFROM.isOpen = false
//                }
                toClicked()
            }
            onPressed: parent.color = clickBGcolor
            onReleased: parent.color = "transparent"

        }
    }

}
