# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx-anthy/fcitx-anthy-0.1.1.ebuild,v 1.5 2015/04/19 11:49:09 blueness Exp $

EAPI=5
inherit cmake-utils gnome2-utils

DESCRIPTION="Japanese Anthy module for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://fcitx.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.5
	app-i18n/anthy"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/libintl"

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
