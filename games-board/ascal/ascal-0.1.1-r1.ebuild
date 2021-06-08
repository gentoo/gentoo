# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A game similar to Draughts but with some really cool enhancements"
HOMEPAGE="http://ascal.sourceforge.net/"
SRC_URI="mirror://sourceforge/ascal/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-cpp/libglademm
	dev-cpp/libgnomecanvasmm
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-gcc43.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11
	econf
}
