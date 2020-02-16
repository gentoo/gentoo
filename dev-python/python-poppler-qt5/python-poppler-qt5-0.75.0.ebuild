# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python binding for libpoppler-qt5"
HOMEPAGE="https://github.com/wbsoft/python-poppler-qt5"
SRC_URI="https://github.com/wbsoft/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-text/poppler[qt5]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	>=dev-python/sip-4.19:=[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
