# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A simulator for the Microchip PIC microcontrollers"
HOMEPAGE="http://gpsim.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc gtk static-libs"

RDEPEND=">=dev-embedded/gputils-0.12
	dev-libs/glib:2
	dev-libs/popt
	sys-libs/readline:0=
	gtk? ( >=x11-libs/gtk+extra-2 )"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc"

DOCS=( ANNOUNCE AUTHORS ChangeLog HISTORY PROCESSORS README README.MODULES TODO )

src_configure() {
	econf \
		$(use_enable gtk gui) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use doc && dodoc doc/gpsim.pdf
	find "${ED}" -name '*.la' -delete || die
}
