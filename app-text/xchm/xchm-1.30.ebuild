# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0-gtk3"
inherit wxwidgets xdg-utils

DESCRIPTION="Utility for viewing Compiled HTML Help (CHM) files"
HOMEPAGE="https://github.com/rzvncj/xCHM/"
SRC_URI="${HOMEPAGE}releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="
	>=dev-libs/chmlib-0.36
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	nls? ( virtual/libintl )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_prepare() {
	setup-wxwidgets
	default
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	dodoc AUTHORS README ChangeLog

	domenu "${FILESDIR}"/xchm.desktop
	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/xchm.xml
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
