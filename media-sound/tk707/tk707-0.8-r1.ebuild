# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils autotools

DESCRIPTION=" An \"7x7\" type midi drum sequencer for Linux"
HOMEPAGE="http://www-lmc.imag.fr/lmc-edp/Pierre.Saramito/tk707"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${P}-updated_tcl2c.patch.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

RDEPEND=">=media-libs/alsa-lib-0.9.0
		>=dev-lang/tcl-8.4
		>=dev-lang/tk-8.4"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	EPATCH_SOURCE=${S} epatch ${P}-*.patch

	cd "${S}"
	epatch "${FILESDIR}/${P}-asneeded.patch"
	epatch "${FILESDIR}/${P}-nostrip.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
}
