# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ncurses bandwidth monitor"
HOMEPAGE="https://github.com/causes-/nbwmon"
SRC_URI="https://github.com/causes-/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.5.2-tinfo.patch )

src_prepare() {
	default
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin ${PN}
	dodoc README
}
