# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Mole infested 2D platform game"
HOMEPAGE="http://moleinvasion.tuxfamily.org/"
SRC_URI="
	ftp://download.tuxfamily.org/minvasion/packages/MoleInvasion-${PV}.tar.bz2
	music? ( mirror://gentoo/${PN}-music-20090731.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="music"

DEPEND="
	media-libs/libsdl[opengl,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	virtual/opengl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	default

	if use music; then
		mv -f "${WORKDIR}"/music ../ || die
	fi

	sed -i \
		-e '/^CFLAGS/s:= -g:+=:' \
		-e '/^LDFLAGS/d' \
		-e "/^FINALEXEDIR/s:/usr.*:/usr/bin:" \
		-e "/^FINALDATADIR/s:/usr.*:/usr/share/${PN}:" \
		Makefile || die "sed failed"

	eapply \
		"${FILESDIR}"/${P}-opengl.patch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-fno-common.patch
}

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" install install-data
	doman ../debian/*.6

	newicon ../gfx/icon.xpm moleinvasion.xpm
	make_desktop_entry moleinvasion "Mole Invasion"
}
