# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Visual rendering engine for HTML and CSS that can export to PDF"
HOMEPAGE="
	https://weasyprint.org/
	https://github.com/Kozea/WeasyPrint/
	https://pypi.org/project/weasyprint/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/cffi-0.6:=[${PYTHON_USEDEP}]
	>=dev-python/cssselect2-0.1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-9.1.0[jpeg,jpeg2k,${PYTHON_USEDEP}]
	>=dev-python/pydyf-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/pyphen-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/tinycss2-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/tinyhtml5-2.0.0[${PYTHON_USEDEP}]
	media-fonts/dejavu
	x11-libs/pango
"

BDEPEND="
	test? (
		>=app-text/ghostscript-gpl-9.56.1-r3
		media-fonts/ahem
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin deps
	sed -i -e 's:,<[0-9.]*::' pyproject.toml || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
