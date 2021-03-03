# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 multilib-minimal rust-toolchain vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

IUSE="+introspection +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=x11-libs/cairo-1.16.0[glib,${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.20:2[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.50.0:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.0.0:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.38.0[${MULTILIB_USEDEP}]

	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}
	>=virtual/rust-1.40[${MULTILIB_USEDEP}]
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"
# >=gtk-doc-am-1.13, gobject-introspection-common, vala-common needed by eautoreconf

RESTRICT="test" # Lots of issues on 32bit builds, 64bit build seems to get into an infinite compilation sometimes, etc.

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

multilib_src_configure() {
	local myconf=(
		--disable-static
		--disable-debug
		--disable-tools # the tools/ subdirectory is useful only for librsvg devs
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_enable vala)
		--enable-pixbuf-loader
	)

	if ! multilib_is_native_abi; then
		myconf+=(
			# Set the rust target, which can differ from CHOST
			RUST_TARGET="$(rust_abi)"
			# RUST_TARGET is only honored if cross_compiling, but non-native ABIs aren't cross as
			# far as C parts and configure auto-detection are concerned as CHOST equals CBUILD
			cross_compiling=yes
		)
	fi

	ECONF_SOURCE=${S} \
	gnome2_src_configure "${myconf[@]}"

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_compile() {
	# causes segfault if set, see bug #411765
	unset __GL_NO_DSO_FINALIZER
	gnome2_src_compile
}

multilib_src_install() {
	gnome2_src_install
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_pkg_postinst
}

pkg_postrm() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_pkg_postrm
}
