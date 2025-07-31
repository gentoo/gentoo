# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala virtualx xdg

DESCRIPTION="A text widget implementing syntax highlighting and other features"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gtksourceview"

LICENSE="LGPL-2.1+"
SLOT="5"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +introspection sysprof +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.72:2
	>=gui-libs/gtk-4.17:4[introspection?]
	>=dev-libs/libxml2-2.6:2=
	introspection? ( >=dev-libs/gobject-introspection-1.70.0:= )
	>=dev-libs/fribidi-0.19.7
	media-libs/fontconfig
	x11-libs/pango[introspection?]
	>=dev-libs/libpcre2-10.21:=[-recursion-limit(-)]
	sysprof? ( dev-util/sysprof-capture:4 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? ( dev-util/gi-docgen )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dinstall-tests=false
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc documentation)
		$(meson_use sysprof)
	)
	meson_src_configure
}

src_test() {
	# Tests fail in test-regex with libpcre2[recursion-limit] - https://gitlab.gnome.org/GNOME/gtksourceview/-/issues/255
	# Ensured OK via USE dep, as it would mean issues in real usage for syntax highlighting as well
	virtx meson_src_test --timeout-multiplier=5
}

src_install() {
	meson_src_install

	insinto /usr/share/${PN}-5/language-specs
	newins "${FILESDIR}"/5-gentoo.lang gentoo.lang

	if use gtk-doc ; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN}${SLOT} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
