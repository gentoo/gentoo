# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="LeechCraft WM and compositor manager"

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

pkg_postinst() {
	elog "fenet supports the following in addition to what's installed:"
	optfeature "awesome window manager" x11-wm/awesome
	optfeature "kwin window manager" kde-plasma/kwin
	optfeature "openbox window manager" x11-wm/openbox
	optfeature "compton compositor" x11-misc/compton
}
