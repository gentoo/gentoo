# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic

DESCRIPTION="A standalone skill monitoring application for EVE Online"
HOMEPAGE="http://gtkevemon.battleclinic.com"
SRC_URI="http://github.com/gtkevemon/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-cpp/gtkmm:2.4
	dev-libs/libxml2
	dev-libs/openssl:0
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"
src_prepare() {
	default

	sed -e 's:Categories=Game;$:Categories=Game;RolePlaying;GTK;:' \
		-i "icon/${PN}.desktop" \
		|| die "failed fix categories in icon/${PN}.desktop"

	# Fixes a QA notice.
	sed -i "/^Encoding/d" "icon/${PN}.desktop" \
		|| die "failed to remove the Encoding from icon/${PN}.desktop"

	append-cxxflags -std=c++11
}

src_install() {
	dobin "src/${PN}"
	doicon "icon/${PN}.svg"
	domenu "icon/${PN}.desktop"
	einstalldocs
}
