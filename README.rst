========
gaussian
========

A Python NewsBlur API client.


In development. Initially aiming to cover basic functionality to allow fetching
of unread stories and marking them as read.


Example
=======

.. code-block:: python

    import gaussian

    newsblur = gaussian.NewsBlur(username='username', password='password')

    newsblur.get_feeds()
    # [<Feed: Planet Python>]

    feed = newsblur.get_feeds()[0]

    feed.get_stories()
    # [<Story: Catalin George Festila: Parsing feeds - get by attribute and value - part 2>,
    #  <Story: PyCharm: PyCharm 3.1.1 and Python plugin for IntelliJ IDEA 13 have been released>,
    #  <Story: Mike Driscoll: eBook Review: Learning scikit-learn: Machine Learning in Python>,
    #  <Story: Mike C. Fletcher: PyOpenGL Working on the Raspberry Pi>,
    #  <Story: Zato Blog: Secure, scalable and dynamic invocation of SOAP services with Zato and Suds>,
    #  <Story: Mike Driscoll: Python 101: How to Change a Dict Into a Class>]

    story = feed.get_stories()[0]

    story.content
    # u'....'

    story.mark_as_read()

    feed.mark_as_read()
