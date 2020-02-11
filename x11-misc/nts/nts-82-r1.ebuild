# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Note Taking made Simple, an intuitive note taking application"
HOMEPAGE="http://www.duke.edu/~dgraham/NTS/"
SRC_URI="http://www.duke.edu/~dgraham/NTS/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	|| ( dev-python/docutils[${PYTHON_USEDEP}] app-text/pandoc )
"
