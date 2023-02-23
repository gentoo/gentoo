# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="An HTML minification plugin for Pelican, the static site generator"
HOMEPAGE="https://pypi.org/project/pelican-minify/"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/joblib-0.9[${PYTHON_USEDEP}]
	>=app-text/htmlmin-0.1.5[${PYTHON_USEDEP}]
	>=app-text/pelican-3.1.1[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
