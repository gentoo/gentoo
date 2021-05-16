# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A flexible command-line scientific calculator"
HOMEPAGE="http://w-calc.sourceforge.net/"
SRC_URI="mirror://sourceforge/w-calc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="readline"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-AR.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with readline)
}

src_install() {
	default

	# Wcalc icons
	newicon graphics/w.png wcalc.png
	newicon graphics/Wred.png wcalc-red.png
}
