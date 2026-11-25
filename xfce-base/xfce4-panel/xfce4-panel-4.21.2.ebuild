# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala xdg-utils

DESCRIPTION="Panel for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-panel/start
	https://gitlab.xfce.org/xfce/xfce4-panel/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+dbusmenu gtk-doc introspection vala wayland X"
REQUIRED_USE="
	|| ( wayland X )
	vala? ( introspection )
"

DEPEND="
	>=dev-libs/glib-2.74.0
	>=x11-libs/cairo-1.16.0
	>=x11-libs/gtk+-3.24.0:3[X?,introspection?,wayland?]
	>=xfce-base/exo-4.18.0:=
	>=xfce-base/garcon-4.18.0:=
	>=xfce-base/libxfce4ui-4.21.3:=
	>=xfce-base/libxfce4util-4.18.0:=[introspection?,vala?]
	>=xfce-base/libxfce4windowing-4.20.1:=[X?]
	>=xfce-base/xfconf-4.18.0:=
	dbusmenu? ( >=dev-libs/libdbusmenu-16.04.0[gtk3] )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	wayland? (
		>=dev-libs/wayland-1.20
		>=gui-libs/gtk-layer-shell-0.7.0
	)
	X? (
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXext-1.0.0
		x11-libs/libwnck:3
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	gtk-doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )
	dev-build/xfce4-dev-tools
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc)
		$(meson_use introspection)
		$(meson_feature vala)
		$(meson_feature X x11)
		$(meson_feature wayland)
		$(meson_feature wayland gtk-layer-shell)
		$(meson_feature dbusmenu)
	)

	use vala && vala_setup
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
