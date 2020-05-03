/*
 * Copyright (C) 2013 Szymon Waliczek.
 *
 * Authors:
 *  Szymon Waliczek <majsterrr@gmail.com>
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
 */

import QtQuick 2.0
//import U1db 1.0 as U1db
//import Ubuntu.Components 0.1
//import Ubuntu.Components.ListItems 0.1 as ListItem


ListModel {
    id: root

    property var recent_languages_list: []
    property var translation_history: []

    Component.onCompleted: _load()

    //Loading translation history and last 5 used languages
    function _load() {
        // loading translation history
        if(translationHistoryDoc.contents.history) {
            translation_history = JSON.parse(translationHistoryDoc.contents.history)
            translationHistoryModel.append(translation_history)
//            print("U1db: "+translation_history)
        } else {
            print("U1db: Translation history is empty.")
        }

        // loading recently used 5 Languages
        if(recentLangHistoryDoc.contents.history) {
            recent_languages_list = JSON.parse(recentLangHistoryDoc.contents.history)
            recentlyUsedLangsModel.append(recent_languages_list)
        } else {
            print("U1db: No recently used Languages found.")
        }

    }


    ////////////////////////////////////////////////////////////////////////////////////
    /// Translation History:

    // reload translation history model
    function _reloadTranslationHistory() {
        translationHistoryModel.clear()
        if(translationHistoryDoc.contents.history) {
            translation_history = JSON.parse(translationHistoryDoc.contents.history)
            translationHistoryModel.append(translation_history)
        }
    }

    // Adding new translation to the list
    function _addToTranslationHistory(fromLang, fromCode, fromPhrase, toLang, toCode, toPhrase, isStarred) {
        print("adding phrase to history")
        var isInHistory = false
        for (var key in translation_history) {
//            print(translation_history[key]["from_phrase"])
//            print(translation_history[key]["to_phrase"])
            if(translation_history[key]["from_phrase"].toLowerCase() === fromPhrase.toLowerCase() &&
                    translation_history[key]["to_phrase"].toLowerCase() === toPhrase.toLowerCase()) {
//                var temp_isStarred = translation_history[key].is_starred
//                print("KEY: " + key)
//                print("in starred :" + translation_history[key].is_starred)
//                if(translation_history[key].is_starred === 1)
                var tempIsStarred = translation_history[key].is_starred
                translation_history.splice(key, 1)
                translation_history.unshift({"from_lang": fromLang, "from_code": fromCode, "from_phrase": fromPhrase, "to_lang": toLang, "to_code": toCode, "to_phrase": toPhrase, "is_starred": tempIsStarred})
                isInHistory = true
            }
        }
        // if not is history allready then append to the front of the list
        if(!isInHistory) {
            translation_history.unshift({"from_lang": fromLang, "from_code": fromCode, "from_phrase": fromPhrase, "to_lang": toLang, "to_code": toCode, "to_phrase": toPhrase, "is_starred": 0})
        }
//        // remove last item in the list if limit exided...
//        if(recent_languages_list.length > 5) {
//            recent_languages_list.pop()
//        }
        _saveTranslationHistory()
    }


    // Remove entry from the List
    function _removeFromTranslationHistory(fromPhrase,toPhrase){
        for (var key in translation_history) {
            if(translation_history[key]["from_phrase"].toLowerCase() === fromPhrase.toLowerCase() &&
                    translation_history[key]["to_phrase"].toLowerCase() === toPhrase.toLowerCase()) {
//                print(translation_history[key]["from_phrase"])
//                print(translation_history[key]["to_phrase"])
                translation_history.splice(key, 1)
            }
        }
        _saveTranslationHistory()
    }

    // clear translate history
    function _clearTranslateHitory() {
        translation_history = []
        _saveTranslationHistory()
    }


    // add to favorites
    function _addToFavorites(indexNo){
        translation_history[indexNo].is_starred = 1
        _saveTranslationHistory()
    }

    // remove from favorites
    function _removeFromFavorites(indexNo){
        translation_history[indexNo].is_starred = 0
        _saveTranslationHistory()
    }

    // check if it favorites
    function _checkInFavorites(indexNo){
//        print(translation_history[indexNo].is_starred)
        if(translation_history[indexNo] === undefined) {
            return 0
        } else {
            return translation_history[indexNo].is_starred
        }

    }


    function _saveTranslationHistory() {
        var tempMainList = {}
        tempMainList = translationHistoryDoc.contents
        tempMainList.history = JSON.stringify(translation_history)
        translationHistoryDoc.contents = tempMainList
        _reloadTranslationHistory()
    }





    ////////////////////////////////////////////////////////////////////////////////////
    /// Recent Languages used History:
    ///

    // reload recently used 5 languages.
    function _reloadRecentlyUsedHistory() {
        recentlyUsedLangsModel.clear()
        if(recentLangHistoryDoc.contents.history) {
            recent_languages_list = JSON.parse(recentLangHistoryDoc.contents.history)
            recentlyUsedLangsModel.append(recent_languages_list)
        }
    }


    // Adding new item to the list
    function _addToRecentlyUsedLangs(searchName, searchCode) {
        var isInHistory = false
        for (var key in recent_languages_list) {
            if(recent_languages_list[key]["country_name"].toLowerCase() === searchName.toLowerCase()) {
//                print(recent_languages_list[key]["country_name"])
//                print(recent_languages_list[key]["country_code"])
                recent_languages_list.splice(key, 1)
                recent_languages_list.unshift({"country_name": searchName, "country_code": searchCode})
                isInHistory = true
//                recentlyUsedLangsModel.append({"name" : recent_languages_list[key]["name"]})
            }

        }
        if(!isInHistory) {
            recent_languages_list.unshift({"country_name": searchName, "country_code": searchCode})
        }

        if(recent_languages_list.length > 5) {
            recent_languages_list.pop()
        }

        saveMainList()
    }






    // clear history
    function _clearRecentLangsHistory() {
        recent_languages_list = []
        saveMainList()
    }




    ////////////////////////////////////////////////////////////////////////////////////
    /// Radio History:


    // reload ListModel
    function reloadRadioHistory() {
        radioHistoryModel.clear()
        if(radioHistoryDoc.contents.history) {
            recent_translation_list = JSON.parse(radioHistoryDoc.contents.history)
            radioHistoryModel.append(recent_translation_list)
        }
    }


    // Adding new item to the list
    function addRadioToHistory(radio_ID) {

//        recent_translation_list.unshift({"radioNameHistory": historyMetaData.name, "genreTextHistory": historyMetaData.genre, "iconSourceHistory": historyMetaData.icon,
//                                   "radioBitrateHistory": historyMetaData.bitRate, "radioIDHistory": historyMetaData.radioId, "ratingValueHistory": historyMetaData.rating
//                                   })

        var isInHistory = false
        for (var key in recent_translation_list) {
//            print("toooo: " + recent_translation_list[key]["radioIDHistory"])
//            print("eee: " + radio_ID)
            if(recent_translation_list[key]["radioIDHistory"] === radio_ID) {
                recent_translation_list.splice(key, 1)
                recent_translation_list.unshift({"radioNameHistory": historyMetaData.name, "genreTextHistory": historyMetaData.genre, "iconSourceHistory": historyMetaData.icon,
                                           "radioBitrateHistory": historyMetaData.bitRate, "radioIDHistory": historyMetaData.radioId, "ratingValueHistory": historyMetaData.rating
                                           })
//                recent_translation_list.unshift({"radioID": radioID})
                isInHistory = true
            }

        }
        if(!isInHistory) {
            recent_translation_list.unshift({"radioNameHistory": historyMetaData.name, "genreTextHistory": historyMetaData.genre, "iconSourceHistory": historyMetaData.icon,
                                       "radioBitrateHistory": historyMetaData.bitRate, "radioIDHistory": historyMetaData.radioId, "ratingValueHistory": historyMetaData.rating
                                       })
        }

//        if(recent_translation_list.length > 8) {
//            recent_translation_list.pop()
//        }

        saveRadioHistory()
    }







    //////////////////////////////////////
    /// General functions:

    function saveMainList() {
        var tempMainList = {}
        tempMainList = recentLangHistoryDoc.contents
//        print("++++++++++++++++++++++++")
//        print(tempMainList.history)
//        print("++++++++++++++++++++++++")
//        print(tempMainList)
        tempMainList.history = JSON.stringify(recent_languages_list)
        recentLangHistoryDoc.contents = tempMainList
        _reloadRecentlyUsedHistory()
//        mainShopListModel.clear()
//        mainShopListModel.loadMainList()
//        print("Total Lists: " + mainShopListModel.count)
    }



    function saveRadioHistory() {
        var tempMainList = {}
        tempMainList = radioHistoryDoc.contents
//        print("++++++++++++++++++++++++")
//        print(tempMainList.history)
//        print("++++++++++++++++++++++++")
//        print(tempMainList)
        tempMainList.history = JSON.stringify(recent_translation_list)
        radioHistoryDoc.contents = tempMainList
        reloadRadioHistory()
//        mainShopListModel.clear()
//        mainShopListModel.loadMainList()
//        print("Total Lists: " + mainShopListModel.count)
    }




    //reloading Main list.
    function reloadMainList() {
        mainShopListModel.clear()
        mainShopListModel.append(main_list)
    }


    // Adding new List to mainShopListModel
    function addMainList(list_name) {
        main_list.push({"name": list_name, "lista": []})
        mainShopListModel.clear()
        mainShopListModel.append(main_list)
        saveMainList()
    }

    function addMainListChecker(new_list_name) {
        for (var i = 0; i < mainShopListModel.count; i++) {
            var list_name_tmp = mainShopListModel.get(i).name
            if (list_name_tmp === new_list_name) {
                return false;
            }
        }
        return true;
    }

    function leanght() {
        return main_list.length
    }

    function removeMainList(index) {
        var list_name = mainShopListModel.get(index).name
        print("removeing list...  " + list_name)
        var list = main_list
        list.splice(index, 1)
        main_list = list
        saveMainList()
    }

    function _isEmpty(){
        if(main_list.length != 0){
            return 0
        } else {
            return -1
        }
    }





    function loadMainList() {
        main_list = JSON.parse(mainShopListDB.contents.mainList)
        mainShopListModel.append(main_list)
    }


    function renameMainList(index, new_list_name) {
        var temp = main_list[index]
        main_list[index] = {"name": new_list_name, "lista": main_list[index]["lista"]}
        saveMainList()
    }


    function loadList(index) {
        var lista = main_list
        var test = (lista[index]["lista"])
        userShopListModel.append(test)

    }

    //    function test(index){
    //        var lista = main_list


    ////        var list = main_list
    ////        list.splice(index, 1)

    //        var lol = lista[index]["lista"]
    //        lol.splice(0,1)
    //        print(lol.length)
    ////        lista[index]["lista"] = ["aa1","bb1","cc1"]
    //        saveMainList()
    //    }


}


