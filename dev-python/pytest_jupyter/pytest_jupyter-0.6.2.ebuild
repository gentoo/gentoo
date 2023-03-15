# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Pytest plugin for testing Jupyter libraries and extensions"
HOMEPAGE="https://jupyter.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/jupyter_client-7.4.0[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-6.14[${PYTHON_USEDEP}]
	>=dev-python/jupyter_server-1.21[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
