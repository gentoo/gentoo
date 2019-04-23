# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

MY_PN="CairoSVG"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CLI and library to export SVG to PDF, PostScript, and PNG"
HOMEPAGE="https://cairosvg.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/cairocffi[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/tinycss[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( NEWS.rst README.rst TODO.rst )
