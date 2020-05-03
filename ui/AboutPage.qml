import QtQuick 2.3
import Ubuntu.Components 1.2
import "../components"
import QtGraphicalEffects 1.0
import QtQuick.XmlListModel 2.0


Page {
    id: root
    title: "About"

    clip: true

    // list model of my apps
    XmlListModel {
        id: myAppsModel
        source: "https://dl.dropboxusercontent.com/u/4467345/myUbuntuTouchAppsList.xml"
        query: "/apps/Item"
        XmlRole { name: "app_name"; query: "@appName/string()" }
        XmlRole { name: "icon_url"; query: "@iconUrl/string()" }
        XmlRole { name: "search_string"; query: "@searchString/string()" }
    }


    // BG
    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    // item to put flickable in to it only to prevent header from hiding.
    Item {
        anchors.fill: parent
        anchors.margins: units.gu(2)

        // main flickable
        Flickable {
            id: flickMain
            anchors.fill: parent

//            anchors.margins: units.gu(2)
            contentHeight: mainColumn.height
//            clip: true

            Column {
                id: mainColumn
                width: parent.width
                spacing: units.gu(3)
                Row {
                    //                    height: units.gu(10)
                    spacing: units.gu(1)
                    UbuntuShape {
                        height: units.gu(10)
                        width: height
                        radius: "medium"
                        image: Image {
                            //                            fillMode: Image.PreserveAspectFit
                            //                            height: units.gu(4)
                            source: Qt.resolvedUrl("../graphics/me.jpg")
                        }
                    }

                    Column {
                        spacing: units.gu(0.5)
                        width: mainColumn.width - units.gu(10)
                        Image {
                            height: units.gu(3)
                            fillMode: Image.PreserveAspectFit
                            source: Qt.resolvedUrl("../translator-app.png")
//                            ColorOverlay {
//                                anchors.fill: parent
//                                source: parent
//                                color: mainView.backgroundColor  // make image like it lays under red glass
//                            }
                        }
                        Label {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: "Application by Szymon Waliczek"
                            color: "black"
                        }
                        Label {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: "Version: " + manifestJSONmodel.model.get(0).version
                            color: "#444444"
                            fontSize: "x-small"
                        }
                        Label {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: "© 2015 Szymon Waliczek"
                            fontSize: "x-small"
                            color: "#444444"
                        }
                    }
                }


                // Feedback button
                Item {
                    width: flickMain.width
                    height: units.gu(5)
                    Button {
                        text: "<b>Send me your Feedback</b>"
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: backgroundColor
                        onClicked: Qt.openUrlExternally("mailto:majsterrr@gmail.com")
                    }
                }

                // Feedback button
                Item {
                    width: flickMain.width
                    height: units.gu(5)
                    Button {
                        text: "<b>Rate this app</b>"
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#28a297"
                        onClicked: Qt.openUrlExternally("scope://com.canonical.scopes.clickstore?q=szymontranslator")
                    }
                }



                Column {
                    spacing: units.gu(1)
                    Label {
                        width: flickMain.width
                        wrapMode: Text.WordWrap
                        text: 'Licence: <a href="http://www.gnu.org/licenses/gpl-3.0.html">GPLv3</a>'
                        color: "#444444"
                        fontSize: "small"
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    Label {
                        width: flickMain.width
                        wrapMode: Text.WordWrap
                        text: 'Source: <a href="https://launchpad.net/rad-io">Launchpad</a>'
                        color: "#444444"
                        fontSize: "small"
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                }



                Column {
                    spacing: units.gu(1.5)
//                    Label {
//                        text: "Phrase translation by <b>glosbe</b>"
//                        color: backgroundColor
//                        MouseArea {
//                            anchors.fill: parent
//                            onClicked: {
//                                Qt.openUrlExternally('https://glosbe.com/')
//                            }
//                        }
//                    }

                    Label {
                        text: "All translation done by <b>yandex</b>"
                        color: backgroundColor
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Qt.openUrlExternally('https://translate.yandex.com/')
                            }
                        }
                    }
                }



                // column to hold listview with myApps.
                Column {
                    width: parent.width
                    spacing: units.gu(0.3)
//                    visible: myAppsModel.status == XmlListModel.Ready ? true : false
                    Label {
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: "More apps from Szymon:"
                        color: "#444444"
                    }
                    ListView {
                        width: parent.width
                        height: units.gu(11)
                        clip: true
                        spacing: units.gu(0.5)
                        model: myAppsModel
                        interactive: contentWidth > width ? true : false
                        orientation: Qt.Horizontal
                        delegate: MyAppDelegate {
                            width: units.gu(7)
                            appName: app_name
                            iconSource: icon_url
                            onClick: Qt.openUrlExternally("scope://com.canonical.scopes.clickstore?q="+search_string)
                        }
                        ActivityIndicator {
                            width: units.gu(2)
                            height: width
                            anchors.centerIn: parent
                            running: myAppsModel.status == XmlListModel.Ready ? false : true
                        }


                    }
                }


            }


        }



    }
}
