# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/astroid/astroid-1.1.1.ebuild,v 1.1 2014/05/08 09:37:16 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="http://bitbucket.org/logilab/astroid http://pypi.python.org/pypi/astroid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x86-macos"
IUSE="test"

# Version specified in __pkginfo__.py.
RDEPEND=">=dev-python/logilab-common-0.60.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		>=dev-python/pylint-1.1.0[${PYTHON_USEDEP}] )"
# Required for tests
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# https://bitbucket.org/logilab/astroid/issue/8/
	sed -e "s/test_numpy_crash/_&/" -i test/unittest_regrtest.py

	distutils-r1_python_prepare_all
}

# Restrict to test phase, required because suite fails horribly without it
src_test() {
	local DISTUTILS_NO_PARALLEL_BUILD=1
	distutils-r1_src_test
}

python_test() {
	# https://bitbucket.org/logilab/astroid/issue/16/1-test-fail-test_socket_build-under-pypy
	python setup.py build

	pushd build/lib > /dev/null
	if [[ "${EPYTHON}" == pypy* ]]; then
		sed -e 's:test_socket_build:_&:' -i ${PN}/test/unittest_builder.py || die
	fi
	PYTHONPATH=. pytest || die "Tests fail with ${EPYTHON}"
	popd > /dev/null
}
