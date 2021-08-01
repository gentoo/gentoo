# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Visual rendering engine for HTML and CSS that can export to PDF"
HOMEPAGE="https://weasyprint.org https://github.com/Kozea/WeasyPrint"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg tiff"

# Note: specific subslot of pango since it inlines some of pango headers.
#	>=dev-python/lxml-3.0[${PYTHON_USEDEP}]
RDEPEND="
	>=dev-python/cffi-0.6:=[${PYTHON_USEDEP}]
	>=dev-python/cssselect2-0.1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pillow-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pydyf-0.0.3[${PYTHON_USEDEP}]
	>=dev-python/pyphen-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/tinycss2-1.0.0[${PYTHON_USEDEP}]
	x11-libs/pango
"

BDEPEND="
	test? (
		media-fonts/ahem
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/addopts/d' pyproject.toml || die
	distutils-r1_src_prepare
}
