# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/hcalc/hcalc-1.0-r1.ebuild,v 1.5 2012/03/01 19:48:18 ranger Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="DJ's Hex Calculator"
HOMEPAGE="http://www.delorie.com/store/hcalc/"
SRC_URI="http://www.delorie.com/store/hcalc/${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	tc-export CC
}

src_install() {
	dobin ${PN}
}

pkg_postinst() {
	einfo "Enter hcalc to run and use kill or ctrl-c to exit."
}
