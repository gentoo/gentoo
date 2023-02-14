# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Pure-python utilities in the same spirit as the standard library"
HOMEPAGE="https://boltons.readthedocs.io/"
SRC_URI="https://github.com/mahmoud/boltons/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

DOCS=( CHANGELOG.md README.md TODO.rst )

PATCHES=(
	"${FILESDIR}"/${P}-python3.10.patch
	"${FILESDIR}"/${P}-python3.11-tests.patch
)

EPYTEST_DESELECT=(
	# fails if there's any noise/differences in traceback text caused
	# by e.g. pytest-qt noise or python3.11 adding ^^^^^^ markers
	tests/test_tbutils.py::test_exception_info
)

python_test() {
	epytest -p no:django
}
