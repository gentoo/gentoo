# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Qt GUI Openbox Configuration Tool"
HOMEPAGE="https://lxqt.github.io/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-2 GPL-2+"
SLOT="0"

BDEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.7.0
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	sys-apps/sed
	x11-wm/openbox:3
	x11-libs/libX11
"
RDEPEND="${DEPEND}
	!lxqt-base/lxqt-l10n
"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
