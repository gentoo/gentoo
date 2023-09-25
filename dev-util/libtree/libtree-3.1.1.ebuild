# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="ldd as a tree with an option to bundle dependencies into a single folder"
HOMEPAGE="https://github.com/haampie/libtree"
SRC_URI="https://github.com/haampie/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${P}-modern-c.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
