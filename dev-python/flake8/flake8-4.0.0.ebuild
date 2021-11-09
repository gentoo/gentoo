# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://gitlab.com/pycqa/flake8 https://pypi.org/project/flake8/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	>=dev-python/pyflakes-2.4.0[${PYTHON_USEDEP}]
	<dev-python/pyflakes-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.9.0[${PYTHON_USEDEP}]
"
PDEPEND="
	>=dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		${PDEPEND}
	)
"

distutils_enable_sphinx docs/source dev-python/sphinx-prompt dev-python/sphinx_rtd_theme
distutils_enable_tests --install pytest

src_prepare() {
	# remove version-limited dep
	sed -i -e '/importlib-metadata/d' setup.cfg || die
	distutils-r1_src_prepare
}
