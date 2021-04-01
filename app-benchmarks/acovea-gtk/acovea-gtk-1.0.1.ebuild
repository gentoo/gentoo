# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic

DESCRIPTION="Analysis of Compiler Options via Evolutionary Algorithm GUI"
HOMEPAGE="http://www.coyotegulch.com/products/acovea/"
SRC_URI="http://www.coyotegulch.com/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode"

RDEPEND=">=app-benchmarks/acovea-5
	dev-cpp/gtkmm:2.4"
DEPEND="${RDEPEND}"

src_prepare() {
	use unicode && eapply "${FILESDIR}"/${P}-unicode.patch
	eapply "${FILESDIR}"/${P}-{libbrahe,libsigc,gcc4.3}.patch
	append-cxxflags -std=c++11
	eautoreconf
}

src_install() {
	default
	make_desktop_entry "${PN}" Acovea-gtk \
		/usr/share/acovea-gtk/pixmaps/acovea_icon_064.png System
}
