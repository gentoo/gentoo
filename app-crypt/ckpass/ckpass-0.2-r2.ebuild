# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="ncurses based password database client compatible with KeePass 1.x databases"
HOMEPAGE="https://sourceforge.net/projects/ckpass/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/libkpass-6"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-implicit-function-declaration.patch
)

src_prepare() {
	default
	eautoreconf
}
