# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gresistor/gresistor-0.0.1.ebuild,v 1.7 2011/04/09 21:40:51 arfrever Exp $

EAPI=3
PYTHON_DEPEND="2:2.5"

inherit distutils eutils

DESCRIPTION="Translate a resistor color codes into a readable value"
HOMEPAGE="http://www.roroid.ro/index.php?option=com_content&view=article&id=1:gresistor&catid=1:software-projects&Itemid=2"
SRC_URI="http://www.roroid.ro/progs/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
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

src_install() {
	distutils_src_install
	newicon pixmaps/icon.png ${PN}.png
	domenu ${PN}.desktop
}
