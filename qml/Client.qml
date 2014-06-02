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
import io.thp.pyotherside 1.2


Python {

    property bool busy: false
    property bool logged_in: false

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('..').substr('file://'.length));
    }

    onError: {
        console.log('python error: ' + traceback);
    }

    function login(username, password, callback) {
        importModule('gaussian.qmlexperiment', function() {
            busy = true;
            call('gaussian.qmlexperiment.set_client', [username, password], function() {
                logged_in = true;
                busy = false;
                typeof callback === 'function' && callback();
            });
        });
    }

    function logout() {
        importModule('gaussian.qmlexperiment', function() {
            busy = true;
            call('gaussian.qmlexperiment.client.logout', [], function() {
                logged_in = false;
                busy = false;
            });
        });
    }

    function getFeeds() {
        importModule('gaussian.qmlexperiment', function() {
            busy = true;
            call('gaussian.qmlexperiment.get_feeds', [], function(result) {
                feedListPage.model = result;
                busy = false;
            });
        });
    }

    function getStories(feedData, showUnread) {
      var readFilter = showUnread ? 'all' : 'unread'
      importModule('gaussian.qmlexperiment', function() {
            busy = true;
            call('gaussian.qmlexperiment.get_stories', [feedData, readFilter], function(result) {
                storyListPage.model = result;
                busy = false;
            });
        });
    }

    function toggleStoryReadStatus(storyData, readStatus, callback) {
      importModule('gaussian.qmlexperiment', function() {
            busy = true;
            call('gaussian.qmlexperiment.toggle_story_read_status', [storyData, readStatus], function(result) {
                busy = false;
                typeof callback === 'function' && callback();
            });
        });
    }

}
