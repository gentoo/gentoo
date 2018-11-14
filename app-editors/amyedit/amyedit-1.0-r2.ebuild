# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION=" AmyEdit is a LaTeX editor"
HOMEPAGE="http://amyedit.sf.net"
SRC_URI="mirror://sourceforge/amyedit/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RDEPEND=">=dev-cpp/gtkmm-2.6:2.4
	>=dev-cpp/glibmm-2.14:2
	>=dev-libs/libsigc++-2.2
	x11-libs/gtksourceview:2.0
	dev-cpp/gtksourceviewmm:2.0
	app-text/aspell"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-keyfile.patch"
	epatch "${FILESDIR}/${P}-signal.patch"
	epatch "${FILESDIR}/${P}-gcc45.patch"
	epatch "${FILESDIR}/${P}-sourceviewmm2.patch"
	rm -rf "${S}/src/gtksourceviewmm" || die
	append-cxxflags -std=c++11
	mv configure.in configure.ac || die
	eautoreconf
}
