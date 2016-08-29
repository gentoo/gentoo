# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 eutils

DESCRIPTION="Translate a resistor color codes into a readable value"
HOMEPAGE="https://sourceforge.net/projects/gresistor/"
SRC_URI="mirror://sourceforge/gresistor/${P}.tar.gz"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	x11-libs/gtk+:2
	gnome-base/libglade:2.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/Version=0.0.2/Version=1.0/g' ${PN}.desktop || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	python_domodule "${FILESDIR}/SimpleGladeApp.py"
	domenu ${PN}.desktop
}
