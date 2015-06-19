# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gresistor/gresistor-0.0.1-r2.ebuild,v 1.1 2015/02/26 15:27:04 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Translate a resistor color codes into a readable value"
HOMEPAGE="http://www.roroid.ro/index.php?option=com_content&view=article&id=1:gresistor&catid=1:software-projects&Itemid=2"
SRC_URI="http://www.roroid.ro/progs/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	x11-libs/gtk+:2
	gnome-base/libglade:2.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-single-r1_pkg_setup
}

python_prepare_all() {
	# fix typoes. Bug #416467
	sed -i "s:Sylver:Silver:" ${PN} ${PN}.glade || die
	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install
	newicon pixmaps/icon.png ${PN}.png
	domenu ${PN}.desktop
}
