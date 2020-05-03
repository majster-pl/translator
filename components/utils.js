// Szymon Waliczek 2015 majsterrr@gmail.com


// Yandex Kay:
var yandexKey = "trnsl.1.1.20150528T234856Z.d433d6c9d873d792.c584b5f1e42203e4e01b89f8e133867aa485827b"


// translate string using yandex
function translate_string(trans_string, lan_from, lan_to) {
    if(lan_from === 'cy' || lan_to === 'cy') {
        translate_phrase(trans_string, lan_from, lan_to)
    } else {
        translatedXmlMODEL.source = ""
        translatedXmlMODEL.source = "https://translate.yandex.net/api/v1.5/tr/translate?key=trnsl.1.1.20150528T234856Z.d433d6c9d873d792.c584b5f1e42203e4e01b89f8e133867aa485827b&lang="+lan_from+"-"+lan_to+"&text=" + trans_string.replace(/\n/g, '%3F&text=').replace(/ /g, '+')
    }

}



// testing for phrase translation
function translate_phrase(trans_phrase, lang_from, lang_to) {
//    print("KURWA IDZIE TO CHUJOWSTO!!!")
    var xhr = new XMLHttpRequest();
    var url = "https://glosbe.com/gapi/translate?from="+lang_from+"&dest="+lang_to+"&format=json&phrase="+trans_phrase.replace(" ", "%20")+"&pretty=true&tm=true"
    var translated = []
    xhr.open('GET', url, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status == 200) {
                var result = JSON.parse(xhr.responseText);
//                console.log(xhr.responseText);
//                console.log(url);
//                print(result['tuc'].length)
////                print(result['tuc'][0]['phrase'])
////                print(result['tuc'][6]['meanings'][0]['text'])
//                for(var i=0; i<result['tuc'].length; i++) {
//                    print(result['tuc'][i]['authors'])
//                    if(result['tuc'][i]['authors'].toString() == 1) {
//                        print(result['tuc'][i]['meanings'][0]['text'])
////                        print("jest kurwa!!")
//                    } else if(i === (result['tuc'].length-1)) {
//                        translate_string(trans_phrase, lang_from, lang_to)
//                    }
//                    print(i)
//                }




                for(var i=0; i<result['tuc'].length; i++) {
                    if(result['tuc'][i]['meanings'] !== undefined) {
//                        print(result['tuc'][i]['meanings'])
//                        print(result['tuc'][i]['meanings'].length)
                        for(var e=0; e<result['tuc'][i]['meanings'].length; e++){
                            if(result['tuc'][i]['meanings'][e]['language'] === lang_to) {
                                print(result['tuc'][i]['meanings'][e]['text'])
                                translated.push(result['tuc'][i]['meanings'][e]['text'])
                            }

                        }
                    } else if(result['tuc'][i]['phrase'] !== undefined) {
//                        print(result['tuc'][i]['phrase'])
//                        print(result['tuc'][i]['phrase'].length)
                        print(result['tuc'][i]['phrase']['authors'])
                        if(result['tuc'][i]['phrase']['language'] === lang_to) {
                            print(result['tuc'][i]['phrase']['text'])
                            translated.push(result['tuc'][i]['phrase']['text'])
                        }
//                        for(var f=0; f<result['tuc'][i]['phrase'].length; f++){
//                            print("KURWA MAC")
//                            print(result['tuc'][i]['phrase'][f]['text'])
//                        }

                    }

                }

            } else {
                print("Error!")
            }

            if(translated.length == 0) {
                translatedString = "<i>No translation, sorry</i>"
            } else {
                translatedString = translated.join(", ")
            }

        }
    }
    xhr.send();
}


//translate using xxx
function hasWhiteSpace(s) {
    print(s)
    return s.indexOf(' ') >= 0;
}
