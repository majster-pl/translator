import QtQuick 2.3
import Ubuntu.Components 1.2
import QtGraphicalEffects 1.0
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import QtQuick.XmlListModel 2.0
import U1db 1.0 as U1db
import "ui"
import "components"
import "components/utils.js" as Utils

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.majster-pl.translator-app"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
//    useDeprecatedToolbar: false
    //    anchorToKeyboard: true

    width: units.gu(50)
    height: units.gu(75)
    backgroundColor: "#6279ab"
    //    backgroundColor: "yellow"


    property bool blinkingCursor: true // blinking cursor
    //    property bool translatingInProgress: false
    property string translatedString: "initial"

    onTranslatedStringChanged: {
//        print(translatedString)
        translationAndSuggestionPane.state = "visible"
        if(translatedString !== "") {
        u1dbControler._addToTranslationHistory(currentLanguageUsed.contents.from, currentLanguageCodeUsed.contents.from, translateTextArea.text,
                                               currentLanguageUsed.contents.to, currentLanguageCodeUsed.contents.to,translatedString)
        }


    }

    //    onTranslatedStringChanged: print("NOWY STRING: "+translatedString)


    // function to swap two selected languages
    function languageSwap() {
        var tempFrom = currentLanguageUsed.contents.from
        var tempTo = currentLanguageUsed.contents.to
        var tempFromCode = currentLanguageCodeUsed.contents.from
        var tempToCode = currentLanguageCodeUsed.contents.to
        //        firstRunDoc.contents = { firstrun: "false" }
        currentLanguageUsed.contents = {from: tempTo, to: tempFrom}
        currentLanguageCodeUsed.contents = {from: tempToCode, to: tempFromCode}
        //        translationAndSuggestionPane.state = "hiden"

    }

    // function to set launguage FROM:
    function set_language_from(country_name, country_code) {
        currentLanguageUsed.contents = {from: country_name, to: currentLanguageUsed.contents.to}
        currentLanguageCodeUsed.contents = {from: country_code, to: currentLanguageCodeUsed.contents.to}
        if(country_name.toLowerCase() === currentLanguageUsed.contents.to.toLowerCase()) {
            set_language_to("-----", "--")
        }
        if(translationAndSuggestionPane.state === "visible"){
            translationAndSuggestionPane.state = "hiden"
        }
    }

    // function to set launguage TO:
    function set_language_to(country_name, country_code) {
        currentLanguageUsed.contents = {from: currentLanguageUsed.contents.from, to: country_name}
        currentLanguageCodeUsed.contents = {from: currentLanguageCodeUsed.contents.from, to: country_code}
        if(country_name.toLowerCase() === currentLanguageUsed.contents.from.toLowerCase()) {
            set_language_from("-----", "--")

        }
        if(translationAndSuggestionPane.state === "visible"){
            translationAndSuggestionPane.state = "hiden"
        }
    }

    // Timer to delay search result... ( mainly for animation... )
    Timer {
        id: serachDelay
        interval: 1000
        onTriggered: {
            //            print(("@@@@@@ CODE > "+currentLanguageCodeUsed.contents.from))
            Utils.translate_string(translateTextArea.text, currentLanguageCodeUsed.contents.from, currentLanguageCodeUsed.contents.to)

        }
    }

    // Timer for ERROR when translating string
    Timer {
        id: errorTimer
        interval: 5000
        running: false
        onTriggered: {
            if(((translatedXmlMODEL.status === XmlListModel.Loading) && (translatedString !== "initial")) || translatedXmlMODEL.status === XmlListModel.Error){
                translatedString = '<font color="red"><b>error.</b><p>Please check your internet connection and try again!</font>'
//                translationAndSuggestionPane.state = "visible"
            }

        }
    }

    // JSON model for application version
    JSONListModel {
        id: manifestJSONmodel
//        source: Qt.resolvedUrl(".click/info/%1.manifest".arg(applicationName))
        source: Qt.resolvedUrl("manifest.json")
        query: "$"
    }





    // List model to hold translated string
    XmlListModel {
        id: translatedXmlMODEL
        //        source: Qt.resolvedUrl("test.xml")
        query: "/Translation/text"
        XmlRole { name: "traslationString"; query: "string()" }

        // when list ready, write result to string.
        onStatusChanged: {
            //            print("TERAZ STATUS JEST: " + status)
            if(status === XmlListModel.Ready){
                print(translatedXmlMODEL.count)
                translatedString = ""
                var tempString = ""
                // adding NEW LINE in the end if there is more then one line of string to translate.
                for(var a = 0; a < translatedXmlMODEL.count; a++){
                    if(a+1 == translatedXmlMODEL.count) {
                        tempString += (translatedXmlMODEL.get(a).traslationString)
                    } else {
                        tempString += (translatedXmlMODEL.get(a).traslationString + '\n')
                    }

                }

//                translationAndSuggestionPane.state = "visible"
                translatedString = tempString
            } else if(((status === XmlListModel.Loading) && (translatedString !== "initial")) || status === XmlListModel.Error) {
                print("Searching for translation....")
                errorTimer.start()
            }
        }
    }


    // list model to holds suggestions
    XmlListModel {
        id: suggestionsXmlMODEL
        source: "http://suggestqueries.google.com/complete/search?output=toolbar&hl="+currentLanguageCodeUsed.contents.from+"&q="+translateTextArea.text
        query: "/toplevel/CompleteSuggestion/suggestion"
        XmlRole { name: "suggestion"; query: "@data/string()" }


    }

    // U1DB database
    //

    // Definig U1 database
    U1db.Database {
        id: storage
        path: "translator-app.u1db"
    }

    // Document to store recently used Lanugages (last five)
    U1db.Document {
        id: recentLangHistoryDoc
        database: storage
        docId: "recentlyUsedLangs"
        create: true
        defaults: { "history" }
    }
    // List to hold up to 5 lastly used Languages.
    ListModel {
        id: recentlyUsedLangsModel
    }


    // Document to store recently translated strings.
    U1db.Document {
        id: translationHistoryDoc
        database: storage
        docId: "recentlyUsedTranslations"
        create: true
        defaults: { "history" }
    }
    // List to hold translation history
    ListModel {
        id: translationHistoryModel
    }
    // Listmodel to hold favorite translations
    ListModel {
        id: favoriteTranslationsModel
    }


    // Document to store last used language NAME
    U1db.Document {
        id: currentLanguageUsed
        database: storage
        docId: "current-language"
        create: true
        defaults: { "from": "English",  "to": "French" }
    }

    // Document to store last used language CODE
    U1db.Document {
        id: currentLanguageCodeUsed
        database: storage
        docId: "current-language-code"
        create: true
        defaults: { "from": "en",  "to": "fr" }
    }

//    // Document to store last used language NAME
//    U1db.Document {
//        id: settingsDoc
//        database: storage
//        docId: "app-settings"
//        create: true
//        defaults: { "localStorage": "true",  "showSuggestions": "true" }
//    }

    // U1DB controler
    U1dbModel {
        id: u1dbControler
    }

    // list of countries with country code.
    XmlListModel {
        id: xmlCountryList
        source: Qt.resolvedUrl("countryList.xml")
        //        query: "/country_list/country"
        query: "/langs/Item"

        XmlRole { name: "country_name"; query: "@value/string()" }
        XmlRole { name: "country_code"; query: "@key/string()" }
    }


    //    // WORKAROUND - Helper for popover to be drawn in right place
    //    Item {
    //        width: parent.width
    //        height: 2
    //        //        color: "pink"
    //        y: units.gu(4)
    //        Row {
    //            height: parent.height
    //            Item {
    //                id: popoverLeftHELPER
    //                width: root.width / 2
    //                height: parent.height
    //            }
    //            Item {
    //                id: popoverRigthHELPER
    //                width: root.width / 2
    //                height: parent.height
    //            }
    //        }

    //    }

    PageStack {
        id: mainPageStack
        Component.onCompleted: push(root)

        Page {
            id: root
            title: i18n.tr("Translate") // have to be here, otherwise header is hiden.
            clip: true

            state: "default"
            states: [
                PageHeadState {
                    name: "default"
                    head: root.head
                    actions: [
                        Action {
                            iconName: "contextual-menu"
                            text: "search"
                            onTriggered: {
                                if(popoversMain.state === "showHederMenu"){
                                    popoversMain.state = ""
                                } else {
                                    popoversMain.state = "showHederMenu"
                                }
//                                mainPageStack.push(Qt.resolvedUrl("ui/AboutPage.qml"))
                            }
                        }

                    ]
                    contents: Header {
                        onFromClicked: {
                            //                        PopupUtils.open(popoverWithFlickable, popoverLeftHELPER)
                            //                        fromPopoverOpen = true
                            //                        popoverListFROM.isOpen = true
                        }
                        onToClicked: {
                            //                        PopupUtils.open(popoverWithFlickable, popoverRigthHELPER)
                            //                        fromPopoverOpen = false
                            //                        popoverListTO.isOpen = true
                        }
                    }


                }
            ]




            Component {
                id: cursorComponent
                Rectangle {
                    id: cursorRectangle
                    width: units.gu(0.2)
                    color: "darkgray"
                    //                Component.onCompleted: animation1.start()
                    SequentialAnimation {
                        id: animation1
                        running: blinkingCursor === true ? true : false
                        loops: Animation.Infinite
                        PauseAnimation { duration: 500 }
                        ColorAnimation { target: cursorRectangle; property: "color"; from: "darkgray"; to: "transparent"; duration: 100 }
                        PauseAnimation { duration: 500 }
                        ColorAnimation { target: cursorRectangle; property: "color"; from: "transparent"; to: "darkgray"; duration: 100 }
                    }
                }
            }


            // Text area FROM Translate base item
            Rectangle {
                id: textAreaBase
                property bool isFocused: false

                width: parent.width
                height: isFocused == false ? units.gu(15) : (translateTextArea.lineCount > 1 ? units.gu(16) : units.gu(10))

                Behavior on height {
                    NumberAnimation {

                    }
                }


                TextArea {
                    id: translateTextArea
                    //                    width: parent.width - units.gu(4)
                    height: parent.height - units.gu(2)
//                    height: (currentLanguageCodeUsed.contents.from === "--" || currentLanguageCodeUsed.contents.to === "--" ) ? 0 : parent.height - units.gu(2)
                    //                    anchors
//                    text: "rower"
                    anchors {
                        verticalCenter: parent.verticalCenter;
                        left: parent.left;
                        leftMargin: units.gu(2);
                        right: textAreaClearButton.left;
                        rightMargin: units.gu(1)
                    }
                    placeholderText: "<font color='gray'>Touch to type</font>"
                    font.family: "Helvetica"
                    inputMethodHints: Qt.ImhNoPredictiveText
                    font.pixelSize: units.gu(4)
                    style: TextAreaStyle {} // TextArea styling only available in components 1.2
                    wrapMode: Text.WrapAnywhere
                    onCursorVisibleChanged: {
                        if(cursorVisible){ placeholderText = ""; textAreaBase.isFocused = true} else { placeholderText = "<font color='gray'>Touch to type</font>"; textAreaBase.isFocused = false }
                    }
                    cursorDelegate: cursorComponent
                    onLengthChanged: {
                        if(length > 0) {
                            textAreaClearButton.isvisible = true
                            translateButton.isvisible = true
                        } else {
                            textAreaClearButton.isvisible = false
                            translateButton.isvisible = false
                        }
                    }


                    onTextChanged: {
                        if(text.length == 0){
                            translatedXmlMODEL.source = ""
                            translationAndSuggestionPane.state = "history"
                        } else {
                            translationAndSuggestionPane.state = "suggestion"
                            //                            print("=====> "+currentLanguageCodeUsed.contents.from)
                            //                            suggestionsXmlMODEL.source = "http://suggestqueries.google.com/complete/search?output=toolbar&hl="+currentLanguageCodeUsed.contents.from+"&q="+translateTextArea.text
                        }
                    }

                    onSelectedTextChanged: {
                        // below to stop cursor blinking when text selected
                        if(selectedText.length == 0) {
                            blinkingCursor = true
                        } else {
                            blinkingCursor = false
                        }
                    }
                }



                // clear text area button
                Icon {
                    id: textAreaClearButton
                    property bool isvisible: false
                    width: isvisible == false ? 0 : translationAndSuggestionPane.state == "visible" ? units.gu(3) : units.gu(2)
                    height: width
                    color: "black"
                    name: "close"
                    //                        opacity: 0
                    anchors {
                        right: parent.right
                        rightMargin: units.gu(8)
                        top: parent.top
                        topMargin: units.gu(1.5)
                    }
                    Behavior on width {
                        PropertyAnimation {duration: 350; easing.type: Easing.InOutBack}
                    }


                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: units.gu(-2) // add finger sensitivity ;)
                        // styling on pressed
                        onPressed: parent.color = "gray"
                        onReleased: parent.color = "black"
                        onClicked: {
                            translateTextArea.text = ""
                        }
                    }

                }

                // Translate button (right arrow)
                Rectangle {
                    id: translateButton
                    property bool isvisible: false
                    width: isvisible == false ? 0 : units.gu(5)
                    height: width
                    radius: width/2
                    color: backgroundColor
                    anchors {
                        right: parent.right
                        rightMargin: units.gu(1)
                        bottom: parent.bottom
                        bottomMargin: units.gu(1)
                    }

                    Behavior on width {
                        PropertyAnimation {duration: 350; easing.type: Easing.InOutBack}
                    }


                    Icon {
                        width: parent.width - units.gu(2)
                        height: width
                        color: "white"
                        name: "next"
                        anchors.centerIn: parent

                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: units.gu(-2) // add finger sensitivity ;)
                        // styling on pressed
                        onPressed: parent.color = "lightgray"
                        onReleased: parent.color = backgroundColor
                        visible: parent.width == 0 ? false : true
                        onClicked: {
                            translationAndSuggestionPane.state = "waiting"
                            serachDelay.start()
//                            Utils.translate_phrase(translateTextArea.text, currentLanguageCodeUsed.contents.from, currentLanguageCodeUsed.contents.to)
                            //                            translatedXmlMODEL.source = ""
                            //                            Utils.translate_string(translateTextArea.text, currentLanguageUsed.contents.from, currentLanguageUsed.contents.to)
                        }
                    }

                }
            }

            Column {
                id: deviderColumn
                width: parent.width
                anchors.top: textAreaBase.bottom
                ListItem.ThinDivider {height: units.gu(0.2)}

                Item {
                    height: units.gu(0.4)
                    width: parent.width
                }
            }


            Item {
                id: translationAndSuggestionPane
                width: parent.width
                height: translatedAreaBase.height
                anchors.top: deviderColumn.bottom
                state: "history"
                clip: true

                states: [
                    State {
                        name: "hiden"
                        PropertyChanges {
                            target: translatedAreaBase
                            x: root.width
                        }
                        PropertyChanges {
                            target: translationAndSuggestionPane
                            height: 0
                        }
                    },
                    State {
                        name: "visible"
                        PropertyChanges {
                            target: translatedAreaBase
                            x: units.gu(1)
                        }
                        PropertyChanges {
                            target: textTranslated
                            focus: true
                        }
                    },
                    State {
                        name: "waiting"
                        PropertyChanges {
                            target: waitingAnimation
                            running: true
                        }
                    },
                    State {
                        name: "suggestion"
                        PropertyChanges {
                            target: suggestionsAreaBase
                            x: units.gu(1)
                        }
                    },
                    State {
                        name: "history"
                        PropertyChanges {
                            target: translationHistoryBase
                            x: units.gu(0)

                        }
                        PropertyChanges {
                            target: translationAndSuggestionPane
                            height: root.height - textAreaBase.height

                        }
                    }

                ]

                Component {
                    id: suggestionsDelegat
                    Rectangle {
                        id: rootSug
                        width: lableSug.width
                        height: lableSug.height
                        color: mouseArea.pressed == true ? "lightgray" : "transparent"
                        onActiveFocusChanged: print(activeFocus)
                        Label {
                            id: lableSug
                            text: suggestion.replace(translateTextArea.text.toLowerCase(), ("<b>"+translateTextArea.text.toLowerCase()+"</b>"))
                            color: "black"
                            fontSize: "large"
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            onClicked: {
                                translateTextArea.text = suggestion
                                translateTextArea.cursorPosition = translateTextArea.length // move cursor to the end of the string in textarea
//                                translationAndSuggestionPane.state = "waiting"
//                                serachDelay.start()
                            }

                        }

                    }
                }

                Rectangle {
                    id: suggestionsAreaBase
                    property bool isvisible: false
                    color: "white"
                    width: parent.width - units.gu(2)
                    height: suggestionsXmlMODEL.count == 0 ? 0 : (suggestionsListView.height > units.gu(12) ? units.gu(12) : suggestionsListView.height + units.gu(4))
                    x: -root.width
                    clip: true
                    Behavior on x {
                        PropertyAnimation {duration: 550; easing.type: Easing.InOutBack}
                    }
                    Behavior on height {
                        NumberAnimation {duration: 500; easing.type: Easing.InOutBack}
                    }

                    Flickable {
                        id: suggestionsFlickable
                        width: parent.width - units.gu(4)
                        height: parent.height - units.gu(3)
                        anchors.top: parent.top
                        anchors.topMargin: units.gu(1.5)
                        anchors.horizontalCenter: parent.horizontalCenter
                        contentHeight: suggestionsListView.height + units.gu(1)
                        Flow {
                            id: suggestionsListView
                            width: parent.width
                            spacing: units.gu(1.5)

                            Repeater {
                                model: suggestionsXmlMODEL
                                delegate: suggestionsDelegat
                                //                            delegate: Label {
                                //                                text: suggestion
                                //                                color: "black"
                                //                                fontSize: "large"
                                //                            }

                            }

                        }
                    }

                    Scrollbar {
                        flickableItem: suggestionsFlickable
                        align: Qt.AlignTrailing
                    }


                    //                    ListView {
                    //                        id: suggestionsListView
                    //                        anchors.fill: parent
                    //                        anchors.margins: units.gu(1)
                    //                        clip: true
                    ////                        width: parent.width - units.gu(2)
                    ////                        height: parent.height - untis.g
                    ////                        anchors.horizontalCenter: parent.horizontalCenter
                    //                        model: suggestionsXmlMODEL
                    //                        delegate: Label {
                    //                            text: suggestion
                    //                            color: "black"
                    //                        }
                    //                    }

                }


                Rectangle {
                    id: translatedAreaBase
                    property bool isvisible: false
                    color: "white"
                    width: parent.width - units.gu(2)
//                    height: mainTranslatedColumn.height + units.gu(3)
                    height: mainTranslatedColumn.height > (root.height - textAreaBase.height) ? (root.height - textAreaBase.height - units.gu(1.5)) : mainTranslatedColumn.height + units.gu(3)
                    state: "hiden"
                    x: root.width
                    MouseArea {
                        anchors.fill: parent
                        onClicked: translateTextArea.focus = false
                    }

                    Behavior on x {
                        PropertyAnimation {duration: 550; easing.type: Easing.InOutBack}
                    }

                    Behavior on height {
                        NumberAnimation {duration: 500; easing.type: Easing.InOutBack}
                    }

                    SequentialAnimation {
                        id: waitingAnimation
                        loops: Animation.Infinite
                        NumberAnimation { target: translatedAreaBase; property: "x"; to: (translatedAreaBase.width + units.gu(1)); duration: 700; easing.type: Easing.InOutBack }
                        PauseAnimation { duration: 50 }
                        NumberAnimation { target: translatedAreaBase; property: "x"; to: root.width; duration: 700; easing.type: Easing.InOutBack }
                    }

                    Flickable {
                        width: parent.width
                        height: parent.height
                        contentHeight: mainTranslatedColumn.height + units.gu(3)

                        Item {
                            anchors.fill: parent
                            anchors.margins: units.gu(1.5)

                            Column {
                                id: mainTranslatedColumn
                                width: parent.width
                                //                        anchors.horizontalCenter: parent.horizontalCenter

                                // item to holds bottom icons in translated pane
                                Item {
                                    width: parent.width
                                    height: units.gu(4)

                                    // lable to holds language TO
                                    Label {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: currentLanguageUsed.contents.to
                                        color: "gray"
                                    }

                                    Rectangle {
                                        height: units.gu(4)
                                        width: height
                                        anchors.right: parent.right
                                        color: mouseAreaFavoriteButton.pressed == true ? backgroundColor : "white"

                                        Icon {
                                            id: iconFavorite
                                            anchors.fill: parent
                                            anchors.margins: units.gu(0.5)
                                            name: u1dbControler._checkInFavorites(0) === 1 ? "starred" : "non-starred"
                                            color: mouseAreaFavoriteButton.pressed == true ? "white" : "grey"
                                        }
                                        MouseArea {
                                            id: mouseAreaFavoriteButton
                                            anchors.fill: parent
    //                                        onPressed: {parent.color = backgroundColor; iconCopy.color = "white"}
    //                                        onReleased: {parent.color = "white"; iconCopy.color = "gray"}
                                            onClicked: {
                                                if(iconFavorite.name === "starred"){
                                                    u1dbControler._removeFromFavorites(0)
                                                    iconFavorite.name = "non-starred"
                                                } else {
                                                    u1dbControler._addToFavorites(0)
                                                    iconFavorite.name = "starred"
                                                }
                                            }

                                        }
                                    }

                                }

                                Text {
                                    id: textTranslated
                                    width: parent.width
                                    wrapMode: Text.Wrap
                                    font.pixelSize: units.gu(3)
                                    text: translatedString
                                    //                            readOnly: true
                                    //                            selectByMouse: true
                                    //                            textFormat: Text.StyledText
                                }


                                // item to holds bottom icons in translated pane
                                // COPY TEXT
                                Item {
                                    width: parent.width
                                    height: units.gu(5)

                                    Label {
                                        width: parent.width - translatedTextToolbar.width
                                        height: parent.height
                                        text: "<a href='http://translate.yandex.com/'>Powered by Yandex.Translate</a>"
                                        fontSize: "x-small"
                                        clip: true
                                        wrapMode: Text.Wrap
                                        color: "gray"
                                        verticalAlignment: Text.AlignBottom
                                        onLinkActivated: {
                                            Qt.openUrlExternally("http://translate.yandex.com/")
                                        }
                                    }

                                    Rectangle {
                                        id: translatedTextToolbar
                                        height: units.gu(4)
                                        width: translatedTextToolbarRow.width
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom

                                        Row {
                                            id: translatedTextToolbarRow
                                            height: parent.height
                                            spacing: units.gu(1)
    //                                        anchors.margins: units.gu(0.5)

                                            Icon {
                                                id: iconFullScreen
                                                width: parent.height - units.gu(1)
                                                height: width
    //                                            anchors.fill: parent
                                                name: "view-fullscreen"
                                                color: iconFullScreenMA.pressed === true ? "lightgray" : "gray"
                                                MouseArea {
                                                    id: iconFullScreenMA
                                                    anchors.fill: parent
    //                                                onPressed: {parent.color = backgroundColor; iconCopy.color = "white"}
    //                                                onReleased: {parent.color = "white"; iconCopy.color = "gray"}
                                                    onClicked: mainPageStack.push(Qt.resolvedUrl("ui/FullScreenPage.qml"), {textToDisplay: translatedString})

                                                }
                                            }

                                            Icon {
                                                id: iconCopy
                                                width: parent.height - units.gu(1)
                                                height: width
    //                                            anchors.fill: parent
                                                name: "edit-copy"
                                                color: iconCopyMA.pressed === true ? "lightgray" : "gray"
                                                MouseArea {
                                                    id: iconCopyMA
                                                    anchors.fill: parent
    //                                                onPressed: {parent.color = backgroundColor; iconCopy.color = "white"}
    //                                                onReleased: {parent.color = "white"; iconCopy.color = "gray"}
                                                    onClicked: Clipboard.push(translatedString)

                                                }
                                            }

                                        }

                                    }



                                }
                            }


                        }
                    }




                }


                // Translation history Base item
                Rectangle {
                    id: translationHistoryBase
                    width: parent.width - units.gu(0)
    //                anchors.horizontalCenter: parent.horizontalCenter
                    height: translationHistoryListView.contentHeight > parent.height ? parent.height - units.gu(1) : translationHistoryListView.contentHeight + units.gu(2)
                    x: -root.height
                    color: "white"

                    Behavior on x {
                        PropertyAnimation {duration: 550; easing.type: Easing.InOutBack}
                    }

                    Behavior on height {
                        NumberAnimation {duration: 400; easing.type: Easing.InSine}
                    }

                    clip: true
                    ListView {
                        id: translationHistoryListView
                        width: parent.width - units.gu(0)
                        height: parent.height - units.gu(1)
                        interactive: translationHistoryListView.contentHeight > translationAndSuggestionPane.height ? true : false
                        anchors {
                            top: parent.top;
                            topMargin: units.gu(1);
                            horizontalCenter: parent.horizontalCenter;
                        }
                        header: Text {
                            width: parent.width - units.gu(4)
                            anchors.horizontalCenter: parent.horizontalCenter
                            wrapMode: Text.Wrap
                            visible: translationHistoryModel.count > 0 ? false : true
                            height: visible ? contentHeight : 0
                            text: "<b>What's new</b>:<p><p>Welcome to Translator app for Ubuntu Touch!<p><p>This is beta version, bugs and errors are expected ;)<p>Please report any problems via About page (top right corner)"
                        }

                        model: translationHistoryModel
                        delegate: ListItem.Subtitled {
                            removable: true
                            text: '<font color="black"><i>'+from_lang+": </i><b>"+from_phrase+'</font>'
                            subText: '<font color="gray"><i>'+to_lang+": <b>" +to_phrase+'</font>'
                            showDivider: index+1 === translationHistoryListView.count ? false : true
                            onItemRemoved: u1dbControler._removeFromTranslationHistory(from_phrase, to_phrase)
    //                        __contentsMargins
                            onClicked: {
                                set_language_from(from_lang, from_code)
                                set_language_to(to_lang, to_code)
                                translateTextArea.text = from_phrase
                                translatedString = to_phrase
                                translationAndSuggestionPane.state = "visible"
//                                print("INDEX: "+index)
//                                serachDelay.start()
                            }

                            Rectangle {
                                width: units.gu(4)
                                height: parent.height - units.gu(0.5)
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                Icon {
                                    id: iconStart
                                    width: units.gu(3)
                                    anchors.centerIn: parent
                                    name: is_starred == 1 ? "starred" : "non-starred"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
    //                                    u1dbControler._addToFavorites(from_lang,from_code,from_phrase,to_lang,to_code,to_phrase)
                                        if(iconStart.name === "starred"){
                                            u1dbControler._removeFromFavorites(index)
                                        } else {
                                            u1dbControler._addToFavorites(index)
                                        }
                                    }
                                }

                            }


    //                        iconName: "starred"
    //                        iconFrame: false
    //                        progression: true
                        }
                    }

                }

            }











            // Item to grab close list (one of below) if user clic outside the list
            Item {
                id: popoversMain
                anchors.fill: parent
                Rectangle {
                    id: popoverShader
                    anchors.fill: parent
                    color: "black"
                    opacity: 0
                    Behavior on opacity {
                        PropertyAnimation {duration: 450; easing.type: Easing.InOutBack}
                    }

                }

                MouseArea {
                    id: popoverMouseArea
                    anchors.fill: parent
                    visible: false
                    onClicked: {
                        popoversMain.state = ""
                    }
                }

                states: [
                    State {
                        name: "showFromList"
                        PropertyChanges {
                            target: popoverListFROM
                            width: parent.width / 2 - units.gu(3)
                        }
                        PropertyChanges {
                            target: popoverShader
                            opacity: 0.3
                        }
                        PropertyChanges {
                            target: popoverMouseArea
                            visible: true
                        }
                    },
                    State {
                        name: "showToList"
                        PropertyChanges {
                            target: popoverListTO
                            width: parent.width / 2 - units.gu(3)
                        }
                        PropertyChanges {
                            target: popoverShader
                            opacity: 0.3
                        }
                        PropertyChanges {
                            target: popoverMouseArea
                            visible: true
                        }
                    },
                    State {
                        name: "showHederMenu"
                        PropertyChanges {
                            target: popoverHeaderMenu
                            y: 0
                        }
                        PropertyChanges {
                            target: popoverShader
                            opacity: 0.3
                        }
                        PropertyChanges {
                            target: popoverMouseArea
                            visible: true
                        }
                    }
                ]

                // left popover which holds list of languages FROM
                PopoverFromLanguage {
                    id: popoverListFROM
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: 0
                    height: parent.height
                }

                // right popover which holds list of languages TO
                PopoverToLanguage {
                    id: popoverListTO
                    anchors.right: parent.right
                    anchors.top: parent.top
    //                width: isOpen == true ? parent.width / 2 - units.gu(3) : 0
                    width: 0
                    height: parent.height

                }

                // Header menu popover
                PopoverHeaderMenu {
                    id: popoverHeaderMenu
                    anchors.right: parent.right
                    width: units.gu(16)
                    height: mainColumntHeight
    //                y: isOpen ? 0 : -height
                    y: -height -units.gu(2)

                    onClick: popoversMain.state = ""
                }

            }





        }
    }









}

