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
import Ubuntu.Components.Popups 0.1


Page {

    id: storyListPage
    title: feed ? feed.feed_title : 'Feed'
    visible: false
    property var feed
    property alias model: storyList.model

    ActivityIndicator {
        anchors.centerIn: parent
        running: client.busy
    }

    ListView {

        id: storyList
        anchors.fill: parent

        delegate: ListItem.Subtitled {
            width: parent.width
            text: modelData.story_title
            subText: modelData.short_parsed_date
            onClicked: {
                storyPage.story = modelData;
                pageStack.push(storyPage);
            }
        }

        Scrollbar {
            flickableItem: parent
        }

    }

    Component {
        id: linkSelectionPopover
        ActionSelectionPopover {
            actions: ActionList {
                Action {
                    text: 'Open website'
                    onTriggered: {Qt.openUrlExternally(storyListPage.feed.feed_link);}
                }
                Action {
                    text: 'Copy website url'
                    onTriggered: {Clipboard.push(storyListPage.feed.feed_link);}
                }
                Action {
                    text: 'Copy feed url'
                    onTriggered: {Clipboard.push(storyListPage.feed.feed_address);}
                }
            }
        }
    }

    tools: ToolbarItems {
        ToolbarButton {
            id: linkButton
            visible: storyListPage.feed.feed_link ? true : false
            iconSource: Qt.resolvedUrl('image://theme/external-link')
            text: 'Link'
            onTriggered: PopupUtils.open(linkSelectionPopover, linkButton)
        }
    }

}
