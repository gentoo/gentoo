# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A calendar application for Xfce"
HOMEPAGE="
	https://docs.xfce.org/apps/orage/start
	https://gitlab.xfce.org/apps/orage/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv x86"
IUSE="libnotify"

DEPEND="
	>=dev-libs/glib-2.58.0
	>=dev-libs/libical-3.0.16:=
	>=x11-libs/gtk+-3.24.0:3=
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	libnotify? ( >=x11-libs/libnotify-0.7.0:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-util/intltool-0.35
	sys-devel/gettext
	>=dev-build/libtool-2.2.6
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable libnotify)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
