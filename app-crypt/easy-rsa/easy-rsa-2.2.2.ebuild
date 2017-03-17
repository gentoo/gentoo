# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

MY_P="EasyRSA-${PV}"

DESCRIPTION="Small RSA key management package, based on OpenSSL"
HOMEPAGE="http://openvpn.net/"
SRC_URI="https://github.com/OpenVPN/easy-rsa/releases/download/${PV}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND=">=dev-libs/openssl-0.9.6:0"
RDEPEND="${DEPEND}
	!<net-vpn/openvpn-2.3"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PV}-pkcs11.patch"
}

src_install() {
	exeinto /usr/share/easy-rsa
	doexe build-* clean-all inherit-inter list-crl pkitool revoke-full sign-req whichopensslcnf
	insinto /usr/share/easy-rsa
	doins vars openssl-*.cnf
	doenvd "${FILESDIR}/65easy-rsa" # config-protect easy-rsa
}
