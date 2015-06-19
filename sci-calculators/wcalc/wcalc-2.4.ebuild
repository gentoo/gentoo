# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/wcalc/wcalc-2.4.ebuild,v 1.6 2015/02/09 12:45:32 blueness Exp $

EAPI=4

inherit eutils

DESCRIPTION="A flexible command-line scientific calculator"
HOMEPAGE="http://w-calc.sourceforge.net/"
SRC_URI="mirror://sourceforge/w-calc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="readline"

DEPEND="
	dev-libs/gmp
	dev-libs/mpfr
	readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with readline)
}

src_install() {
	default

	# Wcalc icons
	newicon w.png wcalc.png
	newicon Wred.png wcalc-red.png
}
