# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simulator for the Microchip PIC microcontrollers"
HOMEPAGE="http://gpsim.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc"

RDEPEND="
	>=dev-embedded/gputils-0.12
	dev-libs/glib:2
	dev-libs/popt
	sys-libs/readline:0=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	virtual/pkgconfig
	app-alternatives/yacc
"
DOCS=( ANNOUNCE AUTHORS ChangeLog HISTORY PROCESSORS README README.MODULES TODO )

src_configure() {
	local myeconfargs=(
		--disable-gui
		--disable-static
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use doc && dodoc doc/gpsim.pdf
	find "${ED}" -name '*.la' -delete || die
}
