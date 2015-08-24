# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )	# Doesn't yet support py3

inherit distutils-r1

DESCRIPTION="Collection of utilities for building Python applications"
HOMEPAGE="https://code.google.com/p/google-apputils-python/"
SRC_URI="https://google-apputils-python.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ia64 ~m68k ~mips ~ppc64 ~s390 ~sh x86"
IUSE="test"

RDEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/python-gflags[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-python/mox[${PYTHON_USEDEP}] )"
# version borders needed are already confluent with versions in the tree

python_prepare_all() {
	# https://code.google.com/p/google-apputils-python/source/detail?r=12
	# This version bordering is long out of date and wrong since end of March 2012!
	sed -e 's:>=1.4,<2:>=1.4:' -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# These yield 2 fails which are in fact expected errors run from a shell script!
	# They seemingly have no immediate mechanism to exit 0 in an expected fail style.
	for test in tests/{app_test*.py,[b-s]*.py}
	do
		"${PYTHON}" $test || die "test failure under ${EPYTHON}"
	done
}
