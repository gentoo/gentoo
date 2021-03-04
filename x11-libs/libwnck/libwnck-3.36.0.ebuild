# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org flag-o-matic meson xdg

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="https://developer.gnome.org/libwnck/stable/"

LICENSE="LGPL-2+"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"

IUSE="gtk-doc +introspection startup-notification tools"

RDEPEND="
	x11-libs/cairo[X]
	>=dev-libs/glib-2.34:2
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

src_prepare() {
	# Don't collide with SLOT=1 with USE=tools
	sed -e "s|executable(prog|executable(prog + '-3'|" -i libwnck/meson.build || die
	xdg_src_prepare
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
