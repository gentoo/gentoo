# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Pure-Python library for reading and converting SVG"
HOMEPAGE="
	https://github.com/deeplook/svglib/
	https://pypi.org/project/svglib/
"
SRC_URI="
	https://github.com/deeplook/svglib/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/cssselect2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/tinycss2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Needs network access
	tests/test_samples.py::TestWikipediaFlags::test_convert_pdf
	tests/test_samples.py::TestW3CSVG::test_convert_pdf_png
)
