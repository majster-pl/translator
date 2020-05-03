import QtQuick 2.4
import Ubuntu.Components 1.2
//import Ubuntu.Components.ListItems 1.0 as ListItem

//import Ubuntu.Components.Popups 1.0
//import "../components"
//import "../components/utils.js" as Utils

Page {
    id: root
    title: "Favorite"

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    ListItemActions {
        id: exampleLeadingActions
        actions: [
            Action {
                iconName: "delete"
                onTriggered: {
                    u1dbControler._removeFromFavorites(value)
                }
            }
        ]
    }


    Column {
        width: parent.width
        anchors.centerIn: parent
        spacing: units.gu(1)
        visible: mainFavoriteListView.contentHeight > 0 ? false : true
        Item {
            height: units.gu(7)
            width: height
            anchors.horizontalCenter: parent.horizontalCenter

            Icon {
                height: units.gu(7)
                width: height
                name: "history"
            }
        }

        Label {
            width: parent.width
            text: "No favorites yet"
            horizontalAlignment: Text.AlignHCenter
            fontSize: "large"
            color: "grey"
        }
    }


    Component {
        id: listItemDelegat
        ListItem {
            width: root.width
            height: u1dbControler._checkInFavorites(index) === 0 ? 0 : mainTextColumn.height + units.gu(2)
            anchors.horizontalCenter: parent.horizontalCenter
            visible: u1dbControler._checkInFavorites(index)
//            height: u1dbControler._checkInFavorites(index) === 0 ? 0 : __height + units.gu(0.3) // this last bit only to give more spacing if subtitle is longer then 2 lines.

            Rectangle {
                id: listItemBG
                anchors.fill: parent
                color: listItemMouseArea.pressed ? 'lightgray' : 'transparent'
            }

//            leadingActions: exampleLeadingActions
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                    }
                ]
            }

            MouseArea {
                id: listItemMouseArea
                anchors.fill: parent
                onClicked: {
                    mainPageStack.pop()
                    set_language_from(from_lang, from_code)
                    set_language_to(to_lang, to_code)
                    translateTextArea.text = from_phrase
                    translatedString = to_phrase
                    translationAndSuggestionPane.state = "visible"
                }
            }

            Row {
                anchors {
                    fill: parent;
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                    topMargin: units.gu(1)
                    bottomMargin: units.gu(1)
                }

//                anchors.margins: units.gu(1)
                spacing: units.gu(1)
                Column {
                    id: mainTextColumn
                    width: parent.width - controlsRow.width - units.gu(1)
                    spacing: units.gu(0.2)
                    Label {
                        width: parent.width
                        maximumLineCount: 1
                        color: "black"
                        wrapMode: Text.Wrap
                        clip: true
                        text: '<i>'+from_lang+": </i><b>"+from_phrase+'</b>'
                    }
                    Label {
                        width: parent.width
                        maximumLineCount: 8
                        color: "gray"
                        wrapMode: Text.Wrap
                        text: '<i>'+to_lang+": <b>" +to_phrase+'</b>'
                    }

                }



                Row {
                    id: controlsRow
                    height: units.gu(4)
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: units.gu(-1)
                    spacing: units.gu(1)
                    Icon {
                        id: iconFullScreen
                        width: parent.height - units.gu(1)
                        height: width
                        name: "view-fullscreen"
                        color: iconFullScreenMA.pressed === true ? "lightgray" : "gray"
                        MouseArea {
                            id: iconFullScreenMA
                            anchors.fill: parent
                            onClicked: mainPageStack.push(Qt.resolvedUrl("FullScreenPage.qml"), {textToDisplay: to_phrase})

                        }
                    }
                    Item {
                        id: iconCopyBase
                        width: parent.height - units.gu(1)
                        height: width

                        Icon {
                            id: iconCopy
                            width: parent.height
                            height: width
                            anchors.centerIn: parent

                            SequentialAnimation {
                                id: seqAnimation
                                running: false
                                loops: 1
                                PropertyAnimation { target: iconCopy; property: "width"; to: iconCopyBase.height + units.gu(1); duration: 300; easing.type: Easing.InOutBack }
                                PropertyAnimation { target: iconCopy; property: "width"; to: iconCopyBase.height; duration: 80; /*easing.type: Easing.InBack*/ }
                            }

                            Behavior on width {
                                PropertyAnimation { }
                            }
//                            Behavior on height {
//                                PropertyAnimation { }
//                            }

                            //                                            anchors.fill: parent
                            name: "edit-copy"
                            color: iconCopyMA.pressed === true ? "lightgray" : "gray"
                            MouseArea {
                                id: iconCopyMA
                                anchors.fill: parent
                                onClicked: {
//                                    iconCopy.state = "bouns"
                                    seqAnimation.start()
                                    Clipboard.push(to_phrase)
                                }

                            }
                        }


                    }
                }

            }


        }
    }

    UbuntuListView {
        id: mainFavoriteListView
        width: parent.width
//        height: contentHeight > parent.height ? parent.height : contentHeight
        height: parent.height
        model: translationHistoryModel
        clip: true
        delegate: listItemDelegat
//        delegate: ListItem.Standard {
//            removable: true
//            text: '<font color="black"><i>'+from_lang+": </i><b>"+from_phrase+'</font>'
////            subText: '<font color="gray"><i>'+to_lang+": <b>" +to_phrase+'</font>'
//            showDivider: index+1 === translationHistoryListView.count ? false : true
//            onItemRemoved: u1dbControler._removeFromFavorites(index)
//            visible: u1dbControler._checkInFavorites(index)
//            height: u1dbControler._checkInFavorites(index) === 0 ? 0 : __height + units.gu(0.3) // this last bit only to give more spacing if subtitle is longer then 2 lines.
////                        __contentsMargins
//            onClicked: {
//                set_language_from(from_lang, from_code)
//                set_language_to(to_lang, to_code)
//                translateTextArea.text = from_phrase
//                translationAndSuggestionPane.state = "waiting"
//                print("INDEX: "+index)
//                serachDelay.start()
//            }


//            Rectangle {
//                width: translatedTextToolbarRow.width
//                height: parent.height - units.gu(0.5)
//                anchors.right: parent.right
//                anchors.verticalCenter: parent.verticalCenter
////                Icon {
////                    id: iconStart
////                    width: units.gu(3)
////                    anchors.centerIn: parent
////                    name: is_starred == 1 ? "starred" : "non-starred"
////                }


//                Row {
//                    id: translatedTextToolbarRow
//                    height: parent.height
//                    spacing: units.gu(1)
////                                        anchors.margins: units.gu(0.5)

//                    Icon {
//                        id: iconFullScreen
//                        width: parent.height - units.gu(1)
//                        height: width
////                                            anchors.fill: parent
//                        name: "view-fullscreen"
//                        color: iconFullScreenMA.pressed === true ? "lightgray" : "gray"
//                        MouseArea {
//                            id: iconFullScreenMA
//                            anchors.fill: parent
////                                                onPressed: {parent.color = backgroundColor; iconCopy.color = "white"}
////                                                onReleased: {parent.color = "white"; iconCopy.color = "gray"}
//                            onClicked: mainPageStack.push(Qt.resolvedUrl("ui/FullScreenPage.qml"), {textToDisplay: translatedString})

//                        }
//                    }

//                    Icon {
//                        id: iconCopy
//                        width: parent.height - units.gu(1)
//                        height: width
////                                            anchors.fill: parent
//                        name: "edit-copy"
//                        color: iconCopyMA.pressed === true ? "lightgray" : "gray"
//                        MouseArea {
//                            id: iconCopyMA
//                            anchors.fill: parent
////                                                onPressed: {parent.color = backgroundColor; iconCopy.color = "white"}
////                                                onReleased: {parent.color = "white"; iconCopy.color = "gray"}
//                            onClicked: Clipboard.push(translatedString)

//                        }
//                    }

//                }

//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
////                                    u1dbControler._addToFavorites(from_lang,from_code,from_phrase,to_lang,to_code,to_phrase)
//                        if(iconStart.name === "starred"){
//                            u1dbControler._removeFromFavorites(index)
//                        } else {
//                            u1dbControler._addToFavorites(index)
//                        }
//                    }
//                }

//            }


////                        iconName: "starred"
////                        iconFrame: false
////                        progression: true
//        }
    }

}
