import QtQuick 2.3
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 1.0 as ListItem

// rectangle to hold lsit with languages
Rectangle {
    id: popoverListTO
    width: parent.width
    height: parent.height
    color: "#6279ab"
    clip: true

    Behavior on width {
        PropertyAnimation {duration: 450; easing.type: Easing.InOutBack}
    }
    onWidthChanged: if(width == 0){languagesListViewTO.positionViewAtBeginning()}


    ListView {
        id: languagesListViewTO
        width: parent.width
        height: parent.height
        clip: true
        cacheBuffer: contentHeight // this makes better scrooling performance but slower creating component
        model: xmlCountryList
        header: ListView {
            width: parent.width
            height: recentlyUsedLangsModel.count == 0 ? 0 : (recentlyUsedLangsModel.count * units.gu(4) + units.gu(1))
            interactive: false
            model: recentlyUsedLangsModel
            delegate: ListItem.Standard {
                height: units.gu(4)
                text: country_name
                onClicked: {
                    var tempCode = country_code
                    var tempName = country_name
                    u1dbControler._addToRecentlyUsedLangs(tempName, tempCode);
                    set_language_to(tempName, tempCode)
                    popoversMain.state = ""
                }
            }
            footer: ListItem.Divider {visible: recentlyUsedLangsModel.count == 0 ? false : true}
        }

        delegate: ListItem.Standard {
            text: i18n.tr(country_name)
            height: units.gu(4)
            onClicked: {
                u1dbControler._addToRecentlyUsedLangs(country_name, country_code)
                set_language_to(country_name, country_code)
                popoversMain.state = ""
            }
        }

    }
    Scrollbar {
        flickableItem: languagesListViewTO
        align: Qt.AlignTrailing
    }



}
