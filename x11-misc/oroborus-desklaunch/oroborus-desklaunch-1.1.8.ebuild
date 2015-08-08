# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

MY_PN=${PN/oroborus-//}

DESCRIPTION="utility for creating desktop icons for Oroborus"
HOMEPAGE="http://www.oroborus.org"
SRC_URI="mirror://debian/pool/main/d/${MY_PN}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	!x11-wm/oroborus-extras"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}
DOCS=( README debian/changelog debian/example_rc )

pkg_setup() {
	tc-export CC
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.7-gentoo.diff
}
