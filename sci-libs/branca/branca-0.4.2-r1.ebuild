# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="spinoff from folium, host the non-map-specific features"
HOMEPAGE="https://github.com/python-visualization/branca"
SRC_URI="https://github.com/python-visualization/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/${P}-setup.patch
)

RDEPEND="dev-python/jinja[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/selenium[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
	)"
BDEPEND=""

distutils_enable_tests pytest

python_test() {
	epytest -m 'not headless'
}
