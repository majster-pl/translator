/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 * modified by Szymon Waliczek <majsterrr@gmail.com>
 */

import QtQuick 2.0
import "jsonpath.js" as JSONPath
import "base64.js" as BASE64

Item {
    property string source: ""
    property string json: ""
    property string query: ""
    property int status: 0 // 0 = Loading/OK, 1 = Error, 2 = ready

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count

    onModelChanged: updateJSONModel()

    onStatusChanged: if(status == 0) { loadingTimer.start() }

    Timer {
        id: loadingTimer
        interval: 8000;
        repeat: false
        onTriggered: {
//            print("error loading list...")
            status = 1
        }

    }

    onSourceChanged: {
        status = 0
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source, true, "User-Agent", "XBMC Addon Radio");
//        xhr.setRequestHeader("User-Agent", "XBMC Addon Radio")
//        xhr.setRequestHeader('X-Alt-Referer', 'http://www.google.com');
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    function reloadJSONModel() {
        status = 0
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source, true);
        xhr.setRequestHeader('User-Agent', 'XBMC Addon Radio')
//        xhr.setRequestHeader("Authorization", "XBMC Addon Radio");
//        xhr.setRequestHeader("Authorization", "Basic " + Base64.encode('User-Agent' + ":" + 'XBMC Addon Radio'));
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();

    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();

        if ( json === "" ) {
            return;
        } else if ( json === "" && source !== "") {
            status = 1
            return;
        }

        var objectArray = parseJSONString(json, query);
        for ( var key in objectArray ) {
            var jo = objectArray[key];
            jsonModel.append( jo );
//            print(jo)
        }
        status = 2
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);
        if ( jsonPathQuery !== "" )
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);

        return objectArray;
    }

    Component.onCompleted: updateJSONModel();
}
