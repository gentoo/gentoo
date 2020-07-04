# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake eutils xdg-utils

DESCRIPTION="Qt GUI Tabbed Filemanager"
HOMEPAGE="https://lxqt.github.io/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-2 GPL-2+ LGPL-2.1+"
SLOT="0"

BDEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.7.0
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

	optfeature "mount password storing" gnome-base/gnome-keyring
	! has_version lxqt-base/lxqt-meta && optfeature "trash functionality" gnome-base/gvfs
}

pkg_postrm() {
	xdg_desktop_database_update
}
