# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1 pypi

DESCRIPTION="Sphinx extension that automatically documents argparse commands and options"
HOMEPAGE="https://pypi.org/project/sphinx-argparse/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/commonmark[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
