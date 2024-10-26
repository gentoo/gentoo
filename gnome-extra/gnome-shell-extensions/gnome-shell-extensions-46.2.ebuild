# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org readme.gentoo-r1 meson xdg

DESCRIPTION="JavaScript extensions for GNOME Shell"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-shell-extensions"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-libs/glib-2.26:2
	>=gnome-base/libgtop-2.28.3[introspection]
	>=app-eselect/eselect-gnome-shell-extensions-20111211
"
RDEPEND="${DEPEND}
	>=app-accessibility/at-spi2-core-2.46.0[introspection]
	>=dev-libs/gjs-1.29
	dev-libs/gobject-introspection:=
	gnome-base/gnome-menus:3[introspection]
	=gnome-base/gnome-shell-$(ver_cut 1)*
	gui-libs/libadwaita[introspection]
	media-libs/clutter:1.0[introspection]
	media-libs/graphene[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	x11-themes/adwaita-icon-theme
	>=x11-wm/mutter-3.32[introspection]
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Installed extensions installed are initially disabled by default.
To change the system default and enable some extensions, you can use
# eselect gnome-shell-extensions

Alternatively, to enable/disable extensions on a per-user basis,
you can use the gnome-extensions-app (included with gnome-shell),
https://extensions.gnome.org/ web interface, or modify the
org.gnome.shell enabled-extensions gsettings key from the command
line or a script."

src_configure() {
	local emesonargs=(
		-Dextension_set=all
		-Dclassic_mode=true
	)
	meson_src_configure
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
