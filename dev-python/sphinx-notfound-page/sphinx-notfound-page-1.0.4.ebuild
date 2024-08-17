# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Create a custom 404 page with absolute URLs hardcoded"
HOMEPAGE="
	https://sphinx-notfound-page.readthedocs.io/
	https://github.com/readthedocs/sphinx-notfound-page/
	https://pypi.org/project/sphinx-notfound-page/
"
SRC_URI="
	https://github.com/readthedocs/sphinx-notfound-page/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/sphinx-5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# calls sphinx-build directly, works around venv
	tests/test_urls.py::test_parallel_build
)
