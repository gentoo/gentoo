# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx-configtool/fcitx-configtool-0.4.6.ebuild,v 1.6 2015/04/19 11:58:33 blueness Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="A GTK+ GUI configuration tool for fcitx"
HOMEPAGE="http://fcitx-im.org/"
SRC_URI="http://fcitx.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="gtk +gtk3"
REQUIRED_USE="|| ( gtk gtk3 )"

RDEPEND=">=app-i18n/fcitx-4.2.7
	dev-libs/glib:2
	gtk? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3	)"
DEPEND="${RDEPEND}
	app-text/iso-codes
	dev-libs/libunique:1
	dev-util/intltool
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable gtk GTK2)
		$(cmake-utils_use_enable gtk3 GTK3)"
	cmake-utils_src_configure
}
