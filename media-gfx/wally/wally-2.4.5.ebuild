# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/wally/wally-2.4.5.ebuild,v 1.2 2015/03/03 23:10:40 hwoarang Exp $

EAPI=5
KDE_REQUIRED="optional"

inherit eutils kde4-base readme.gentoo

DESCRIPTION="A Qt4/KDE4 wallpaper changer"
HOMEPAGE="http://www.becrux.com/index.php?page=projects&name=wally"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug kde"

DEPEND="
	media-libs/libexif
	x11-libs/libX11
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4
	kde? ( $(add_kdebase_dep kdelibs) )
"
RDEPEND="${DEPEND}"

DOCS=(
	"AUTHORS" "ChangeLog" "README" "README.XFCE4"
	"README.shortcuts" "TODO"
)
PATCHES=(
	"${FILESDIR}"/${PN}-2.2.0-disable_popup.patch
)

src_prepare() {
	DOC_CONTENTS="In order to use wallyplugin you need to
		restart plasma in your KDE4 enviroment."
	kde4-base_src_prepare
	use kde || epatch "${FILESDIR}"/${PN}-2.2.0-disable-kde4.patch
}

src_configure() {
	mycmakeargs=(
		-DSTATIC=FALSE
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newicon "${S}"/res/images/idle.png wally.png
	make_desktop_entry wally Wally wally "Graphics;Qt"
	use kde && readme.gentoo_create_doc
}

pkg_postinst() {
	use kde && readme.gentoo_print_elog
}
