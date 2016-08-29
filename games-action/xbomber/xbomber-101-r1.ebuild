# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Bomberman clone w/multiplayer support"
HOMEPAGE="http://www.xdr.com/dash/bomber.html"
SRC_URI="http://www.xdr.com/dash/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="!sci-biology/emboss
	${DEPEND}"

PATCHES=(
		"${FILESDIR}"/${P}-va_list.patch
		"${FILESDIR}"/${P}-gcc4.patch
		"${FILESDIR}"/${P}-ldflags.patch
		"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	sed -i \
		-e "/^CC/d" \
		-e 's/gcc/$(CC)/g' \
		-e "s:X386:X11R6:" \
		Makefile || die

	# ${P}-ldflags.patch depends on the munged Makefile
	default

	sed -i \
		-e "s:data/%s:/usr/share/${PN}/%s:" bomber.c || die
	sed -i \
		-e "s:=\"data\":=\"/usr/share/${PN}\":" sound.c || die
}

src_install() {
	dobin matcher bomber
	insinto /usr/share/${PN}
	doins -r data/*
	dodoc README Changelog
}
