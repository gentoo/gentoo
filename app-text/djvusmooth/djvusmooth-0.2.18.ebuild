# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Graphical editor for DjVu documents"
HOMEPAGE="http://jwilk.net/software/djvusmooth"
SRC_URI="https://github.com/jwilk/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/python-djvulibre[${PYTHON_USEDEP}]
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	x11-themes/hicolor-icon-theme"

DOCS=( doc/changelog doc/credits.txt )
