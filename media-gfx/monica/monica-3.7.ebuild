# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/monica/monica-3.7.ebuild,v 1.8 2012/01/05 18:25:34 ssuominen Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Monica is a Monitor Calibration Tool"
HOMEPAGE="http://www.pcbypaul.com/software/monica.html"
SRC_URI="http://www.pcbypaul.com/software/dl/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=x11-libs/fltk-1.1:1"
RDEPEND="${DEPEND}
	x11-apps/xgamma"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.6-makefile-cleanup.patch \
		"${FILESDIR}"/${P}-gcc44.patch

	emake clean
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LINK="$(tc-getCXX)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin monica
	dodoc authors ChangeLog news readme
}
