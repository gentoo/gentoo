# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/fmdrv/fmdrv-1.0.7.ebuild,v 1.10 2015/02/16 19:34:57 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Console mode MIDI player with builtin userland OPL2 driver"
HOMEPAGE="http://bisqwit.iki.fi/source/fmdrv.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="fmdrv GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="x86 amd64"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ioperm.patch
}

src_configure() { :; } # it is a fake

src_compile() {
	emake fmdrv \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin fmdrv
	dodoc README
	dohtml README.html
}

pkg_postinst() {
	elog "If you want to use AdLib (FM OPL2), you need to setuid /usr/bin/fmdv."
	elog "chmod 4711 /usr/bin/fmdrv"
}
