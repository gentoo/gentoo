# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils python-single-r1 cmake-utils

DESCRIPTION="Reimplementation of the Infinity engine"
HOMEPAGE="http://gemrb.sourceforge.net/"
SRC_URI="mirror://sourceforge/gemrb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	media-libs/freetype
	media-libs/libpng:0=
	>=media-libs/libsdl-1.2[video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-mixer
	sys-libs/zlib
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	cmake-utils_src_prepare

	sed -i \
		-e '/COPYING/d' \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBIN_DIR=bin
		-DDATA_DIR=share/gemrb
		-DDOC_DIR=share/doc/${PF}
		-DICON_DIR=share/pixmaps
		-DLIB_DIR=$(get_libdir)
		-DMAN_DIR=share/man/man6
		-DMENU_DIR=share/applications
		-DSVG_DIR=share/icons/hicolor/scalable/apps
		-DSYSCONF_DIR=/etc/${PN}
		# needed, causes massive QA warnings otherwise
		-DCMAKE_SKIP_RPATH=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED%/}"/usr/bin/extend2da.py
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
