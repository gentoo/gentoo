# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils linux-info python-single-r1

DESCRIPTION="Transparent proxy server that works as a poor man's VPN using ssh"
HOMEPAGE="https://github.com/apenwarr/sshuttle/"
SRC_URI="http://dev.gentoo.org/~radhermit/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="app-arch/xz-utils"
RDEPEND="net-firewall/iptables"

CONFIG_CHECK="~NETFILTER_XT_TARGET_HL ~IP_NF_TARGET_REDIRECT ~NF_NAT"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_compile() { :; }

src_install() {
	rm stresstest.py || die
	python_moduleinto ${PN}
	python_domodule *.py compat
	python_optimize

	make_wrapper ${PN} "${EPYTHON} $(python_get_sitedir)/${PN}/main.py ${EPYTHON}"

	dodoc README.md
	doman Documentation/${PN}.8
}
