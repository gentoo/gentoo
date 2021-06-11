# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="More descriptive parametrized-test IDs for py.test"
HOMEPAGE="https://github.com/man-group/pytest-plugins https://pypi.org/project/pytest-verbose-parametrize/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# The test suite is borked, some of the tests are extremely sensitive to Python
# verbosity level whereas others act differently depending on whether the package
# has previously been installed or not.
RESTRICT="test"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="test? (
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0_collections-abc.patch
)

distutils_enable_tests pytest
