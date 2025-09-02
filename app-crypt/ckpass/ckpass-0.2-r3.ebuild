# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="ncurses based password database client compatible with KeePass 1.x databases"
HOMEPAGE="https://sourceforge.net/projects/ckpass/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/libkpass-6
	sys-libs/ncurses:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-implicit-function-declaration.patch
	"${FILESDIR}"/${P}-fix_c23_and_sentinel.patch
)

src_prepare() {
	default
	eautoreconf
}
