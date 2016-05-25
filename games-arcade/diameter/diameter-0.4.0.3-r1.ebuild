# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 eutils autotools games

DESCRIPTION="Arcade game with elements of economy and adventure"
HOMEPAGE="http://gamediameter.sourceforge.net/"
SRC_URI="mirror://sourceforge/gamediameter/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-games/guichan-0.8[opengl,sdl]
	media-libs/libpng:0=
	virtual/opengl
	virtual/glu
	media-libs/libsdl[video]
	media-libs/sdl-image[gif,jpeg,png]
	media-libs/sdl-mixer[mod]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/gamediameter

pkg_setup() {
	python-any-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	sed -i \
		-e "s:gamediameter:diameter:" \
		configure.in || die
	mv configure.in configure.ac || die
	sed -i \
		-e '/for i in .*\/lib/s:".*:/usr/lib/ ; do:' \
		-e "/AC_SUBST.*LDFLAGS/s/\".*\"/\$PYTHON_LIBS/" \
		acinclude.m4 || die
	# bug #336812
	sed -i \
		-e '/gui nebular3.gif/s/gui//' \
		data/texture/Makefile.am || die
	eautoreconf
	python_export PYTHON PYTHON_LIBS
}

src_install() {
	default
	newicon data/texture/gui/eng/main/logo.png ${PN}.png
	make_desktop_entry ${PN} Diameter
	prepgamesdirs
}
