/*
 * Copyright (C) 2014 Szymon Waliczek.
 *
 * Authors:
 *  Szymon Waliczek <majsterrr@gmail.com>
 *
 * This file is part of rad.io application for Ubuntu Touch.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * README:
 * If you wish to change indicator colours, you have to edit "starred.svg" and "non-starred.svg"
 * in your favorite svg editor eg. Inkscape ( I did implement ColorOverlay component from QtGraphicalEffects 1.0
 * but this makes this component very slow, so to improve porformance this solution is better )
 */

import QtQuick 2.3
import Ubuntu.Components 1.2


Item {
    id: root
//    width: untis.gu(5)
    height: rootColumn.height
    property string iconSource
    property alias appName: radioName.text

    // signals
    signal click


    Column {
        id: rootColumn
        width: parent.width
        opacity: iconka.status == Image.Ready ? 1 : 0
        Behavior on opacity {
            PropertyAnimation {duration: 450; easing.type: Easing.InOutBack}
        }

        UbuntuShape {
            width: parent.width
            height: width
            radius: "medium"
            image: Image {
                id: iconka
                source: iconSource

            }
        }
//        Image {
//            id: radioThumb
//            width: parent.width
//            height: width
//        }

        Label {
            id: radioName
            width: parent.width
            wrapMode: Text.Wrap
            fontSize: "x-small"
            color: "#444444"
            maximumLineCount: 3
            horizontalAlignment: Text.Center
        }


    }

    MouseArea {
        anchors.fill: parent
        onClicked: click()
    }
}


