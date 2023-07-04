# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYPI_NO_NORMALIZE=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A small sphinx extension to add a \"copy\" button to code blocks"
HOMEPAGE="https://pypi.org/project/sphinx-copybutton/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/sphinx-6.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
