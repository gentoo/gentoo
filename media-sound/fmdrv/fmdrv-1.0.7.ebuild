# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Console mode MIDI player with builtin userland OPL2 driver"
HOMEPAGE="https://bisqwit.iki.fi/source/fmdrv.html"
SRC_URI="https://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="fmdrv GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-ioperm.patch
	"${FILESDIR}"/${P}-fix-makefile.patch
)

DOCS=( README )
HTML_DOCS=( README.html )

src_configure() {
	tc-export AR CC CXX
}

src_install() {
	dobin fmdrv
	einstalldocs
}

pkg_postinst() {
	elog "If you want to use AdLib (FM OPL2), you need to setuid /usr/bin/fmdv."
	elog "chmod 4711 /usr/bin/fmdrv"
}
