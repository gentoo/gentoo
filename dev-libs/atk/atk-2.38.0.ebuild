# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson-multilib xdg

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.38.0:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3 )
	virtual/pkgconfig
	>=sys-devel/gettext-0.19.8
"

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool gtk-doc docs)
		$(meson_native_use_bool introspection)
	)
	meson_src_configure
}
