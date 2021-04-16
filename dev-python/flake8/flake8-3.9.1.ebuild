# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://gitlab.com/pycqa/flake8 https://pypi.org/project/flake8/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-macos"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	>=dev-python/pyflakes-2.3.0[${PYTHON_USEDEP}]
	<dev-python/pyflakes-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.7.0[${PYTHON_USEDEP}]
	<dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/importlib_metadata[${PYTHON_USEDEP}]' pypy3 python3_{6,7})
"
PDEPEND="
	>=dev-python/mccabe-0.6.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.7.0[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		${PDEPEND}
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source dev-python/sphinx-prompt dev-python/sphinx_rtd_theme
distutils_enable_tests --install pytest
