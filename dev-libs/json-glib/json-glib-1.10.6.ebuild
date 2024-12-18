# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson-multilib xdg-utils

DESCRIPTION="Library providing GLib serialization and deserialization for the JSON format"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="gtk-doc +introspection nls test"
RESTRICT="!test? ( test )"
REQUIRED_USE="gtk-doc? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.72.0:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/docutils
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gi-docgen-2021.6 )
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	xdg_environment_reset
	default
}

multilib_src_configure() {
	local emesonargs=(
		# Never use gi-docgen subproject
		--wrap-mode nofallback
		-Dinstalled_tests=false

		$(meson_native_use_feature introspection)
		$(meson_native_use_feature gtk-doc documentation)
		$(meson_native_true man)

		$(meson_feature nls)
		$(meson_use test tests)
	)
	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	if use gtk-doc ; then
		# TODO: still useful with devhelp 43?
		mkdir -p "${ED}"/usr/share/gtk-doc/html || die
		mv "${ED}"/usr/share/doc/json-glib-1.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
