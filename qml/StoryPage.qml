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

    id: storyPage
    title: story ? story.story_title : 'Story'
    visible: false
    property var story

    ActivityIndicator {
        anchors.centerIn: parent
        running: client.busy
    }

    Flickable {
        anchors.fill: parent
        contentHeight: edit.paintedHeight //edit.contentHeight//childrenRect.height

        TextEdit {
            id: edit
            anchors.fill: parent
            anchors.margins: units.gu(2)
            text: story ? story.story_content : ''
            textFormat: TextEdit.AutoText //TextEdit.RichText
            activeFocusOnPress: false
            clip: true
            cursorVisible: false
            focus: false
            readOnly: true
            selectByMouse: false
            wrapMode: TextEdit.Wrap
            onLinkActivated: {Qt.openUrlExternally(link);}
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
                    text: 'Open in web browser'
                    onTriggered: {Qt.openUrlExternally(storyPage.story.story_permalink);}
                }
                Action {
                    text: 'Copy url'
                    onTriggered: {Clipboard.push(storyPage.story.story_permalink);}
                }
                //Action {
                //    text: 'Email'
                //    onTriggered: {}
                //}
            }
        }
    }

    tools: ToolbarItems {

        ToolbarButton {
            id: readStatusButton
            visible: !client.busy && storyPage.story
            iconSource: storyPage.story.read_status ? Qt.resolvedUrl('image://theme/torch-off') : Qt.resolvedUrl('image://theme/torch-on')
            text: storyPage.story.read_status ? 'Mark unread' : 'Mark read'
            onTriggered: {
                var status = storyPage.story.read_status ? false : true;
                client.toggleStoryReadStatus(storyPage.story, status, function() {
                    storyPage.story.read_status = status;
                    storyPage.story = storyPage.story;
                });
            }
        }

        ToolbarButton {
            id: linkButton
            visible: storyPage.story.story_permalink ? true : false
            iconSource: Qt.resolvedUrl('image://theme/external-link')
            text: 'Link'
            onTriggered: PopupUtils.open(linkSelectionPopover, linkButton)
        }

    }

}
