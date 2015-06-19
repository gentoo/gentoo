# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx-libpinyin/fcitx-libpinyin-0.2.1.ebuild,v 1.6 2015/04/19 12:00:15 blueness Exp $

EAPI=5
inherit cmake-utils gnome2-utils

DESCRIPTION="Libpinyin module for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://fcitx.googlecode.com/files/${P}_dict.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.7
	<app-i18n/libpinyin-0.9.0
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/libintl
	virtual/pkgconfig"

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
