# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Context manager for mocking/wrapping stdin/stdout/stderr"
HOMEPAGE="
	https://github.com/bskinn/stdio-mgr/
	https://pypi.org/project/stdio-mgr/
"
SRC_URI="https://github.com/bskinn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64 arm ~arm64 ppc ~ppc64 sparc x86"
SLOT="0"

RDEPEND=">=dev-python/attrs-17.1[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
# doc directory is not included in the release tarball for some reason
#distutils_enable_sphinx doc \
#				dev-python/sphinxcontrib-programoutput \
#				dev-python/sphinx_rtd_theme

python_test() {
	# skip the doctests
	epytest tests
}
