# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs gnome2-utils games

DESCRIPTION="portable, Open Source NES emulator which is written mostly in C"
HOMEPAGE="http://fakenes.sourceforge.net/"
SRC_URI="mirror://sourceforge/fakenes/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="openal opengl zlib"

RDEPEND=">=media-libs/allegro-4.4.1.1:0[opengl?]
	dev-games/hawknl
	openal? (
		media-libs/openal
		media-libs/freealut
	)
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e "s:openal-config:pkg-config openal:" \
		build/openal.cbd || die

	sed -i \
		-e "s:LIBAGL = agl:LIBAGL = alleggl:" \
		build/alleggl.cbd || die
	epatch "${FILESDIR}"/${P}-{underlink,zlib}.patch
}

src_compile() {
	local myconf

	append-ldflags -Wl,-z,noexecstack

	echo "$(tc-getBUILD_CC) cbuild.c -o cbuild"
	$(tc-getBUILD_CC) cbuild.c -o cbuild || die "cbuild build failed"

	use openal || myconf="$myconf -openal"
	use opengl || myconf="$myconf -alleggl"
	use zlib   || myconf="$myconf -zlib"

	LD="$(tc-getCC) ${CFLAGS}" ./cbuild ${myconf} --verbose || die "cbuild failed"
}

src_install() {
	dogamesbin fakenes
	insinto "${GAMES_DATADIR}/${PN}"
	doins support/*
	dodoc docs/{CHANGES,README}
	dohtml docs/faq.html

	newicon -s 32 support/icon-32x32.png ${PN}.png
	make_desktop_entry ${PN} "FakeNES"

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
