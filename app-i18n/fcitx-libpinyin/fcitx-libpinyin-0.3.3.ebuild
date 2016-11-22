# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils gnome2-utils

DESCRIPTION="Libpinyin module for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://download.fcitx-im.org/${PN}/${P}_dict.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dictmanager"

RDEPEND=">=app-i18n/fcitx-4.2.8[dbus]
	app-i18n/libpinyin
	dev-libs/glib:2
	sys-apps/dbus
	virtual/libintl
	dictmanager? (
		>=app-i18n/fcitx-4.2.8[qt4]
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs="$(cmake-utils_use_enable dictmanager QT)"
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
