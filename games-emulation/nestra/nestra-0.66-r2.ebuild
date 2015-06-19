# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/nestra/nestra-0.66-r2.ebuild,v 1.7 2015/04/08 14:54:13 mr_bones_ Exp $

EAPI=5
inherit eutils toolchain-funcs flag-o-matic multilib games

PATCH="${P/-/_}-10.diff"
DESCRIPTION="NES emulation for Linux/x86"
HOMEPAGE="http://nestra.linuxgames.com/"
SRC_URI="http://nestra.linuxgames.com/${P}.tar.gz
	mirror://debian/pool/contrib/n/nestra/${PATCH}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11[abi_x86_32(-)]"
DEPEND=${RDEPEND}

S=${WORKDIR}/${PN}

src_prepare() {
	epatch \
		"${WORKDIR}"/${PATCH} \
		"${FILESDIR}"/${P}-exec-stack.patch \
		"${FILESDIR}"/${P}-include.patch
	append-ldflags -Wl,-z,noexecstack
	use amd64 && multilib_toolchain_setup x86
	sed -i \
		-e "s:-L/usr/X11R6/lib:${LDFLAGS}:" \
		-e 's:-O2 ::' \
		-e "s:gcc:$(tc-getCC) ${CFLAGS}:" \
		-e "s:ld:$(tc-getLD) -m elf_i386 $(raw-ldflags):" \
		Makefile || die
}

src_compile() {
	use amd64 && multilib_toolchain_setup x86
	games_src_compile
}

src_install() {
	dogamesbin nestra
	dodoc BUGS CHANGES README
	doman nestra.6
	prepgamesdirs
}
