# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2:2.6"
inherit python

DESCRIPTION="A menu generation program for fluxbox, waimea, openbox, icewm, gnome and kde"
HOMEPAGE="http://denu.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.4.1"
DEPEND="${RDEPEND}"

src_install() {
	./install.sh "${D}" || die "./install.sh failed"
	python_convert_shebangs -r 2 "${D}"
}
