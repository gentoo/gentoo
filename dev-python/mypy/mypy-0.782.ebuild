# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="http://www.mypy-lang.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~x86"

# stubgen collides with this package: https://bugs.gentoo.org/585594
RDEPEND="
	!dev-util/stubgen
	>=dev-python/psutil-4[${PYTHON_USEDEP}]
	>=dev-python/typed-ast-1.4.0[${PYTHON_USEDEP}]
	<dev-python/typed-ast-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7.4[${PYTHON_USEDEP}]
	>=dev-python/mypy_extensions-0.4.3[${PYTHON_USEDEP}]
	<dev-python/mypy_extensions-0.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
			>=dev-python/attrs-18.0[${PYTHON_USEDEP}]
			>=dev-python/lxml-4.4.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-1.18[${PYTHON_USEDEP}]
			>=dev-python/py-1.5.2[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-16.0.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# The first two patches are backports from upstream commits
	# They should be removed during the next bump
	"${FILESDIR}/${P}-py39-fixes.patch"
	"${FILESDIR}/${P}-pytest-6.patch"
	# Needed to collect all tests
	# https://github.com/python/mypy/pull/9543
	"${FILESDIR}/${P}-conftest.patch"
)

distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_prepare_all() {
	# https://github.com/python/mypy/commit/2f291f2e312dd3bf2c05c45da0b032b240bfd7ab
	# Avoid a big patch by deleting the file manually
	rm test-data/samples/crawl.py || die
	distutils-r1_python_prepare_all
}
