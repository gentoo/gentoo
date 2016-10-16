# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_P="EasyRSA-${PV}"

DESCRIPTION="Small RSA key management package, based on OpenSSL"
HOMEPAGE="http://openvpn.net/"
SRC_URI="https://github.com/OpenVPN/easy-rsa/releases/download/${PV}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="libressl"

DEPEND="!libressl? ( >=dev-libs/openssl-0.9.6:0 )
	libressl? ( dev-libs/libressl )"
RDEPEND="${DEPEND}
	!<net-misc/openvpn-2.3"

S="${WORKDIR}/${MY_P}"

src_install() {
	exeinto /usr/share/easy-rsa
	doexe easyrsa
	insinto /usr/share/easy-rsa
	doins -r vars.example openssl-1.0.cnf x509-types
	dodoc README.quickstart.md ChangeLog
	dodoc -r doc
	doenvd "${FILESDIR}/65easy-rsa" # config-protect easy-rsa
}
