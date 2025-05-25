# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Pure-python utilities in the same spirit as the standard library"
HOMEPAGE="https://boltons.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

DOCS=( CHANGELOG.md README.md TODO.rst )

src_test() {
	# tests break with pytest-qt, django, and likely more
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	distutils-r1_src_test
}
