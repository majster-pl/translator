import QtQuick 2.3
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem

// rectangle to hold lsit with languages
Rectangle {
    id: popoverListTO
    property bool isOpen: false
    width: parent.width
    height: parent.height
    color: "#6279ab"
    clip: true

    Behavior on width {
        PropertyAnimation {duration: 450; easing.type: Easing.InOutBack}
    }

    onWidthChanged: if(width == 0){languagesListViewFROM.positionViewAtBeginning()}

//    onIsOpenChanged: {
//        if(isOpen) {
//            languagesListViewFROM.positionViewAtBeginning()
//        }
//    }

    ListView {
        id: languagesListViewFROM
        width: parent.width
        height: parent.height
        clip: true
        cacheBuffer: contentHeight // this makes better scrooling performance but slower creating component
        model: xmlCountryList
        header: ListView {
            width: parent.width
            //                    height: recentlyUsedLangsModel.count * units.gu(4)
            height: recentlyUsedLangsModel.count == 0 ? 0 : (recentlyUsedLangsModel.count * units.gu(4) + units.gu(1))
            interactive: false
            model: recentlyUsedLangsModel
            delegate: ListItem.Standard {
                height: units.gu(4)
                text: country_name
                //                        style:
                onClicked: {
                    //                            u1dbControler._addToRecentlyUsedLangs(country_name, country_code);
                    //                            set_language_from(country_name, country_code)
                    var tempCode = country_code
                    var tempName = country_name
                    u1dbControler._addToRecentlyUsedLangs(tempName, tempCode);
                    set_language_from(tempName, tempCode)

//                    popoverListFROM.isOpen = false
                    popoversMain.state = ""
                }
            }
            footer: ListItem.Divider {visible: recentlyUsedLangsModel.count == 0 ? false : true}
            //                    Component.onCompleted: height = contentHeight
        }

        //                headerPositioning: ListView.PullBackHeader // available in QtQuick 2.4
        delegate: ListItem.Standard {
            text: i18n.tr(country_name)
            height: units.gu(4)
            onClicked: {
                u1dbControler._addToRecentlyUsedLangs(country_name, country_code)
                set_language_from(country_name, country_code)
                popoversMain.state = ""
//                popoverListFROM.isOpen = false
//                                        if (fromPopoverOpen) { set_language_from(country_name, country_code) } else { set_language_to(country_name, country_code) }
                //                        PopupUtils.close(popover)
            }
        }

    }
    Scrollbar {
        flickableItem: languagesListViewFROM
        align: Qt.AlignTrailing
    }

}
