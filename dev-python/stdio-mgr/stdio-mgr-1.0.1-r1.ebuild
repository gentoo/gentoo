# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Context manager for mocking/wrapping stdin/stdout/stderr"
HOMEPAGE="
	https://github.com/bskinn/stdio-mgr/
	https://pypi.org/project/stdio-mgr/
"
SRC_URI="
	https://github.com/bskinn/stdio-mgr/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/attrs-17.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
# doc directory is not included in the release tarball for some reason
#distutils_enable_sphinx doc \
#				dev-python/sphinxcontrib-programoutput \
#				dev-python/sphinx-rtd-theme

python_test() {
	# skip the doctests
	epytest tests
}
