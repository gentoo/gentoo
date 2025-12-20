# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Small utility that measures throughput between stdin and stdout"
HOMEPAGE="https://sourceforge.net/projects/pipeworks/"
SRC_URI="https://downloads.sourceforge.net/pipeworks/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin pipeworks
	doman pipeworks.1
	dodoc Changelog README
}
