TagPy is a set of Python bindings for Scott Wheeler's 
`TagLib <http://developer.kde.org/~wheeler/taglib.html>`_. 
It builds upon `Boost.Python <http://www.boost.org/libs/python/doc/>`_, 
a wrapper generation library which is part of the renowned Boost 
set of C++ libraries.

Just like TagLib, TagPy can:

* read and write ID3 tags of version 1 and 2, with many supported frame types
  for version 2 (in MPEG Layer 2 and MPEG Layer 3, FLAC and MPC),
* access Xiph Comments in Ogg Vorbis Files and Ogg Flac Files,
* access APE tags in Musepack and MP3 files.

All these features have their own specific interfaces, but 
TagLib's generic tag reading and writing mechanism is also 
supported. It comes with a bunch of examples.