# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit desktop wxwidgets xdg-utils

DESCRIPTION="Utility for viewing Compiled HTML Help (CHM) files"
HOMEPAGE="https://github.com/rzvncj/xCHM/"
SRC_URI="https://github.com/rzvncj/xCHM/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/chmlib-0.36
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

src_configure() {
	setup-wxwidgets
	econf $(use_enable nls)
}

src_install() {
	default

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
