# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils gnome2-utils

DESCRIPTION="Vietnamese Unikey module for Fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://download.fcitx-im.org/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE="+qt4"

RDEPEND=">=app-i18n/fcitx-4.2.8[qt4?]"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable qt4 QT)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
