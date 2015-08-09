# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# py2.6 capable but unrequired
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

# Use at your own risk ;), or because an openstack package cited it as a req'd dep :)
DESCRIPTION="The Mock object framework for Python"
HOMEPAGE="http://code.google.com/p/pymox/wiki/MoxDocumentation http://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="test"
LICENSE="Apache-2.0"
SLOT="0"
# Required for test phase
DISTUTILS_IN_SOURCE_BUILD=1

# Though test-req's cites hacking>=0.5.6,<0.7, setting to hacking>=0.7.2-r1,<0.8
# since it WORKS and supports py3.2. What more do you want
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.5.21[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		~dev-python/pep8-1.4.5[${PYTHON_USEDEP}]
		~dev-python/pyflakes-0.7.2[${PYTHON_USEDEP}]
		~dev-python/flake8-2.0[${PYTHON_USEDEP}]
		>=dev-python/hacking-0.8.0[${PYTHON_USEDEP}]
		<dev-python/hacking-0.9[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		dev-python/subunit[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.17[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.32[${PYTHON_USEDEP}]
	)"
RDEPEND=">=dev-python/fixtures-0.3.12[${PYTHON_USEDEP}]"

python_test() {
	testr init || die
	testr run || die "testsuite failed under ${EPYTHON}"
	flake8 "${PN}"/tests || die "flake8 drew error on a run over folder ${PN}/tests"
}
