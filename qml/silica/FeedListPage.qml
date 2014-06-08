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

    id: feedListPage
    property alias model: feedList.model

    BusyIndicator {
        anchors.centerIn: parent
        running: client.busy
    }

    SilicaListView {

        id: feedList

        property bool showUnread: false

        visible: !client.busy
        anchors.fill: parent

        header: PageHeader {
            title: 'Gaussian'
        }

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: 'Log out'
                onClicked: {logout()}
                enabled: !client.busy && client.logged_in
            }
            MenuItem {
                text: feedList.showUnread ? 'Show unread feeds' : 'Show all feeds'
                onClicked: {feedList.showUnread = !feedList.showUnread;}
                enabled: !client.busy && client.logged_in
            }
        }

        delegate: BackgroundItem {

            id: item
            width: parent.width
            height: visible ? Theme.itemSizeSmall : 0

            visible: !modelData.exception_code && (feedList.showUnread || modelData.nt)

            Label {
                text: modelData.feed_title
                color: item.down ? Theme.highlightColor : Theme.primaryColor
                truncationMode: TruncationMode.Fade
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.paddingLarge
            }

            onClicked: {
                storyListPage.model = null;
                storyListPage.feed = modelData;
                client.getStories(modelData, feedList.showUnread);
                pageStack.push(storyListPage);
            }

        }

        VerticalScrollDecorator {}

    }

    function logout() {
        client.logout();
        pageStack.clear();
        pageStack.push(loginPage);
    }

}
