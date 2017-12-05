# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic git-r3

DESCRIPTION="A standalone skill monitoring application for EVE Online"
HOMEPAGE="https://github.com/gtkevemon/gtkevemon"
EGIT_REPO_URI="https://github.com/${PN}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-cpp/gtkmm:3.0
	dev-libs/libxml2
	net-misc/curl[ssl]
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
