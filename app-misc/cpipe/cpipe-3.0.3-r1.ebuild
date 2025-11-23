# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Counting pipe, measures data transfered over pipe"
HOMEPAGE="https://github.com/HaraldKi/cpipe"
SRC_URI="https://github.com/HaraldKi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin cpipe

	einstalldocs
	doman cpipe.1
}
