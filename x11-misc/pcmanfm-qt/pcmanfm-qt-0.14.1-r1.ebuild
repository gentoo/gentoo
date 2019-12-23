# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
fi

DESCRIPTION="Fast lightweight tabbed filemanager (Qt port)"
HOMEPAGE="https://lxqt.org/"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

BDEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.6.0
"
DEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	=x11-libs/libfm-qt-$(ver_cut 1-2)*
	x11-libs/libxcb:=
	x11-misc/xdg-utils
	virtual/eject
	virtual/freedesktop-icon-theme
"
RDEPEND="${DEPEND}
	!lxqt-base/lxqt-l10n
"

pkg_postinst() {
	xdg_desktop_database_update

	if ! has_version lxqt-base/lxqt-meta && ! has_version gnome-base/gvfs; then
		elog
		elog "To make use of the 'trash' functionality, please install"
		elog "the 'gnome-base/gvfs' package."
		elog
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
