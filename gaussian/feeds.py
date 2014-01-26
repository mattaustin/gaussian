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
from .stories import Story


class Feed(object):
    """A NewsBlur feed."""

    def __init__(self, id, api_client, data=None):
        """

        :param str id: The NewsBlur feed ID.
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

    def get_stories(self, order='oldest', read_filter='unread',
                    include_story_content=True):
        """Get the stories for this feed.

        :returns: List of :py:class:`~gaussian.stories.Story` instances.
        :rtype: list

        """

        include_story_content = 'true' if include_story_content else 'false'
        url = self._api_client._construct_url(
            '/reader/feed/{id}'.format(id=self.id))
        response = self._api_client.session.get(
            url, params={'order': order, 'read_filter': read_filter,
                         'include_story_content': include_story_content})
        assert response.json()['result'] == 'ok'  # TODO
        return [Story(id=data['id'], api_client=self._api_client, data=data)
                for data in response.json()['stories']]

    def mark_as_read(self):
        """Mark all stories in this feed as read."""

        response = self._api_client.session.post(
            self._api_client._construct_url('/reader/mark_feed_as_read'),
            data={'feed_id': self.id})
        return response.json()['result'] == 'ok'

    @property
    def title(self):
        return self._data.get('feed_title', self.id)
