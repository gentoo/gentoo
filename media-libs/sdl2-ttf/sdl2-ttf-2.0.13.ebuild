# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib-minimal

MY_P=SDL2_ttf-${PV}
DESCRIPTION="library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="http://www.libsdl.org/projects/SDL_ttf/"
SRC_URI="http://www.libsdl.org/projects/SDL_ttf/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs X"

RDEPEND="X? ( >=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}] )
	>=media-libs/libsdl2-2.0.1-r1[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]"
DEPEND=${RDEPEND}

S=${WORKDIR}/${MY_P}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_with X x)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc {CHANGES,README}.txt
	prune_libtool_files
}
