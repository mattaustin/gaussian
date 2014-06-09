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

    id: storyPage
    property var story

    BusyIndicator {
        anchors.centerIn: parent
        running: client.busy && !storyPage.story
    }

    SilicaFlickable {

        id: flickable
        anchors.fill: parent
        contentHeight:column.height

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: 'Copy url'
                onClicked: {Clipboard.text = storyPage.story.story_permalink;}
            }
            MenuItem {
                text: 'Open in web browser'
                onClicked: {Qt.openUrlExternally(storyPage.story.story_permalink);}
            }
            //MenuItem {
            //    text: 'Email'
            //    onClicked: {}
            //}
            MenuItem {
                text: storyPage.story.read_status ? 'Mark unread' : 'Mark read'
                onClicked: {
                    var status = storyPage.story.read_status ? false : true;
                    client.toggleStoryReadStatus(storyPage.story, status, function() {
                        storyPage.story.read_status = status;
                        storyPage.story = storyPage.story;
                    });
                }
                enabled: !client.busy && storyPage.story
            }
        }

        Column {

            id: column
            height: edit.paintedHeight + header.height  // edit.paintedHeight  //edit.contentHeight //childrenRect.height
            width: parent.width

            PageHeader {
                id: header
                title: story ? story.story_title : 'Story'
                wrapMode: Text.Wrap
                //horizontalAlignment: Text.AlignRight
                //maximumLineCount: 2
            }

            TextEdit {
                id: edit
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                }
                text: story ? story.story_content : ''
                textFormat: TextEdit.RichText  // TextEdit.AutoText
                activeFocusOnPress: false
                clip: true
                cursorVisible: false
                focus: false
                readOnly: true
                selectByMouse: false
                wrapMode: TextEdit.Wrap
                onLinkActivated: {Qt.openUrlExternally(link);}
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
            }

        }

        VerticalScrollDecorator {}

    }

    onStoryChanged: {
        flickable.scrollToTop();
    }


}
