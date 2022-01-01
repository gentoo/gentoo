# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-single-r1 readme.gentoo-r1

# Grab only the major version number.
MAJOR_PV=$(ver_cut 1)

MY_COMMIT="5824c588db24b4e71a7d94e829e6419f71089297"

DESCRIPTION="Official MythTV plugins"
HOMEPAGE="https://www.mythtv.org https://github.com/MythTV/mythtv"
if [[ $(ver_cut 3) == "p" ]] ; then
	SRC_URI="https://github.com/MythTV/mythtv/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	# mythtv and mythplugins are separate builds in the same github MythTV/mythtv repository
	S="${WORKDIR}/mythtv-${MY_COMMIT}/mythplugins"
else
	SRC_URI="https://github.com/MythTV/mythtv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	# mythtv and mythplugins are separate builds in the same github MythTV/mythtv repository
	SRC_URI="https://github.com/MythTV/mythtv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/mythtv-${PV}/mythplugins"
fi
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

MYTHPLUGINS="mytharchive mythgame mythnetvision \
mythweather mythzmserver mythzoneminder"
IUSE="${MYTHPLUGINS} alsa cdda cdr exif fftw +hls ieee1394 libass +opengl raw +theora +vorbis +xml xvid"

# Mythnetvision temporarily disabled by upstream - should be fixed soon.
REQUIRED_USE="
	!mythnetvision
	mytharchive? ( ${PYTHON_REQUIRED_USE} )
	mythnetvision? ( ${PYTHON_REQUIRED_USE} )
"
RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	media-libs/freetype:2
	media-libs/libpng:=
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXv
	x11-libs/libXxf86vm
	alsa? ( media-libs/alsa-lib )
	hls? (
		media-libs/faac
		media-libs/libvpx:=
		media-libs/x264:=
		media-sound/lame
	)
	ieee1394? (
		media-libs/libiec61883
		sys-libs/libavc1394
		sys-libs/libraw1394
	)
	libass? ( media-libs/libass:= )
	=media-tv/mythtv-${MAJOR_PV}*[alsa?,cdda?,cdr?,exif?,fftw?,ieee1394?,libass?,opengl?,raw?,xml?,xvid]
	mytharchive? (
		${PYTHON_DEPS}
		app-cdr/dvd+rw-tools
		dev-python/pillow
		dev-python/mysqlclient
		=media-tv/mythtv-${MAJOR_PV}*[python]
		media-video/dvdauthor
		media-video/mjpegtools[png]
		media-video/transcode
		app-cdr/cdrtools
	)
	mythgame? (
		sys-libs/zlib[minizip]
		dev-perl/XML-Twig
	)
	mythnetvision? (
		${PYTHON_DEPS}
		dev-python/lxml
		dev-python/pycurl
		dev-python/urllib3
		=media-tv/mythtv-${MAJOR_PV}*[python]
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
		=media-tv/mythtv-${MAJOR_PV}*[perl]
	)
	mythzmserver? ( dev-db/mysql-connector-c:= )
	theora? ( media-libs/libtheora )
	xml? ( dev-libs/libxml2:= )
	xvid? ( media-libs/xvid )
"
DEPEND=${RDEPEND}

DOC_CONTENTS="
Mythgallery code moved to mythtv and is no longer a plugin in version 31.0.
As of 3/23/2020, MythNetVision is disabled, work in progress.

No plugins are installed by default. Enable plugins individually with USE flags:
mytharchive mythgame mythnetvision mythweather mythzmserver mythzoneminder
"

src_configure() {
	econf \
		--python=${EPYTHON} \
		--extra-ldflags="${LDFLAGS}" \
		--disable-mythbrowser \
		$(use_enable cdda cdio) \
		$(use_enable exif) \
		$(use_enable exif new-exif) \
		$(use_enable fftw) \
		$(use_enable opengl) \
		$(use_enable raw dcraw) \
		$(use_enable mytharchive) \
		$(use_enable mythgame) \
		$(use_enable mythnetvision) \
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
