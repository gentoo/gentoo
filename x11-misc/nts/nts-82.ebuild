# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Note Taking made Simple, an intuitive note taking application"
HOMEPAGE="http://www.duke.edu/~dgraham/NTS/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	|| ( dev-python/docutils[${PYTHON_USEDEP}] app-text/pandoc )
"
