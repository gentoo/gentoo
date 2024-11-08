# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

inherit cmake optfeature xdg

DESCRIPTION="Qt GUI Tabbed Filemanager"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2 GPL-2+ LGPL-2.1+"
SLOT="0"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.1.0
"
DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-6.6:6[dbus,gui,widgets]
	>=kde-plasma/layer-shell-qt-6.0:6
	sys-apps/util-linux
	virtual/freedesktop-icon-theme
	=x11-libs/libfm-qt-${MY_PV}*:=
	x11-libs/libxcb:=
	x11-misc/xdg-utils
"
RDEPEND="${DEPEND}
	=lxqt-base/lxqt-menu-data-${MY_PV}*
"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	optfeature "mount password storing" gnome-base/gnome-keyring
	! has_version lxqt-base/lxqt-meta && optfeature "trash functionality" gnome-base/gvfs
}
