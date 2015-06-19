KEY_NONEXISTING = 'nonexisting-key'
KEY_ALBUM = 'album'
KEY_ARTIST = 'artist'
KEY_AUTHOR = 'author'
KEY_BITRATE = 'bitrate'
KEY_CERTIFICATE = 'certificate'
KEY_CHILDCOUNT = 'childcount'
KEY_DATE = 'date'
KEY_DESCRIPTION = 'description'
KEY_DURATION = 'duration'
KEY_EXTERNAL_PLAYER = 'external-player'
KEY_EXTERNAL_URL = 'external-url'
KEY_FRAMERATE = 'framerate'
KEY_GENRE = 'genre'
KEY_HEIGHT = 'height'
KEY_ID = 'id'
KEY_LAST_PLAYED = 'last-played'
KEY_LAST_POSITION = 'last-position'
KEY_LICENSE = 'license'
KEY_LYRICS = 'lyrics'
KEY_MIME = 'mime'
KEY_PLAY_COUNT = 'play-count'
KEY_RATING = 'rating'
KEY_SITE = 'site'
KEY_SOURCE = 'source'
KEY_STUDIO = 'studio'
KEY_THUMBNAIL = 'thumbnail'
KEY_TITLE = 'title'
KEY_URL = 'url'
KEY_WIDTH = 'width'

REGISTERED_KEYS = [KEY_ALBUM, KEY_ARTIST, KEY_AUTHOR, KEY_BITRATE,
                   KEY_CERTIFICATE, KEY_CHILDCOUNT, KEY_DATE,
                   KEY_DESCRIPTION, KEY_DURATION, KEY_EXTERNAL_PLAYER,
                   KEY_EXTERNAL_URL, KEY_FRAMERATE, KEY_GENRE, KEY_HEIGHT,
                   KEY_ID, KEY_LAST_PLAYED, KEY_LAST_POSITION, KEY_LICENSE,
                   KEY_LYRICS, KEY_MIME, KEY_PLAY_COUNT, KEY_RATING,
                   KEY_SITE, KEY_SOURCE, KEY_STUDIO, KEY_THUMBNAIL,
                   KEY_TITLE, KEY_URL, KEY_WIDTH]

SUPPORTED_OPS = []
try:
    from gi.repository import Grl
    SUPPORTED_OPS = [Grl.SupportedOps.NONE, Grl.SupportedOps.METADATA,
                     Grl.SupportedOps.RESOLVE, Grl.SupportedOps.BROWSE,
                     Grl.SupportedOps.SEARCH, Grl.SupportedOps.QUERY,
                     Grl.SupportedOps.STORE, Grl.SupportedOps.STORE_PARENT,
                     Grl.SupportedOps.REMOVE, Grl.SupportedOps.SET_METADATA]
except:
    pass
