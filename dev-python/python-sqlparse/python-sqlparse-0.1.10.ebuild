# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-sqlparse/python-sqlparse-0.1.10.ebuild,v 1.10 2015/04/08 08:05:28 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="A non-validating SQL parser module for Python"
HOMEPAGE="http://code.google.com/p/python-sqlparse/ https://github.com/andialbrecht/sqlparse"
SRC_URI="https://github.com/andialbrecht/sqlparse/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
LICENSE="BSD-2"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
DISTUTILS_IN_SOURCE_BUILD=1	# Required for running tests

S="${WORKDIR}"/${P#python-}

python_test() {
	if python_is_python3; then
		2to3 -w --no-diffs -n tests/ sqlparse/
		py.test ./tests || die "testsuite failed ${EPYTHON}"
	else
		py.test tests || die "testsuite failed under ${EPYTHON}"
	fi
}
