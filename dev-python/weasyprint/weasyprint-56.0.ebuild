# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Visual rendering engine for HTML and CSS that can export to PDF"
HOMEPAGE="https://weasyprint.org https://github.com/Kozea/WeasyPrint"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/cffi-0.6:=[${PYTHON_USEDEP}]
	>=dev-python/cssselect2-0.1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/html5lib-1.1[${PYTHON_USEDEP}]
	>=dev-python/pillow-4.0.0[jpeg,jpeg2k,${PYTHON_USEDEP}]
	>=dev-python/pydyf-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyphen-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/tinycss2-1.0.0[${PYTHON_USEDEP}]
	x11-libs/pango
"

BDEPEND="
	test? (
		<app-text/ghostscript-gpl-9.56
		media-fonts/ahem
		media-fonts/dejavu
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/addopts/d' pyproject.toml || die
	distutils-r1_src_prepare
}
