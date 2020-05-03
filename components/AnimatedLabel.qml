import QtQuick 2.3
import Ubuntu.Components 1.1

Label {

    property string newText

    animations: [
        FadeTransition {
            id: fadeOut
            fromOpacity: 1
            toOpacity: 0
            duration: 200
            onEnded: {
                fadeIn.play();
                parent.text = parent.newText;
            }
        },
        FadeTransition {
            id: fadeIn
            fromOpacity: 0
            toOpacity: 1
            duration: 200

        }
    ]
    function changeText(text)
    {
        newText = text;
        fadeOut.play();
    }
}
