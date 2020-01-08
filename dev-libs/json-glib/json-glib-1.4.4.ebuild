# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org meson multilib-minimal xdg-utils

DESCRIPTION="Library providing GLib serialization and deserialization for the JSON format"
HOMEPAGE="https://wiki.gnome.org/Projects/JsonGlib"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.44.0:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
# TODO: Can we use a newer docbook-xml-dtd, or is one needed at all?
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.20 )
	>=sys-devel/gettext-0.18
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

src_prepare() {
	xdg_environment_reset
	default
	# Disable installed-tests; this also indirectly removes build_aux/gen-installed-test.py calls, thus not needing python-any-r1.eclass
	sed -e 's/install: true/install: false/g' -i json-glib/tests/meson.build || die
	sed -e '/install_data/d' -i json-glib/tests/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		-Dintrospection=$(multilib_native_usex introspection true false)
		-Ddocs=$(multilib_native_usex gtk-doc true false)
		-Dman=true
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_test() {
	meson_src_test
}
