# -*- coding: utf-8 -*-

# Copyright 2014 Matt Austin

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


from __future__ import absolute_import, unicode_literals
from gaussian import NewsBlur, Feed


def set_client(username, password):
    global client
    client = NewsBlur(username=username, password=password)

def get_feeds():
    return [f._data for f in client.get_feeds()]

def get_stories(feed_data, read_filter='unread'):
    feed_id = feed_data['id']
    return [s._data for s in Feed(feed_id, client, data=feed_data).get_stories(read_filter=read_filter)]
