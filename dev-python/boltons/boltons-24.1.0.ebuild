# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Pure-python utilities in the same spirit as the standard library"
HOMEPAGE="https://boltons.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest

DOCS=( CHANGELOG.md README.md TODO.rst )

src_test() {
	# tests break with pytest-qt, django, and likely more
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	local EPYTEST_DESELECT=(
		# fails with 3.13, but ignore for now given causes no
		# issues for the only revdep (maturin's tests)
		# https://github.com/mahmoud/boltons/issues/365
		tests/test_funcutils_fb_py3.py::test_update_wrapper_partial\[boltons.funcutils\]
		tests/test_tbutils.py::test_exception_info
	)

	distutils-r1_src_test
}
