# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pbr/pbr-0.8.2.ebuild,v 1.9 2015/05/15 07:11:57 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="PBR is a library that injects some useful and sensible default
behaviors into your setuptools run."
HOMEPAGE="https://github.com/openstack-dev/pbr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/flake8-2.0[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}] )"
RDEPEND=">dev-python/pip-1.4[${PYTHON_USEDEP}]"

# Requ'd for testsuite
DISTUTILS_IN_SOURCE_BUILD=1
# You can do this in about 3 different ways; throw it in a src_test() and prepend it to a
# distutils-r1_src_test or os it a distutils-r1_python_test, but really it makes for a HUGE 'meh'

# This normally actually belongs here.
python_prepare_all() {
	# This test passes when run within the source and doesn't represent a failure, but rather
	# a gentoo sandbox constraint
	sed -e s':test_console_script_develop:_&:' -i pbr/tests/test_core.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	testr init
	testr run || die "Testsuite failed under ${EPYTHON}"
	flake8 "${PN}"/tests || die "Run over tests folder by flake8 drew error"
}
