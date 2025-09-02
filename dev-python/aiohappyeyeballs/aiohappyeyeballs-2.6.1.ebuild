# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Happy Eyeballs for pre-resolved hosts"
HOMEPAGE="
	https://pypi.org/project/aiohappyeyeballs/
	https://github.com/aio-libs/aiohappyeyeballs/
"
SRC_URI="
	https://github.com/aio-libs/aiohappyeyeballs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	>=dev-python/poetry-core-2.0.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/aio-libs/aiohappyeyeballs/pull/181
	"${FILESDIR}/${P}-pytest-asyncio-1.patch"
)

python_test() {
	epytest -o addopts=
}
