# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="CairoSVG"
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="CLI and library to export SVG to PDF, PostScript, and PNG"
HOMEPAGE="
	https://cairosvg.org/
	https://github.com/Kozea/CairoSVG/
	https://pypi.org/project/CairoSVG/
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/cairocffi[${PYTHON_USEDEP}]
	dev-python/cssselect2[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/tinycss2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# this test compares output against old version; this makes little
	# sense for us and requires both distfiles around
	test_non_regression
)

src_prepare() {
	distutils-r1_src_prepare

	# https://github.com/Kozea/CairoSVG/issues/441
	# https://github.com/Kozea/CairoSVG/commit/8ecb0806c4ed0813eb5dc6f27b36d9005acfa725
	sed -i -e 's:console-scripts:console_scripts:' setup.cfg || die
}
