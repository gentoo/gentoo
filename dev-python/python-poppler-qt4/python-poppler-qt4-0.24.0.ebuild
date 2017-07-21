# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A python binding for libpoppler-qt4"
HOMEPAGE="https://github.com/wbsoft/python-poppler-qt4"
SRC_URI="https://github.com/wbsoft/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-text/poppler:=[qt4]
	dev-python/PyQt4[${PYTHON_USEDEP}]
	dev-python/sip:=[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
