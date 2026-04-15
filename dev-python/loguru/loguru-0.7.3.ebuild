# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python logging made (stupidly) simple"
HOMEPAGE="
	https://github.com/Delgan/loguru/
	https://pypi.org/project/loguru/
"
SRC_URI="
	https://github.com/Delgan/loguru/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
		>=dev-python/freezegun-1.5.0[${PYTHON_USEDEP}]
	)
"

# filesystem buffering tests may fail
# on tmpfs with 64k PAGESZ, but pass fine on ext4
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# mypy
	tests/test_type_hinting.py
)

src_prepare() {
	local PATCHES=(
		# https://github.com/Delgan/loguru/commit/84023e2bd8339de95250470f422f096edcb8f7b7
		"${FILESDIR}/${P}-py314.patch"
	)

	distutils-r1_src_prepare

	# neuter mypy integration
	sed -i -e 's:sys.version_info >= (3, 6):False:' tests/conftest.py || die
}
