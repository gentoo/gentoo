# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Utitilies for maintaining Python packages"
HOMEPAGE="
	https://github.com/gentoo/gpyutils/
	https://pypi.org/project/gpyutils/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=app-portage/gentoopm-0.3.2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
