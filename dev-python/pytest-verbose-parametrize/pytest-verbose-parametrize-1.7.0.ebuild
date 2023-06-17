# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="More descriptive parametrized-test IDs for py.test"
HOMEPAGE="https://github.com/man-group/pytest-plugins https://pypi.org/project/pytest-verbose-parametrize/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# The test suite is borked, some of the tests are extremely sensitive to Python
# verbosity level whereas others act differently depending on whether the package
# has previously been installed or not.
RESTRICT="test"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools-git[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-virtualenv[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0_collections-abc.patch
)

distutils_enable_tests pytest
