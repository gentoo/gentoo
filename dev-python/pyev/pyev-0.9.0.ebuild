# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Python libev interface, an event loop"
HOMEPAGE="https://pypi.python.org/pypi/pyev/"
SRC_URI="mirror://pypi/p/pyev/${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND="dev-libs/libev"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

HTML_DOCS=( doc/. )
