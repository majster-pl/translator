import QtQuick 2.3
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem

// rectangle to hold lsit with languages
Rectangle {
    id: popoverListTO
    property bool isOpen: false
    property double mainColumntHeight: mainColumn.height
    width: parent.width
    height: parent.height
    color: "#6279ab"
    clip: true

    signal click

    Behavior on y {
        PropertyAnimation {duration: 250; easing.type: Easing.InCirc}
    }

    onIsOpenChanged: {
        if(isOpen) {
            languagesListViewFROM.positionViewAtBeginning()
        }
    }

    ListModel {
        id: headerMenuListMODEL
        ListElement { name: "Settings"; page: "SettingsPage.qml" }
        ListElement { name: "Favorite"; page: "FavoritePage.qml" }
        ListElement { name: "About"; page: "AboutPage.qml" }
    }


    Column {
        id: mainColumn
        width: parent.width

        Repeater {
            model: headerMenuListMODEL
            delegate: ListItem.Standard {
                height: units.gu(4)
                text: name
                onClicked: {
                    click()
                    mainPageStack.push(Qt.resolvedUrl("../ui/"+page))
                }
            }
        }
    }

}
