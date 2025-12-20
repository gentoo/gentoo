# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils vala

DESCRIPTION="Unified widget and session management libs for Xfce"
HOMEPAGE="
	https://docs.xfce.org/xfce/libxfce4ui/start
	https://gitlab.xfce.org/xfce/libxfce4ui/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="glade gtk-doc +introspection startup-notification system-info vala wayland X"
REQUIRED_USE="
	|| ( wayland X )
	vala? ( introspection )
"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gdk-pixbuf-2.42.8
	>=x11-libs/gtk+-3.24.0:3[introspection?,wayland?,X?]
	>=xfce-base/libxfce4util-4.17.2:=[introspection?,vala?]
	>=xfce-base/xfconf-4.12.0:=
	glade? ( >=dev-util/glade-3.5.0:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 )
	system-info? (
		>=dev-libs/libgudev-232
		>=gnome-base/libgtop-2.24.0
		>=media-libs/libepoxy-1.2
	)
	X? (
		>=x11-libs/libICE-1.0.10
		>=x11-libs/libSM-1.2.3
		>=x11-libs/libX11-1.6.7
		startup-notification? ( >=x11-libs/startup-notification-0.4 )
	)
"
RDEPEND="
	${DEPEND}
"
DEPEND+="
	x11-base/xorg-proto
"
BDEPEND="
	dev-build/xfce4-dev-tools
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc)
		$(meson_use introspection)
		$(meson_feature vala)
		$(meson_feature X x11)
		$(meson_feature wayland)
		$(meson_feature X session-management)
		$(meson_feature startup-notification)
		$(meson_feature system-info libgtop)
		$(meson_feature system-info epoxy)
		$(meson_feature system-info gudev)
		$(meson_feature glade)
		-Dvendor-info=Gentoo
	)

	use vala && vala_setup
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
