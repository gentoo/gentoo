# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
WANT_CMAKE=always
inherit eutils python-any-r1 cmake-utils gnome2-utils

DESCRIPTION="Reimplementation of the Infinity engine"
HOMEPAGE="http://gemrb.sourceforge.net/"
SRC_URI="mirror://sourceforge/gemrb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/freetype
	media-libs/libpng:0
	>=media-libs/libsdl-1.2[video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-mixer
	sys-libs/zlib
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	sed -i \
		-e '/COPYING/d' \
		CMakeLists.txt || die
}

src_configure() {
	mycmakeargs=(
		-DBIN_DIR="/usr/bin"
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DDATA_DIR="/usr/share/gemrb"
		-DDOC_DIR="/usr/share/doc/${PF}"
		-DICON_DIR=/usr/share/pixmaps
		-DLIB_DIR="/usr/$(get_libdir)"
		-DMAN_DIR=/usr/share/man/man6
		-DMENU_DIR=/usr/share/applications
		-DSVG_DIR=/usr/share/icons/hicolor/scalable/apps
		-DSYSCONF_DIR="/etc/${PN}"
		)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	DOCS="README NEWS AUTHORS" \
		cmake-utils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
