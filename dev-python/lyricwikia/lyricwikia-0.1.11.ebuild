# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python API to get song lyrics from LyricWikia"
HOMEPAGE="https://github.com/enricobacis/lyricwikia"
SRC_URI="https://github.com/enricobacis/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/pytest-runner[${PYTHON_USEDEP}]
		test? ( dev-python/responses[${PYTHON_USEDEP}] )"

RDEPEND="
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

PATCHES="${FILESDIR}/${P}-skip-online-test.patch"

distutils_enable_tests pytest
