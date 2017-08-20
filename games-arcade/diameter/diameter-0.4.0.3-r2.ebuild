# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1

DESCRIPTION="Arcade game with elements of economy and adventure"
HOMEPAGE="http://gamediameter.sourceforge.net/"
SRC_URI="mirror://sourceforge/gamediameter/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-games/guichan-0.8[opengl,sdl]
	media-libs/libpng:0=
	media-libs/libsdl[video]
	media-libs/sdl-image[gif,jpeg,png]
	media-libs/sdl-mixer[mod]
	virtual/opengl
	virtual/glu
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/gamediameter

src_prepare() {
	default

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

	# needed, otherwise -lpython2.7 will not be found
	python_export PYTHON PYTHON_LIBS
}

src_install() {
	default

	newicon data/texture/gui/eng/main/logo.png ${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
