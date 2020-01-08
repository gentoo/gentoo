# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson multilib-minimal xdg

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54.0:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3 )
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	>=sys-devel/gettext-0.19.8
"

multilib_src_configure() {
	local emesonargs=(
		-Ddocs=$(multilib_native_usex gtk-doc true false)
		-Dintrospection=$(multilib_native_usex introspection true false)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
