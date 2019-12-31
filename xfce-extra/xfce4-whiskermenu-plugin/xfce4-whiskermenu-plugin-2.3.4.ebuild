# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg-utils

DESCRIPTION="Alternate application launcher for Xfce"
HOMEPAGE="https://gottcode.org/xfce4-whiskermenu-plugin/"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	virtual/libintl
	x11-libs/gtk+:3
	xfce-base/exo:=
	xfce-base/garcon:=
	xfce-base/libxfce4ui:=
	xfce-base/libxfce4util:=
	xfce-base/xfce4-panel:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# fix build failure w/ xfce4-panel-4.15.0
	sed -i -e 's@<libxfce4panel/xfce-panel-plugin\.h>@<libxfce4panel/libxfce4panel.h>@' \
		panel-plugin/register-plugin.c || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_AS_NEEDED=OFF
		-DENABLE_LINKER_OPTIMIZED_HASH_TABLES=OFF
		-DENABLE_DEVELOPER_MODE=OFF
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
