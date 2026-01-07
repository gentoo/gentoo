# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python tool configuration"
HOMEPAGE="
	https://pypi.org/project/pytoolconfig/
	https://github.com/bagel897/pytoolconfig/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

RDEPEND="
	>=dev-python/packaging-23.2[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.11.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/tabulate-0.8.9[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
