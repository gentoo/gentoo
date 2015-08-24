# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A simple wrapper for the C qrencode library"
HOMEPAGE="https://pypi.python.org/pypi/qrencode/ https://github.com/Arachnid/pyqrencode/"
SRC_URI="mirror://pypi/q/qrencode/qrencode-${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="Apache-2.0"
IUSE=""

RDEPEND="
	virtual/python-imaging[${PYTHON_USEDEP}]
	media-gfx/qrencode"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/qrencode-${PV}

PATCHES=( "${FILESDIR}"/${P}-PIL.patch )
