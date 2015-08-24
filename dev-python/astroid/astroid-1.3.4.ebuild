# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
RESTRICT="test" # False is not True ;)

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="https://bitbucket.org/logilab/astroid https://pypi.python.org/pypi/astroid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x64-macos ~x86-macos"
IUSE="test"

# Version specified in __pkginfo__.py.
RDEPEND=">=dev-python/logilab-common-0.60.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
	test? ( ${RDEPEND}
		>=dev-python/pylint-1.4.0[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/egenix-mx-base[${PYTHON_USEDEP}]' python2_7) )"
# Required for tests
DISTUTILS_IN_SOURCE_BUILD=1

# Restrict to test phase, required because suite fails horribly without it
src_test() {
	local DISTUTILS_NO_PARALLEL_BUILD=1
	distutils-r1_src_test
}

python_test() {
	"${PYTHON}" setup.py build

	pushd build/lib > /dev/null
	PYTHONPATH=. pytest || die "Tests fail with ${EPYTHON}"
	popd > /dev/null
}
