# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/deeplook/svglib
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python library for reading and converting SVG"
HOMEPAGE="
	https://github.com/deeplook/svglib/
	https://pypi.org/project/svglib/
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/cssselect2-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/reportlab-4.4.3[${PYTHON_USEDEP}]
	>=dev-python/tinycss2-0.6.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Needs network access
	tests/test_samples.py::TestWikipediaFlags::test_convert_pdf
	tests/test_samples.py::TestW3CSVG::test_convert_pdf_png
)

src_prepare() {
	distutils-r1_src_prepare

	# unnecessary listed as required
	sed -i -e '/rlpycairo/d' pyproject.toml || die
}
