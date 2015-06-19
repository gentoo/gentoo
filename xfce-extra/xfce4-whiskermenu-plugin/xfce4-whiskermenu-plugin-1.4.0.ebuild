# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-whiskermenu-plugin/xfce4-whiskermenu-plugin-1.4.0.ebuild,v 1.1 2014/07/01 12:27:20 hasufell Exp $

EAPI=5

inherit gnome2-utils cmake-utils

DESCRIPTION="Alternate application launcher for Xfce"
HOMEPAGE="http://gottcode.org/xfce4-whiskermenu-plugin/"
SRC_URI="http://gottcode.org/xfce4-whiskermenu-plugin/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	xfce-base/exo
	xfce-base/garcon
	xfce-base/libxfce4ui
	xfce-base/libxfce4util
	xfce-base/xfce4-panel
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	local i
	cd po || die
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in *.po ; do
			einfo "removing ${i%.po} linguas"
			has ${i%.po} ${LINGUAS} || { rm ${i} || die ; }
		done
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_AS_NEEDED=OFF
		-DENABLE_LINKER_OPTIMIZED_HASH_TABLES=OFF
		-DENABLE_DEVELOPER_MODE=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc ChangeLog NEWS README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
