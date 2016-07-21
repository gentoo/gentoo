# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

MY_P=vdr-amarok-${PV}

DESCRIPTION="vdr to amarok gateway - allows vdr-amarok to access amarok"
HOMEPAGE="http://irimi.ir.ohost.de/"
SRC_URI="http://irimi.ir.ohost.de/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
RDEPEND="media-sound/amarok"

S="${WORKDIR}/${MY_P#vdr-}/${PN}"

src_prepare() {
	# Respect CC,CXXFLAGS, LDFLAGS
	sed -i -e "/^CXX /s:?=.*:= $(tc-getCXX):" \
		-e "/^CXXFLAGS/s:?=.*:= ${CFLAGS}:" \
		-e "s:\$(CXXFLAGS):& \$(LDFLAGS) :" "${S}"/Makefile

	cd "${WORKDIR}/${MY_P#vdr-}"
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}/${P}_gcc-4.7.diff"
}

src_install() {
	dobin ${PN}
	dodoc README
	newdoc ../README README.vdr-amarok

	insinto /etc
	doins ${PN}.conf
}
