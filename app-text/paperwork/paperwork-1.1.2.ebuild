# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )

inherit distutils-r1

DESCRIPTION="a personal document manager for scanned documents (and PDFs)"
HOMEPAGE="https://github.com/jflesch/paperwork"
SRC_URI="https://github.com/jflesch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="~app-text/paperwork-backend-${PV}[${PYTHON_USEDEP}]
	dev-python/libpillowfight[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyinsane:2[${PYTHON_USEDEP}]
	>=dev-python/pyocr-0.3.0[${PYTHON_USEDEP}]
	dev-python/simplebayes[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]"
DEPEND="${RDEPEND}"
