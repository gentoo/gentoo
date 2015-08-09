# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Small RSA key management package, based on OpenSSL"
HOMEPAGE="http://openvpn.net/"
SRC_URI="http://swupdate.openvpn.net/community/releases/${P}_master.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND=">=dev-libs/openssl-0.9.6:0"
RDEPEND="${DEPEND}
	!<net-misc/openvpn-2.3"

S="${WORKDIR}/${P}_master"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.0.0-pkcs11.patch \
		"${FILESDIR}"/no-licenses.patch
}

src_configure() {
	econf --docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_install() {
	emake DESTDIR="${D}" install
	doenvd "${FILESDIR}/65easy-rsa" # config-protect easy-rsa
}
