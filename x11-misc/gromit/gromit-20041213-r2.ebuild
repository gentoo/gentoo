# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="GRaphics Over MIscellaneous Things, a presentation helper"
HOMEPAGE="http://www.home.unix-ag.org/simon/gromit"
SRC_URI="http://www.home.unix-ag.org/simon/gromit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin gromit
	newdoc gromitrc gromitrc.example
	einstalldocs
}
