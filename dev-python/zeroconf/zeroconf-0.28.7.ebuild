# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

MY_P=python-zeroconf-${PV}
DESCRIPTION="Pure Python Multicast DNS Service Discovery Library (Bonjour/Avahi compatible)"
HOMEPAGE="
	https://github.com/jstasiak/python-zeroconf/
	https://pypi.org/project/zeroconf/"
SRC_URI="
	https://github.com/jstasiak/python-zeroconf/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-python/ifaddr-0.1.7[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

src_prepare() {
	# broken in network-sandbox
	sed -e 's:test_launch_and_close:_&:' \
		-e 's:test_integration_with_listener_ipv6:_&:' \
		-i zeroconf/test.py || die
	distutils-r1_src_prepare
}
