# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A sphinx extension for inline tabs"
HOMEPAGE="https://pypi.org/project/sphinx-inline-tabs/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/sphinx-6.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
