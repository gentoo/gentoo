# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Powerful tool to change file timestamps (including ctimes)"
HOMEPAGE="https://stroke.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

PATCHES=( "${FILESDIR}/${P}-missing-header.patch" )

src_compile() {
	emake AR="$(tc-getAR)"
}
