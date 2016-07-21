# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2:2.5"

inherit distutils eutils

DESCRIPTION="Translate a resistor color codes into a readable value"
HOMEPAGE="http://www.roroid.ro/index.php?option=com_content&view=article&id=1:gresistor&catid=1:software-projects&Itemid=2"
SRC_URI="http://www.roroid.ro/progs/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/pygtk:2
	x11-libs/gtk+:2
	gnome-base/libglade:2.0"
RDEPEND="${DEPEND}"

DOCS=(
	"README"
)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# fix typoes. Bug #416467
	sed -i "s:Sylver:Silver:" ${PN} ${PN}.glade || die
}

src_install() {
	distutils_src_install
	newicon pixmaps/icon.png ${PN}.png
	domenu ${PN}.desktop
}
