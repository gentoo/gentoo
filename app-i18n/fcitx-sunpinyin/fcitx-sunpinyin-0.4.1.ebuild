# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx-sunpinyin/fcitx-sunpinyin-0.4.1.ebuild,v 1.4 2015/05/01 05:53:06 jer Exp $

EAPI=5

inherit cmake-utils gnome2-utils

DESCRIPTION="Sunpinyin module for fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://download.fcitx-im.org/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.8
	>app-i18n/sunpinyin-2.0.3"
DEPEND="${RDEPEND}
	virtual/libintl"

src_prepare() {
	epatch_user
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
