# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils gnome2 multilib-minimal vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="+introspection tools +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.38.0[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=dev-libs/libcroco-0.6.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
	tools? ( >=x11-libs/gtk+-3.10.0:3 )
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
	dev-libs/vala-common
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.13
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	vala? ( $(vala_depend) )
"
# >=gtk-doc-am-1.13, gobject-introspection-common, vala-common needed by eautoreconf

RESTRICT="test" # Lots of issues due to freetype changes and more; ever since newer tests got backported into 2.40.19

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=653323
	eapply "${FILESDIR}/${PN}-2.40.12-gtk-optional.patch"

	eautoreconf

	use vala && vala_src_prepare
	gnome2_src_prepare
}

multilib_src_configure() {
	local myconf=()

	# -Bsymbolic is not supported by the Darwin toolchain
	if [[ ${CHOST} == *-darwin* ]]; then
		myconf+=( --disable-Bsymbolic )
	fi

	# --disable-tools even when USE=tools; the tools/ subdirectory is useful
	# only for librsvg developers
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--disable-tools \
		$(multilib_native_use_enable introspection) \
		$(multilib_native_use_with tools gtk3) \
		$(multilib_native_use_enable vala) \
		--enable-pixbuf-loader \
		"${myconf[@]}"

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
