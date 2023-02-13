# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="https://developer.gnome.org/libwnck/stable/"

LICENSE="LGPL-2+"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"

IUSE="gtk-doc +introspection startup-notification tools"

RDEPEND="
	x11-libs/cairo[X]
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.22:3[X,introspection?]
	startup-notification? ( >=x11-libs/startup-notification-0.4 )
	x11-libs/libX11
	x11-libs/libXres
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
"
# libXi header used by wnckprop.c, which is compiled even with USE=-tools (just not installed then)
DEPEND="${RDEPEND}
	x11-libs/libXi"
BDEPEND="
	gtk-doc? ( >=dev-util/gtk-doc-1.9
		app-text/docbook-xml-dtd:4.1.2 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# https://gitlab.gnome.org/GNOME/libwnck/-/issues/154
	"${FILESDIR}/${P}-xres-extension.patch"

	# https://gitlab.gnome.org/GNOME/libwnck/-/issues/155
	"${FILESDIR}/${P}-segfault_in_invalidate_icons.patch"
)

src_prepare() {
	default
	xdg_environment_reset
	# Don't collide with SLOT=1 with USE=tools
	sed -e "s|executable(prog|executable(prog + '-3'|" -i libwnck/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddeprecation_flags=false
		$(meson_use tools install_tools)
		$(meson_feature startup-notification startup_notification)
		$(meson_feature introspection)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}
