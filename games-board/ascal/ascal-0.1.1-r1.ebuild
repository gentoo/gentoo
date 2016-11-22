# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils flag-o-matic

DESCRIPTION="A game similar to Draughts but with some really cool enhancements"
HOMEPAGE="http://ascal.sourceforge.net/"
SRC_URI="mirror://sourceforge/ascal/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-cpp/libglademm
	dev-cpp/libgnomecanvasmm
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext"

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
