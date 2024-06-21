# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small RSA key management package, based on OpenSSL"
HOMEPAGE="https://openvpn.net/"
SRC_URI="https://github.com/OpenVPN/easy-rsa/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

DEPEND=">=dev-libs/openssl-0.9.6:0="
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/share/easy-rsa
	doexe easyrsa3/easyrsa dev/easyrsa-tools.lib
	insinto /usr/share/easy-rsa
	doins -r easyrsa3/{vars.example,openssl-easyrsa.cnf,x509-types}
	dodoc README.quickstart.md ChangeLog
	dodoc -r doc
	doenvd "${FILESDIR}/65easy-rsa" # config-protect easy-rsa
}
