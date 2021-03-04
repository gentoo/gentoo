# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson multilib-minimal

DESCRIPTION="Deprecated Xlib integration for GdkPixbuf"
HOMEPAGE="https://gitlab.gnome.org/Archive/gdk-pixbuf-xlib"
LICENSE="LGPL-2+ MPL-1.1"
SLOT="0"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="gtk-doc"

RDEPEND="
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.42.0[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? (
		app-text/docbook-xml-dtd:4.3
		>=dev-util/gtk-doc-1.20
	)
"

multilib_src_configure() {
	local emesonargs=(
		-Dgtk-doc="$(multilib_native_usex gtk-doc true false)"
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}
