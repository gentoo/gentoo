# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic gnome2

DESCRIPTION="GTK based loudspeaker enclosure and crossovernetwork designer"
HOMEPAGE="http://gspeakers.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-cpp/gtkmm:2.4
	>=dev-libs/libsigc++-2.6:2
	dev-libs/libxml2:2
	|| (
		sci-electronics/gnucap
		sci-electronics/ngspice
		sci-electronics/spice
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-cxxflags.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-glib-single-include.patch
	"${FILESDIR}"/${P}-fix-sigc-includes.patch
	"${FILESDIR}"/${P}-c++11.patch
)

src_prepare() {
	append-cxxflags '-std=c++11'
	mv configure.in configure.ac || die
	gnome2_src_prepare
	eautoreconf
}
