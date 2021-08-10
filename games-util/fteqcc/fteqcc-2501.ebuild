# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix toolchain-funcs

DESCRIPTION="QC compiler"
HOMEPAGE="http://fteqw.sourceforge.net/"
SRC_URI="mirror://sourceforge/fteqw/qclibsrc${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${P}-cleanup-source.patch
	"${FILESDIR}"/${P}-Makefile.patch
)

src_prepare() {
	default
	edos2unix readme.txt
}

src_configure() {
	tc-export CC
}

src_install() {
	newbin fteqcc.bin fteqcc
	dodoc readme.txt
}
