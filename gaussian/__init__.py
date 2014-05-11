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
from .feeds import Feed
import logging
import requests


__title__ = 'gaussian'
__version__ = '0.1.0'
__url__ = 'https://github.com/mattaustin/gaussian'
__author__ = 'Matt Austin <mail@mattaustin.me.uk>'
__copyright__ = 'Copyright 2014 Matt Austin'
__license__ = 'Apache 2.0'


class NewsBlur(object):
    """NewsBlur API client.

    http://www.newsblur.com/api

    """

    _user_agent = '{name}/{version} ({name}; +{url})'.format(
        name=__title__, version=__version__, url=__url__)

    endpoint = 'https://www.newsblur.com/'
    logged_in = False

    def __init__(self, endpoint=None, username=None, password=None):
        """

        :param str endpoint: API endpoint URL. Defaults to 'www.newsblur.com'.
            Specify this if you have your own NewsBlur server.
        :param str username: Your NewsBlur account username.
        :param str password: Your NewsBlur account password.

        """

        self._logger = self._get_logger()

        self._set_endpoint(endpoint)
        self.username = username
        self.password = password

        self.session = self._create_session()

        if self.username and self.password:
            self.login()

    def __repr__(self):
        username = self.username.encode('utf-8') if self.username else b''
        return b'<{0}: {1}>'.format(self.__class__.__name__, username)

    def _get_logger(self):
        return logging.getLogger(__name__)

    def _create_session(self):
        session = requests.Session()
        session.headers = {'Accept': 'application/json',
                           'User-Agent': self._user_agent}
        return session

    def _set_endpoint(self, endpoint):
        self.endpoint = endpoint or self.endpoint
        self._logger.debug('API endpoint set to: {0}'.format(self.endpoint))

    def _construct_url(self, path):
        return '{endpoint}{path}'.format(endpoint=self.endpoint, path=path)

    def get_feeds(self, refresh=False):
        """Get the feeds for this account.

        :param bool refresh: If True, any cached data is ignored and data is
          fetched from the API. Default: False.

        :returns: List of :py:class:`~gaussian.feeds.Feed` instances.
        :rtype: list

        """

        if not hasattr(self, '_feeds') or refresh:
            response = self.session.get(self._construct_url('/reader/feeds'))
            # TODO: properly check for success, it appears server always
            # returns 200.
            assert response.json()['result'] == 'ok'
            items = response.json()['feeds'].items()
            self._feeds = [
                Feed(id=id, api_client=self, data=data) for id, data in items]

        return self._feeds

    def login(self):
        """Login to NewsBlur, using session (cookie) authentication."""

        response = self.session.post(self._construct_url('/api/login'),
                                     data={'username': self.username,
                                           'password': self.password})
        # TODO: properly check for success, it appears server always returns
        # 200.
        self._logger.debug(response.content)
        assert response.json()['result'] == 'ok'
        self.logged_in = True
        return True

    def logout(self):
        """Logout of NewsBlur."""

        response = self.session.post(self._construct_url('/api/logout'))
        # TODO: properly check for success, it appears server always returns
        # 200.
        self._logger.debug(response.content)
        assert response.json()['result'] == 'ok'
        self.logged_in = False
        return True

    def mark_as_read(self, days=0):
        """Mark all stories from all feeds as read.

        :param int days: Number of days back to mark as read. Default: 0 (all).

        """

        response = self.session.post(
            self._construct_url('/reader/mark_all_as_read'),
            data={'days': days})
        return response.json()['result'] == 'ok'

    def mark_stories_as_read(self, stories):
        """Mark provided stories as read.

        :param list stories: List of :py:class:`~gaussian.stories.Story`
            instances.

        """

        response = self.session.post(
            self._construct_url('/reader/mark_story_hashes_as_read'),
            data={'story_hash': [story.hash for story in stories]})
        return response.json()['result'] == 'ok'
