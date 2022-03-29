# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="tool for the sonypi-Device (found in Sony Vaio Notebooks)"
HOMEPAGE="https://www.popies.net/sonypi/"
SRC_URI="https://www.popies.net/sonypi/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 -ppc x86"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin spicctrl
	einstalldocs
}
