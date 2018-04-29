# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

DESCRIPTION="Gamecube emulator"
HOMEPAGE="http://gcube.exemu.net/"
SRC_URI="http://gcube.exemu.net/downloads/${P}-src.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/opengl
	media-libs/libsdl[joystick,opengl,sound,video]
	virtual/jpeg:0
	sys-libs/ncurses:0=
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PV}"

src_prepare() {
	default

	sed -i -e '/^CFLAGS=-g/d' Makefile.rules || die

	eapply "${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-gcc47.patch

	sed -i -e '/^CC=/d' Makefile || die

	append-cflags -std=gnu89 # build with gcc5 (bug #570504)
}

src_install() {
	local x

	dobin gcmap gcube
	for x in bin2dol isopack thpview tplx ; do
		newbin ${x} ${PN}-${x}
	done

	einstalldocs
}
