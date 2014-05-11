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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem


Page {

    id: feedListPage
    title: 'Gaussian'
    visible: false
    property alias model: feedList.model

    ActivityIndicator {
        anchors.centerIn: parent
        running: client.busy
    }

    ListView {

        id: feedList

        property bool showUnread: false

        visible: !client.busy
        anchors.fill: parent

        delegate: ListItem.Standard {
            width: parent.width
            height: visible ? undefined : 0
            visible: feedList.showUnread || modelData.nt
            text: modelData.feed_title
            iconSource: modelData.favicon_color ? modelData.favicon_url : 'https://www.newsblur.com' + modelData.favicon_url
            fallbackIconSource: Qt.resolvedUrl('image://theme/go-to')
            onClicked: {
                print(JSON.stringify(modelData));
                storyListPage.model = null;
                storyListPage.feed = modelData;
                client.getStories(modelData);
                pageStack.push(storyListPage);
            }
        }

        Scrollbar {
            flickableItem: parent
        }

    }

    tools: ToolbarItems {
        ToolbarButton {
            visible: !client.busy && client.logged_in
            action: Action {
                text: feedList.showUnread ? 'Unread' : 'All'
                iconSource: Qt.resolvedUrl('image://theme/filter')
                onTriggered: {feedList.showUnread = !feedList.showUnread;}
            }
        }
        ToolbarButton {
	    visible: !client.busy && client.logged_in
            action: Action {
                text: 'Log out'
                iconSource: Qt.resolvedUrl('image://theme/system-log-out')
                onTriggered: {logout()}
            }
        }
    }

    function logout() {
        client.logout();
        pageStack.push(loginPage);
    }

}
