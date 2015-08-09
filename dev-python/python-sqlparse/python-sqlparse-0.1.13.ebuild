# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy )

inherit distutils-r1

DESCRIPTION="A non-validating SQL parser module for Python"
HOMEPAGE="http://code.google.com/p/python-sqlparse/ https://github.com/andialbrecht/sqlparse"
SRC_URI="https://github.com/andialbrecht/sqlparse/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
LICENSE="BSD-2"
IUSE="doc examples test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		)"
# Required for running tests
DISTUTILS_IN_SOURCE_BUILD=1

S="${WORKDIR}"/${P#python-}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	if python_is_python3; then
		2to3 -w --no-diffs -n tests/ sqlparse/
		py.test ./tests || die "testsuite failed ${EPYTHON}"
	else
		py.test tests || die "testsuite failed under ${EPYTHON}"
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
