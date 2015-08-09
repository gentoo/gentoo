# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

WANT_AUTOCONF="2.5"
inherit autotools eutils

DESCRIPTION="An advanced suite for testing the randomness of RNG's"
HOMEPAGE="http://www.phy.duke.edu/~rgb/General/dieharder.php"
SRC_URI="http://www.phy.duke.edu/~rgb/General/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/gsl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-qafixes.patch
	eautoreconf
}

src_compile() {
	emake all-recursive || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS README* NOTES || die
	docinto "dieharder"
	dodoc dieharder/README dieharder/NOTES || die
	docinto "libdieharder"
	dodoc libdieharder/README libdieharder/NOTES || die
}
