# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 python-r1

DESCRIPTION="Open Source CAM - Toolpath Generation for 3-Axis CNC machining"
HOMEPAGE="http://pycam.sourceforge.net/"
SRC_URI="https://github.com/SebKuzminsky/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pygtkglext[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/librsvg-python[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
