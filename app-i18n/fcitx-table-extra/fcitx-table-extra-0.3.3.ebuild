# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils gnome2-utils

DESCRIPTION="Extra tables for Fcitx, including Boshiamy, Zhengma, Cangjie and Quick"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="https://fcitx.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.7[table]"
DEPEND="${RDEPEND}
	virtual/libintl"

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
