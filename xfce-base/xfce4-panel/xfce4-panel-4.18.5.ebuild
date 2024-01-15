# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vala xdg-utils

DESCRIPTION="Panel for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-panel/start
	https://gitlab.xfce.org/xfce/xfce4-panel/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="+dbusmenu introspection vala"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/cairo-1.16.0
	>=x11-libs/gtk+-3.24.0:3[introspection?]
	x11-libs/libX11
	x11-libs/libwnck:3
	>=xfce-base/exo-0.11.2:=
	>=xfce-base/garcon-4.17.0:=
	>=xfce-base/libxfce4ui-4.17.1:=
	>=xfce-base/libxfce4util-4.17.2:=[introspection?,vala?]
	>=xfce-base/xfconf-4.13:=
	dbusmenu? ( >=dev-libs/libdbusmenu-16.04.0[gtk3] )
	introspection? ( >=dev-libs/gobject-introspection-1.66:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	vala? ( $(vala_depend) )
	dev-lang/perl
	dev-util/gdbus-codegen
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable dbusmenu dbusmenu-gtk3)
		$(use_enable vala)
	)

	use vala && vala_setup
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
