# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit wxwidgets xdg

DESCRIPTION="Frontend and .dmod installer for GNU FreeDink"
HOMEPAGE="http://www.freedink.org/"
SRC_URI="mirror://gnu/freedink/${P}.tar.gz"

LICENSE="GPL-3 BZIP2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	app-arch/bzip2
	x11-misc/xdg-utils
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( dev-util/intltool )"

PATCHES=( "${FILESDIR}"/${PN}-3.12-nowindres.patch )

src_configure() {
	setup-wxwidgets
	econf \
		$(use_enable nls) \
		--disable-desktopfiles \
		--with-wx-config="${WX_CONFIG}"
}

src_install() {
	default
	dodoc TRANSLATIONS.txt
}
