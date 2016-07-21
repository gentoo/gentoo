# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="An offline viewer for different map providers"
HOMEPAGE="https://code.google.com/p/gmapcatcher/"
SRC_URI="https://gmapcatcher.googlecode.com/files/mapcatcher_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/mapcatcher-${PV}
PATCHES=("${FILESDIR}"/${P}-setuppy-docs.patch)

src_prepare() {
	sed -i -e "/Version=/d" -e "s/Application;//" gmapcatcher.desktop || die
	distutils-r1_src_prepare
}
