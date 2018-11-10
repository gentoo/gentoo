# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
BACKPORTS="03f44039848bd09444ff4baa8dc158bd61454079"
MY_P=${P%_p*}

inherit eutils python-single-r1 vcs-snapshot

DESCRIPTION="Official MythTV plugins"
HOMEPAGE="https://www.mythtv.org"
SRC_URI="https://github.com/MythTV/mythtv/archive/${BACKPORTS}.tar.gz -> mythtv-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

MYTHPLUGINS="+mytharchive +mythbrowser +mythgallery +mythgame \
+mythmusic +mythnetvision +mythnews +mythweather +mythzoneminder"
IUSE="${MYTHPLUGINS} alsa cdda cdr exif fftw +hls ieee1394 libass raw +theora +vorbis +xml xvid"

DEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	media-libs/freetype:2
	media-libs/libpng:0=
	~media-tv/mythtv-${PV}:=[alsa=,hls=,ieee1394=,libass=,python,theora=,vorbis=,xml=,xvid=]
	sys-apps/util-linux
	sys-libs/zlib
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXv
	x11-libs/libXxf86vm
	alsa? ( >=media-libs/alsa-lib-1.0.24 )
	fftw? ( sci-libs/fftw:3.0= )
	hls? (
		media-libs/faac
		media-libs/libvpx:=
		>=media-libs/x264-0.0.20111220:=
		>=media-sound/lame-3.93.1
	)
	ieee1394? (
		>=media-libs/libiec61883-1.0.0
		>=sys-libs/libavc1394-0.5.3
		>=sys-libs/libraw1394-1.2.0
	)
	libass? ( >=media-libs/libass-0.9.11:= )
	mytharchive? (
		app-cdr/dvd+rw-tools
		dev-python/pillow
		media-video/dvdauthor
		media-video/mjpegtools[png]
		media-video/transcode
		virtual/cdrtools
	)
	mythbrowser? ( dev-qt/qtwebkit:5 )
	mythgallery? (
		media-libs/tiff:0
		virtual/opengl
		exif? ( >media-libs/libexif-0.6.9:= )
		raw? ( media-gfx/dcraw )
	)
	mythmusic? (
		>=media-libs/flac-1.1.2
		media-libs/libogg
		>=media-libs/libvorbis-1.0
		>=media-libs/taglib-1.6
		>=media-sound/lame-3.93.1
		virtual/opengl
		cdda? (
			dev-libs/libcdio:=
			cdr? ( virtual/cdrtools )
		)
	)
	mythnetvision? (
		${PYTHON_DEPS}
		dev-python/lxml
		dev-python/mysql-python
		dev-python/oauth
		dev-python/pycurl
	)
	mythweather? (
		dev-perl/Date-Manip
		dev-perl/DateTime
		dev-perl/DateTime-Format-ISO8601
		dev-perl/Image-Size
		dev-perl/JSON
		dev-perl/SOAP-Lite
		dev-perl/XML-Parser
		dev-perl/XML-SAX
		dev-perl/XML-Simple
		dev-perl/XML-XPath
	)
	mythzoneminder? ( virtual/mysql )
	theora? (
		media-libs/libogg
		media-libs/libtheora
	)
	xml? ( >=dev-libs/libxml2-2.6.0:= )
	xvid? ( >=media-libs/xvid-1.1.0 )
"
RDEPEND="${DEPEND}
	!media-plugins/mytharchive
	!media-plugins/mythbrowser
	!media-plugins/mythgallery
	!media-plugins/mythgame
	!media-plugins/mythmovies
	!media-plugins/mythmusic
	!media-plugins/mythnetvision
	!media-plugins/mythnews
	!media-plugins/mythweather
"
REQUIRED_USE="
	cdda? ( mythmusic )
	cdr? ( mythmusic cdda )
	exif? ( mythgallery )
	fftw? ( mythmusic )
	mythmusic? ( vorbis )
	mythnetvision? ( ${PYTHON_REQUIRED_USE} )
	mythnews? ( mythbrowser )
	raw? ( mythgallery )
"

S="${WORKDIR}/mythtv-${PV}/mythplugins"

src_prepare() {
	default
	sed -i '1i#define OF(x) x' mythgame/mythgame/external/ioapi.h
}

src_configure() {
	econf \
		--prefix=/usr \
		--python=${EPYTHON} \
		--enable-opengl \
		$(use_enable cdda cdio) \
		$(use_enable exif) \
		$(use_enable exif new-exif) \
		$(use_enable raw dcraw) \
		$(use_enable mytharchive) \
		$(use_enable mythbrowser) \
		$(use_enable mythgallery) \
		$(use_enable mythgame) \
		$(use_enable mythmusic) \
		$(use_enable mythnetvision) \
		$(use_enable mythnews) \
		$(use_enable mythweather) \
		$(use_enable mythzoneminder)
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "make install failed"
}
