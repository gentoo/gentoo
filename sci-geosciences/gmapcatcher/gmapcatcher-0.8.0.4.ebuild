# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit vcs-snapshot distutils-r1

MY_COMMIT_HASH="b3156dc56d105bcab8a1123793dcc16b7f9f3a9a"
DESCRIPTION="An offline viewer for different map providers"
HOMEPAGE="https://github.com/heldersepu/GMapCatcher"
SRC_URI="https://github.com/heldersepu/GMapCatcher/archive/${MY_COMMIT_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}"/${P}-setuppy-docs.patch)

src_prepare() {
	# Move things around to make setup.py happy
	mv installer/setup.py "${S}/" || die
	mv maps.py mapcatcher || die
	mv download.py mapdownloader || die
	mv images/map.png images/mapcatcher.png || die
	sed -i -e "/Version=/d" -e "s/Application;//" gmapcatcher.desktop || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	doman man/mapcatcher.1 man/mapdownloader.1
}
