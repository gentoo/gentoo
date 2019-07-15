# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Console mode MIDI player with builtin userland OPL2 driver"
HOMEPAGE="https://bisqwit.iki.fi/source/fmdrv.html"
SRC_URI="https://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="fmdrv GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="amd64 x86"

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
