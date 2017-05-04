# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,threads"

inherit autotools eutils python-single-r1 games

DESCRIPTION="full featured educational application for children from 2 to 10"
HOMEPAGE="http://gcompris.net/"
SRC_URI="http://gcompris.net/download/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="gstreamer"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="x11-libs/gtk+:2
	gnome-base/librsvg[gtk(+)]
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-good:0.10
		media-plugins/gst-plugins-ogg:0.10
		media-plugins/gst-plugins-alsa:0.10
		media-plugins/gst-plugins-vorbis:0.10 )
	!gstreamer? (
		media-libs/sdl-mixer
		media-libs/libsdl:0 )
	dev-libs/libxml2
	dev-libs/popt
	virtual/libintl
	dev-db/sqlite:3
	dev-python/pygtk[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	dev-perl/XML-Parser
	sys-devel/gettext
	sys-apps/texinfo
	app-text/texi2html
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	media-gfx/tuxpaint
	sci-electronics/gnucap"

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	# Drop DEPRECATED flags, bug #387817
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		src/gcompris/Makefile.am || die

	epatch "${FILESDIR}"/${P}-build.patch
	cp /usr/share/gettext/config.rpath .
	eautoreconf
	sed -i \
		-e 's#^itlocaledir =.*$#itlocaledir = @localedir@#' \
		po/Makefile.in.in || die

	# Fix desktop files
	sed -i \
		-e '/Encoding/d' \
		gcompris.desktop.in \
		gcompris-edit.desktop.in || die
}

src_configure() {
	GNUCHESS="${GAMES_BINDIR}/gcompris-gnuchess" \
	egamesconf \
		--datarootdir="${GAMES_DATADIR}" \
		--datadir="${GAMES_DATADIR}" \
		--localedir=/usr/share/locale \
		--infodir=/usr/share/info \
		--with-python="${PYTHON}" \
		$(use_enable !gstreamer sdlmixer) \
		--enable-sqlite \
		--enable-py-build-only
}

src_install() {
	default
	prune_libtool_files --modules
	prepgamesdirs
}
