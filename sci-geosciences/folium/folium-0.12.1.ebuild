# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
inherit distutils-r1

DESCRIPTION="Python Data, Leaflet.js Maps"
HOMEPAGE="https://github.com/python-visualization/folium"
SRC_URI="https://github.com/python-visualization/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-scm.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-setup.patch
)

RDEPEND="sci-libs/branca[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
	)"
BDEPEND=""

distutils_enable_tests pytest

src_prepare() {
	rm -r tests/selenium || die
	default
}
