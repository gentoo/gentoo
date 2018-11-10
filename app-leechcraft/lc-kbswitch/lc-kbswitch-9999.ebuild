# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils leechcraft

DESCRIPTION="Provides plugin- or tab-grained keyboard layout control"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtdeclarative:5[widgets]
"
RDEPEND="${DEPEND}
	x11-apps/setxkbmap
	"

pkg_postinst() {
	elog "Consider installing the following for additional features:"
	optfeature "display layout indicator in LeechCraft tray" virtual/leechcraft-quark-sideprovider
}
