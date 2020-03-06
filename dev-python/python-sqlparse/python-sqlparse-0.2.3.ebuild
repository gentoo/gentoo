# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_PN="${PN##python-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A non-validating SQL parser module for Python"
HOMEPAGE="https://github.com/andialbrecht/sqlparse"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
LICENSE="BSD-2"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		)"
# Required for running tests
DISTUTILS_IN_SOURCE_BUILD=1

S="${WORKDIR}"/${P#python-}

python_test() {
	if python_is_python3; then
		2to3 -w --no-diffs -n tests/ sqlparse/
		py.test ./tests || die "testsuite failed ${EPYTHON}"
	else
		py.test tests || die "testsuite failed under ${EPYTHON}"
	fi
}
