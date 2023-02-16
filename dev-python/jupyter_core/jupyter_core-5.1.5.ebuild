# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Core common functionality of Jupyter projects"
HOMEPAGE="
	https://jupyter.org/
	https://github.com/jupyter/jupyter_core/
	https://pypi.org/project/jupyter-core/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/platformdirs-2.5[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/ipython-4.0.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/myst_parser \
	dev-python/sphinx-autodoc-typehints \
	dev-python/sphinxcontrib-github-alt \
	dev-python/sphinxcontrib-spelling \
	dev-python/traitlets
distutils_enable_tests pytest
