# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org readme.gentoo-r1 meson xdg

DESCRIPTION="JavaScript extensions for GNOME Shell"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell/Extensions"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	>=dev-libs/glib-2.26:2
	>=gnome-base/libgtop-2.28.3[introspection]
	>=app-eselect/eselect-gnome-shell-extensions-20111211
"
RDEPEND="${DEPEND}
	>=dev-libs/gjs-1.29
	dev-libs/gobject-introspection:=
	dev-libs/atk[introspection]
	gnome-base/gnome-menus:3[introspection]
	=gnome-base/gnome-shell-$(ver_cut 1-2)*
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	x11-themes/adwaita-icon-theme
	>=x11-wm/mutter-3.32[introspection]
"
BDEPEND="
	dev-lang/sassc
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Installed extensions installed are initially disabled by default.
To change the system default and enable some extensions, you can use
# eselect gnome-shell-extensions

Alternatively, to enable/disable extensions on a per-user basis,
you can use the https://extensions.gnome.org/ web interface, the
gnome-extra/gnome-tweaks GUI, or modify the org.gnome.shell
enabled-extensions gsettings key from the command line or a script."

src_configure() {
	meson_src_configure \
		-Dextension_set=all \
		-Dclassic_mode=true
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst

	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?

	readme.gentoo_print_elog
}
