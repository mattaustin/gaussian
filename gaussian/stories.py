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
from datetime import datetime


class Story(object):
    """A NewsBlur story."""

    def __init__(self, id, api_client, data=None):
        """

        :param str id: The story ID (URL).
        :param api_client: The associated NewsBlur API client instance.
        :type api_client: :py:class:`~gaussian.NewsBlur`
        :param dict data: Initial data (parsed json).

        """

        self.id = id
        self._api_client = api_client
        self._data = data or {}

    def __repr__(self):
        return b'<{0}: {1}>'.format(self.__class__.__name__, self)

    def __str__(self):
        return self.title.encode('utf-8')

    @property
    def content(self):
        return self._data.get('story_content', None)

    @property
    def datetime(self):
        date = self._data.get('story_date')
        return datetime.strptime(date, '%Y-%m-%d %H:%M:%S') if date else None

    @property
    def feed_id(self):
        return self._data.get('story_feed_id', None)

    @property
    def hash(self):
        return self._data.get('story_hash', None)

    @property
    def title(self):
        return self._data.get('story_title', self.id)

    def mark_as_read(self):
        """Mark story as read."""

        # TODO: NewsBlur requests that stories are maked as read in batches.
        return self._api_client.mark_stories_as_read([self])

    def mark_as_unread(self):
        """Mark story as unread."""

        response = self._api_client.session.post(
            self._api_client._construct_url('/reader/mark_story_as_unread'),
            data={'story_id': self.id, 'feed_id': self.feed_id})
        return response.json()['result'] == 'ok'
