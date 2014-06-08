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

    id: storyListPage
    property var feed
    property alias model: storyList.model

    BusyIndicator {
        anchors.centerIn: parent
        running: client.busy
    }

    SilicaListView {

        id: storyList
        anchors.fill: parent

        header: PageHeader {
            title: feed ? feed.feed_title : 'Feed'
        }

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: 'Copy feed url'
                onClicked: {Clipboard.text = storyListPage.feed.feed_address;}
            }
            MenuItem {
                text: 'Copy website url'
                onClicked: {Clipboard.text = storyListPage.feed.feed_link;}
            }
            MenuItem {
                text: 'Open website'
                onClicked: {Qt.openUrlExternally(storyListPage.feed.feed_link);}
            }
        }

        delegate: BackgroundItem {

            id: item
            width: storyList.width
            implicitHeight: Theme.itemSizeMedium

            Item {

                x: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 2*Theme.paddingLarge
                height: childrenRect.height

                Label {
                    id: title
                    text: modelData.story_title
                    color: item.down ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                    truncationMode: TruncationMode.Fade
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }

                Label {
                    text: modelData.short_parsed_date
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                    truncationMode: TruncationMode.Fade
                    anchors {
                        top: title.bottom
                        left: parent.left
                        right: parent.right
                    }
                }

            }

            onClicked: {
                storyPage.story = modelData;
                pageStack.push(storyPage);
            }

        }

        VerticalScrollDecorator {}

    }

}
