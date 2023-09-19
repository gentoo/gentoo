# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Shared audio recording server"
HOMEPAGE="https://bisqwit.iki.fi/source/erec.html"
SRC_URI="https://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-fix-makefile.patch
)

DOCS=( README )
HTML_DOCS=( README.html )

src_prepare() {
	default

	# prevent buildsystem from generating header dependencies
	touch .depend argh/.depend || die
}

src_configure() {
	tc-export AR CC CXX
}

src_install() {
	dobin erec
	einstalldocs
}
