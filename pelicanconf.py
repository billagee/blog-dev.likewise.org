AUTHOR = 'Bill Agee'
SITENAME = "Bill Agee's blog"
SITESUBTITLE = "🏗️ Reflections on test infrastructure, with a twist of user empathy.🤝"
SITEURL = ""

THEME="/Users/billagee/github/duilio/pelican-octopress-theme"

PATH = "content"

# Title menu options
MENUITEMS = [('Blog', '/'),
             ('Archives', '/archives.html')]
NEWEST_FIRST_ARCHIVES = True

TIMEZONE = 'America/Los_Angeles'

DEFAULT_LANG = 'en'

# Set the article URL
ARTICLE_URL = '{date:%Y}/{date:%m}/{slug}/'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{slug}/index.html'

# Don't categories on main navigation menu
DISPLAY_CATEGORIES_ON_MENU = False

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
#LINKS = (
#    ("Pelican", "https://getpelican.com/"),
#    ("Python.org", "https://www.python.org/"),
#    ("Jinja2", "https://palletsprojects.com/p/jinja/"),
#    ("You can modify those links in your config file", "#"),
#)

# Social widget
#SOCIAL = (
#    ("You can add links in your config file", "#"),
#    ("Another social link", "#"),
#)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True

TWITTER_USER = 'billdescribe'
#TWITTER_WIDGET_ID =.
TWITTER_TWEET_BUTTON = True
TWITTER_FOLLOW_BUTTON = True
TWITTER_TWEET_COUNT = 3
TWITTER_SHOW_REPLIES = False
TWITTER_SHOW_FOLLOWER_COUNT = False

GITHUB_USER = 'billagee'
GITHUB_REPO_COUNT = 3
GITHUB_SKIP_FORK = True
GITHUB_SHOW_USER_LINK = True

#SIDEBAR_IMAGE = "images/moderntimes.gif"
#SIDEBAR_IMAGE = "images/lucy.png"
SIDEBAR_IMAGE_ALT = "Sidebar image"
#SIDEBAR_IMAGE_WIDTH = Width of sidebar image
SEARCH_BOX = False

DISQUS_SITENAME = "billagee-blog"
GOOGLE_ANALYTICS = "UA-30353441-1"
