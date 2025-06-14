# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1 pypi

DESCRIPTION="Collection of tools missing from the Python standard library"
HOMEPAGE="
	https://mathema.tician.de/software/pytools/
	https://github.com/inducer/pytools/
	https://pypi.org/project/pytools/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv"

# NB: numpy are an "extra" (optional) deps
RDEPEND="
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2[${PYTHON_USEDEP}]
	>=dev-python/siphash24-1.6[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
