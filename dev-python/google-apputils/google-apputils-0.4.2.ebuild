# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/google-apputils/google-apputils-0.4.2.ebuild,v 1.2 2015/06/07 13:28:57 jlec Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )	# Doesn't yet support py3

inherit distutils-r1

DESCRIPTION="Collection of utilities for building Python applications"
HOMEPAGE="https://github.com/google/google-apputils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~m68k ~mips ~ppc64 ~s390 ~sh ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/python-dateutil-1.4[${PYTHON_USEDEP}]
	>=dev-python/python-gflags-1.4[${PYTHON_USEDEP}]
	>=dev-python/pytz-2010[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} dev-python/mox[${PYTHON_USEDEP}] )"

python_test() {
	# These yield 2 fails which are in fact expected errors run from a shell script!
	# They seemingly have no immediate mechanism to exit 0 in an expected fail style.
	for test in tests/{app_test*.py,[b-s]*.py} ; do
		"${PYTHON}" $test || die "test failure under ${EPYTHON}"
	done
}
