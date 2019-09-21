# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
BACKPORTS="03f44039848bd09444ff4baa8dc158bd61454079"
MY_P=${P%_p*}

inherit python-single-r1 readme.gentoo-r1

DESCRIPTION="Official WMythTV plugins"
HOMEPAGE="https://www.mythtv.org"
# mythtv and mythplugins are separate builds in the same github MythTV/mythtv repository
SRC_URI="https://github.com/MythTV/mythtv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

MYTHPLUGINS="mytharchive +mythbrowser +mythgallery mythgame \
mythmusic +mythnetvision +mythnews +mythweather mythzmserver mythzoneminder"
IUSE="${MYTHPLUGINS} alsa cdda cdr exif fftw +hls ieee1394 libass +opengl raw +theora +vorbis +xml xvid"

DEPEND="
	${PYTHON_DEPS}
	dev-libs/glib:2
	dev-libs/openssl:0=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	media-libs/freetype:2
	media-libs/libpng:0=
	sys-apps/util-linux
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXv
	x11-libs/libXxf86vm
	alsa? ( >=media-libs/alsa-lib-1.0.24 )
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
	=media-tv/mythtv-${PV}*[alsa?,cdda?,cdr?,exif?,fftw?,ieee1394?,libass?,opengl?,python,raw?,xml?,xvid]
	mytharchive? (
		app-cdr/dvd+rw-tools
		dev-python/pillow[${PYTHON_USEDEP}]
		media-video/dvdauthor
		media-video/mjpegtools[png]
		media-video/transcode
		virtual/cdrtools
	)
	mythbrowser? ( dev-qt/qtwebkit:5 )
	mythgallery? (
		media-libs/tiff:0
		opengl? ( virtual/opengl:= )
		exif? ( >media-libs/libexif-0.6.9:= )
		raw? ( media-gfx/dcraw )
	)
	mythgame? ( sys-libs/zlib[minizip] )
	mythmusic? (
		>=media-libs/flac-1.1.2
		media-libs/libogg
		>=media-libs/libvorbis-1.0
		>=media-libs/taglib-1.6
		>=media-sound/lame-3.93.1
		fftw? ( sci-libs/fftw:3.0= )
		opengl? ( virtual/opengl )
		cdda? (
			dev-libs/libcdio:=
			cdr? ( virtual/cdrtools )
		)
	)
	mythnetvision? (
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/mysql-python[${PYTHON_USEDEP}]
		dev-python/oauth[${PYTHON_USEDEP}]
	)
	mythweather? (
		dev-perl/Date-Manip
		dev-perl/XML-Simple
		dev-perl/XML-XPath
		dev-perl/DateTime
		dev-perl/Image-Size
		dev-perl/DateTime-Format-ISO8601
		dev-perl/SOAP-Lite
		dev-perl/JSON
	)
	mythzmserver? ( dev-db/mysql-connector-c:0/18 )
	theora? ( media-libs/libtheora )
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
	!media-plugins/mythzmserver
	!media-plugins/mythzoneminder
"
REQUIRED_USE="
	mythmusic? ( vorbis )
	mythnetvision? ( ${PYTHON_REQUIRED_USE} )
	mythnews? ( mythbrowser )
"

# mythtv and mythplugins are separate builds in the same github MythTV/mythtv repository
S="${WORKDIR}/mythtv-${PV}/mythplugins"

DOC_CONTENTS="
Common plugins are installed by default. Disable unneeded plugins individually with USE flags:
-mythbrowser -mythgallery -mythmusic -mythnetvision -mythnews -mythweather
Additional plugins may be installed with USE flags mytharchive mythgame mythzmserver mythzoneminder
"

src_prepare() {
	default
}

src_configure() {
	econf \
		--python=${EPYTHON} \
		--extra-ldflags="${LDFLAGS}" \
		$(use_enable cdda cdio) \
		$(use_enable exif) \
		$(use_enable exif new-exif) \
		$(use_enable fftw) \
		$(use_enable opengl) \
		$(use_enable raw dcraw) \
		$(use_enable mytharchive) \
		$(use_enable mythbrowser) \
		$(use_enable mythgallery) \
		$(use_enable mythgame) \
		$(use_enable mythmusic) \
		$(use_enable mythnetvision) \
		$(use_enable mythnews) \
		$(use_enable mythweather) \
		$(use_enable mythzmserver) \
		$(use_enable mythzoneminder)
}

src_install() {
	emake STRIP="true" INSTALL_ROOT="${D}" install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
