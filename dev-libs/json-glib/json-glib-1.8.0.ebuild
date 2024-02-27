# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson-multilib xdg-utils

DESCRIPTION="Library providing GLib serialization and deserialization for the JSON format"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="gtk-doc +introspection nls test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.54.0:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
DEPEND="${RDEPEND}"
# TODO: Can we use a newer docbook-xml-dtd, or is one needed at all?
BDEPEND="
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gi-docgen-2021.6 )
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

src_prepare() {
	xdg_environment_reset
	default

	# Disable installed-tests; this also indirectly removes
	# build_aux/gen-installed-test.py calls, thus not needing
	# python-any-r1.eclass
	sed -e 's/install: true/install: false/g' -i json-glib/tests/meson.build || die
	sed -e '/install_data/d' -i json-glib/tests/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		# Never use gi-docgen subproject
		--wrap-mode nofallback

		$(meson_native_use_feature introspection)
		$(meson_native_use_feature gtk-doc gtk_doc)
		$(meson_native_true man)

		$(meson_feature nls)
		$(meson_use test tests)
	)
	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	if use gtk-doc ; then
		# Move to location that <devhelp-41 will see, reconsider once devhelp-41 is stable
		mkdir -p "${ED}"/usr/share/gtk-doc/html || die
		mv "${ED}"/usr/share/doc/json-glib-1.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
