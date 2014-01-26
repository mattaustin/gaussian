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


class Story(object):
    """A NewsBlur story."""

    def __init__(self, id, api_client, data=None):
        """

        :param str id: The story URL.
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
    def title(self):
        return self._data.get('story_title', self.id)
