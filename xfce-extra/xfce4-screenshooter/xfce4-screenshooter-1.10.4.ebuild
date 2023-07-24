# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Xfce4 screenshooter application and panel plugin"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-screenshooter/start
	https://gitlab.xfce.org/apps/xfce4-screenshooter/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gdk-pixbuf-2.16
	>=x11-libs/gtk+-3.24.0:3
	>=x11-libs/pango-1.44.0
	dev-libs/libxml2
	>=net-libs/libsoup-3.0.0:3.0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/libXi-1.7.8
	>=xfce-base/exo-0.11:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/glib-utils
	dev-util/intltool
	sys-apps/help2man
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		--enable-xfixes
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
