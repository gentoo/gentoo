# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P=${P/p/P}
DESCRIPTION="A http/https reverse-proxy and load-balancer"
HOMEPAGE="http://www.apsis.ch/pound/"
SRC_URI="http://www.apsis.ch/pound/${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"

DEPEND="
	dev-libs/libpcre
	dev-libs/libyaml
	dev-libs/nanomsg
	dev-libs/openssl
	net-libs/mbedtls
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile(){
	cmake_src_compile
}

src_install(){
	doman "${S}"/man/pound.8
	dodoc README.md

	dodir /etc/init.d
	newinitd "${FILESDIR}"/pound.init-1.9 pound

	insinto /etc
	newins "${FILESDIR}"/pound-2.2.cfg pound.cfg
}

pkg_postinst() {
	elog "No demo-/sample-configfile is included in the distribution; read the man-page for more info."
	elog "A sample (localhost:8888 -> localhost:80) for gentoo is given in \"/etc/pound.cfg\"."
	echo
	ewarn "You will have to upgrade you configuration file, if you are"
	ewarn "upgrading from a version <= 2.0."
	echo
	ewarn "The 'WebDAV' config statement is no longer supported!"
	ewarn "Please adjust your configuration, if necessary."
	echo
}
