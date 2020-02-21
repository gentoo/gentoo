# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="EasyRSA-${PV}"

DESCRIPTION="Small RSA key management package, based on OpenSSL"
HOMEPAGE="https://openvpn.net/"
SRC_URI="https://github.com/OpenVPN/easy-rsa/releases/download/v${PV}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="libressl"

DEPEND="!libressl? ( >=dev-libs/openssl-0.9.6:0 )
	libressl? ( dev-libs/libressl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	exeinto /usr/share/easy-rsa
	doexe easyrsa
	insinto /usr/share/easy-rsa
	doins -r vars.example openssl-easyrsa.cnf x509-types
	dodoc README.quickstart.md ChangeLog
	dodoc -r doc
	doenvd "${FILESDIR}/65easy-rsa" # config-protect easy-rsa
}
