# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit distutils-r1

DESCRIPTION="Pure Python Multicast DNS Service Discovery Library (Bonjour/Avahi compatible)"
HOMEPAGE="https://github.com/jstasiak/python-zeroconf https://pypi.org/project/zeroconf/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"

# Not included
RESTRICT="test"

python_prepare_all() {
	# It's virtual/python-enum34
	sed \
		-e "s:'enum-compat',::g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die
}
