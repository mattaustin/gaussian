// Copyright 2014 Matt Austin

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {

    id: loginPage

    BusyIndicator {
        anchors.centerIn: parent
        running: client.busy
    }

    Column {

        anchors.fill: parent
        visible: !client.busy && !client.logged_in

        PageHeader {
            title: 'Gaussian'
        }

        TextField {
            id: usernameField
            width: parent.width
            focus: true
            placeholderText: 'Username'
            KeyNavigation.tab: passwordField
            inputMethodHints: Qt.ImhPreferLowercase | Qt.ImhNoAutoUppercase | Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText
        }

        TextField {
            id: passwordField
            width: parent.width
            placeholderText: 'Password'
            echoMode: TextInput.Password
            KeyNavigation.backtab: usernameField
            Keys.onReturnPressed: {
                login();
            }
        }

        Button {
            text: 'Login'
            onClicked: {
                login();
            }
        }

    }

    function login() {
        client.login(usernameField.text, passwordField.text, function() {
            client.getFeeds();
            pageStack.clear();
            pageStack.push(feedListPage);
        });
    }

}
