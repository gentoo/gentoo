# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Module for click to enable registering CLI commands via entry points"
HOMEPAGE="
	https://github.com/click-contrib/click-plugins/
	https://pypi.org/project/click-plugins/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	# backport based on
	# https://github.com/click-contrib/click-plugins/commit/29e66eb05a5911e333501bd21466f02e6b697892
	"${FILESDIR}/${P}-click82.patch"
)
