# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-ceilometerclient/python-ceilometerclient-1.0.10.ebuild,v 1.3 2014/08/10 21:18:33 slyfox Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="This is a client library for Ceilometer built on the Ceilometer API"
HOMEPAGE="https://github.com/openstack/python-ceilometerclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.6[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? ( >=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
			<dev-python/hacking-0.9[${PYTHON_USEDEP}]
			>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0[${PYTHON_USEDEP}]
			>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.2[${PYTHON_USEDEP}]
			>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
			>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}]
	)"
RDEPEND=">=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
		>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
		<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.5.2[${PYTHON_USEDEP}]"

python_test() {
	testr init
	testr run || die "tests failed under python2.7"
	flake8 ceilometerclient/tests/ || die "run over tests folder by flake8 yielded error"
}
