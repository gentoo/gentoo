# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND="2:2.6"
BACKPORTS="9fd7c6102b2cd1a3760337663803b110446c6ea7"
MY_P=${P%_p*}

inherit eutils python

DESCRIPTION="Official MythTV plugins"
HOMEPAGE="http://www.mythtv.org"
SRC_URI="ftp://ftp.osuosl.org/pub/mythtv/${MY_P}.tar.bz2
	${BACKPORTS:+https://dev.gentoo.org/~rich0/distfiles/${MY_P}-${BACKPORTS}.tar.xz}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

MYTHPLUGINS="mytharchive mythbrowser mythgallery mythgame \
mythmusic mythnetvision mythnews mythweather mythzoneminder"

IUSE="${MYTHPLUGINS} cdda cdr exif fftw raw"

DEPEND="!media-plugins/mytharchive
	!media-plugins/mythbrowser
	!media-plugins/mythgallery
	!media-plugins/mythgame
	!media-plugins/mythmovies
	!media-plugins/mythmusic
	!media-plugins/mythnetvision
	!media-plugins/mythnews
	!media-plugins/mythweather
	=media-tv/mythtv-${PV}*:=[python]
	mytharchive? (
		app-cdr/dvd+rw-tools
		dev-python/pillow:=
		media-video/dvdauthor
		media-video/mjpegtools[png]
		media-video/transcode
		virtual/cdrtools
	)
	mythgallery? (
		media-libs/tiff:=
		virtual/opengl
		exif? ( >media-libs/libexif-0.6.9:= )
		raw? ( media-gfx/dcraw )
	)
	mythmusic? (
		>=media-libs/flac-1.1.2:=
		>=media-libs/libvorbis-1.0:=
		>=media-libs/taglib-1.6:=
		media-sound/lame
		virtual/opengl
		cdda? (
			dev-libs/libcdio:=
			cdr? ( virtual/cdrtools )
		)
		fftw? ( sci-libs/fftw:= )
	)
	mythnetvision? (
		=dev-lang/python-2*:=[xml]
		dev-python/lxml:=
		dev-python/mysql-python:=
		dev-python/oauth:=
		dev-python/pycurl:=
	)
	mythweather? (
		dev-perl/DateManip
		dev-perl/DateTime-Format-ISO8601
		dev-perl/Image-Size
		dev-perl/JSON
		dev-perl/SOAP-Lite
		dev-perl/XML-Simple
		dev-perl/XML-Parser
		dev-perl/XML-SAX
		dev-perl/XML-XPath
	)"
RDEPEND="${DEPEND}"

REQUIRED_USE="
	cdda? ( mythmusic )
	cdr? ( mythmusic cdda )
	exif? ( mythgallery )
	fftw? ( mythmusic )
	mythnews? ( mythbrowser )
	raw? ( mythgallery )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	[[ -n ${BACKPORTS} ]] && \
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${S}/patches" \
			epatch

	epatch_user
}

src_configure() {
	./configure \
		--prefix=/usr \
		--python=python2 \
		--enable-opengl \
		$(use_enable mythzoneminder) \
		$(use_enable mytharchive) \
		$(use_enable mythbrowser) \
		$(use_enable mythgallery) \
		$(use_enable mythgame) \
		$(use_enable mythmusic) \
		$(use_enable mythnetvision) \
		$(use_enable mythnews) \
		$(use_enable mythweather) \
		$(use_enable cdda cdio) \
		$(use_enable exif) \
		$(use_enable exif new-exif) \
		$(use_enable raw dcraw) \
		|| die "configure failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "make install failed"
}
