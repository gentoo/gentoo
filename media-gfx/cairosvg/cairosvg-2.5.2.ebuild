# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_PN="CairoSVG"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CLI and library to export SVG to PDF, PostScript, and PNG"
HOMEPAGE="https://cairosvg.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/cairocffi[${PYTHON_USEDEP}]
	dev-python/cssselect2[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/tinycss2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# junk deps
	sed -e '/pytest-runner/d' \
		-e '/--flake8/d' \
		-e '/--isort/d' \
		-i setup.cfg || die

	# this test compares output against old version; this makes little
	# sense for us and requires both distfiles around
	rm test_non_regression/test_non_regression.py || die
	eapply "${FILESDIR}"/cairosvg-2.5.1-no-ref.patch

	distutils-r1_src_prepare
}
