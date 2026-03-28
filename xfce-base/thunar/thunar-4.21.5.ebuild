# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="File manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/thunar/start
	https://gitlab.xfce.org/xfce/thunar/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="
	X exif gtk-doc introspection libnotify pcre policykit
	+trash-panel-plugin udisks terminal
"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gdk-pixbuf-2.42.8
	>=x11-libs/gtk+-3.24.0:3[X?]
	>=x11-libs/pango-1.38.0
	>=xfce-base/libxfce4ui-4.21.2:=
	>=xfce-base/libxfce4util-4.17.2:=
	>=xfce-base/xfconf-4.12.0:=
	exif? ( >=media-libs/gexiv2-0.14.0 )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	pcre? ( >=dev-libs/libpcre2-10.0:= )
	trash-panel-plugin? ( >=xfce-base/xfce4-panel-4.14.0:= )
	udisks? ( >=dev-libs/libgudev-145:= )
	terminal? ( >=x11-libs/vte-0.70:= )
	X? (
		>=x11-libs/libICE-1.0.10
		>=x11-libs/libSM-1.2.3
		>=x11-libs/libX11-1.6.7
	)
"
RDEPEND="
	${DEPEND}
	>=dev-util/desktop-file-utils-0.20-r1
	x11-misc/shared-mime-info
	trash-panel-plugin? (
		>=gnome-base/gvfs-1.18.3
	)
	udisks? (
		>=gnome-base/gvfs-1.18.3[udisks,udev]
		virtual/udev
	)
"
# TODO: should this be BDEPEND too?
# https://gitlab.xfce.org/xfce/thunar/-/commit/3b57f79dabdcd52aac8c183530e07fc2ff172958
DEPEND+="
	policykit? ( sys-auth/polkit )
"
# glib for glib-compile-resources
BDEPEND="
	dev-build/xfce4-dev-tools
	>=dev-libs/glib-2.72.0
	dev-libs/libxml2
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc)
		$(meson_use introspection)
		$(meson_feature X x11)
		$(meson_feature X session-management)
		-Dgio-unix=enabled
		$(meson_feature udisks gudev)
		$(meson_feature libnotify)
		$(meson_feature policykit polkit)
		$(meson_feature terminal)
		-Dthunar-apr=enabled
		-Dthunar-sbr=enabled
		$(meson_feature exif gexiv2)
		$(meson_feature pcre pcre2)
		$(meson_feature trash-panel-plugin thunar-tpa)
		-Dthunar-uca=enabled
		-Dthunar-wallpaper=enabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/usr/share/doc/{thunar,${PF}} || die
}

pkg_postinst() {
	elog "If you were using an older Xfce version and Thunar fails to start"
	elog "with a message similar to:"
	elog "  Failed to register: Timeout was reached"
	elog "you may need to reset your xfce4 session:"
	elog "  rm ~/.cache/sessions/xfce4-session-*"
	elog "See https://bugs.gentoo.org/698914."

	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
