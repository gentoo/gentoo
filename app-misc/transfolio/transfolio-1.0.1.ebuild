# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Enables data transfer between the PC and the Atari Portfolio"
HOMEPAGE="http://leute.server.de/peichl/"
SRC_URI="http://leute.server.de/peichl/transfolio.zip -> ${P}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_prepare() {
	default

	# Respect users CC, CFLAGS and disable striping
	sed -e 's/cc/${CC}/' -e 's/-O2/${CFLAGS}/' -e '/strip/d' -i Makefile || die

	tc-export CC
}

src_install() {
	dobin transfolio

	einstalldocs
}
