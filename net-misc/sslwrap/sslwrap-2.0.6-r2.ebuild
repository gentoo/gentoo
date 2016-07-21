# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="TSL/SSL - Port Wrapper"
HOMEPAGE="http://www.rickk.com/sslwrap/index.htm"
SRC_URI="http://www.rickk.com/${PN}/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="SSLeay"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="dev-libs/openssl:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}${PV//.}

pkg_setup() {
	tc-export CC
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_install() {
	dosbin ${PN}
	dodoc README
	dohtml -r .
}
