# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_5} )

inherit eutils linux-info distutils-r1

DESCRIPTION="Transparent proxy server that works as a poor man's VPN using ssh"
HOMEPAGE="https://github.com/sshuttle/sshuttle"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	net-firewall/iptables
"
DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

CONFIG_CHECK="~NETFILTER_XT_TARGET_HL ~IP_NF_TARGET_REDIRECT ~NF_NAT"

python_test() {
	py.test || die "Tests fail under ${EPYTHON}"
}
