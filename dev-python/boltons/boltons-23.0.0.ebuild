# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Pure-python utilities in the same spirit as the standard library"
HOMEPAGE="https://boltons.readthedocs.io/"
SRC_URI="https://github.com/mahmoud/boltons/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

DOCS=( CHANGELOG.md README.md TODO.rst )

python_test() {
	local EPYTEST_DESELECT=(
		# breaks on traceback text changes caused by e.g. pytest-qt noise
		tests/test_tbutils.py::test_exception_info
	)

	epytest -p no:django
}
