# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/djvusmooth/djvusmooth-0.2.14.ebuild,v 1.1 2013/02/28 16:33:36 pinkbyte Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Graphical editor for DjVu documents"
HOMEPAGE="http://jwilk.net/software/djvusmooth"
SRC_URI="mirror://pypi/d/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: check with wxpython:2.9
RDEPEND="dev-python/python-djvulibre[${PYTHON_USEDEP}]
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	x11-themes/hicolor-icon-theme"
DEPEND=""
