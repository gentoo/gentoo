# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gmapcatcher/gmapcatcher-0.8.0.4.ebuild,v 1.3 2015/04/08 18:49:15 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="An offline viewer for different map providers"
HOMEPAGE="http://code.google.com/p/gmapcatcher/"
SRC_URI="http://gmapcatcher.googlecode.com/files/mapcatcher_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/mapcatcher-${PV}
PATCHES=("${FILESDIR}"/${P}-setuppy-docs.patch)

src_prepare() {
	sed -i -e "/Version=/d" -e "s/Application;//" gmapcatcher.desktop || die
	distutils-r1_src_prepare
}
