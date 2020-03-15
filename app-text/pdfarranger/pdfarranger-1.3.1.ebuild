# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Merge or split pdfs; rearrange, rotate, crop pages."
HOMEPAGE="https://github.com/jeromerobert/pdfarranger"
SRC_URI="https://github.com/jeromerobert/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="dev-python/pikepdf[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
	dev-python/pycairo[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	app-text/poppler[introspection,cairo]"
DEPEND="${RDEPEND}
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]"
