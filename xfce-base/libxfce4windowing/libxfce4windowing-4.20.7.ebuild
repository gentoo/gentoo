# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson vala

DESCRIPTION="Unified widget and session management libs for Xfce"
HOMEPAGE="https://gitlab.xfce.org/xfce/libxfce4windowing/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0/4.19.6"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="+introspection wayland X vala"
REQUIRED_USE="
	|| ( wayland X )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gtk+-3.24.10:3[X?,introspection?,wayland?]
	>=x11-libs/gdk-pixbuf-2.42.8[introspection?]
	wayland? (
		>=dev-libs/wayland-1.20
	)
	X? (
		>=media-libs/libdisplay-info-0.1.1:=
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXrandr-1.5.0
		>=x11-libs/libwnck-3.14:3
	)
"
DEPEND="
	${RDEPEND}
	wayland? (
		>=dev-libs/wayland-protocols-1.39
	)
"
BDEPEND="
	>=dev-build/xfce4-dev-tools-4.19.2
	dev-lang/perl
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	wayland? (
		>=dev-util/wayland-scanner-1.15
	)
"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		$(meson_feature vala)
		$(meson_feature wayland)
		$(meson_feature X x11)
		-Dtests=false
	)

	meson_src_configure
}
