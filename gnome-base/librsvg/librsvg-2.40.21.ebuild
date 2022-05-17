# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_EAUTORECONF="yes"
VALA_USE_DEPEND="vapigen"

inherit autotools gnome2 multilib-minimal vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="~alpha arm hppa ~ia64 ~loong ~mips ppc ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="+introspection tools +vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libcroco-0.6.8-r1[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.38.0[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
	tools? ( >=x11-libs/gtk+-3.10.0:3 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/gobject-introspection-common
	dev-libs/vala-common
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.13
	virtual/pkgconfig
	x11-libs/gdk-pixbuf
	vala? ( $(vala_depend) )
"
# >=gtk-doc-am-1.13, gobject-introspection-common, vala-common needed by eautoreconf

QA_FLAGS_IGNORED="
	usr/bin/rsvg-convert
	usr/lib.*/librsvg.*
"

RESTRICT="test" # Lots of issues due to freetype changes and more; ever since newer tests got backported into 2.40.19

PATCHES=(
	# https://bugzilla.gnome.org/show_bug.cgi?id=653323
	"${FILESDIR}/${PN}-2.40.12-gtk-optional.patch"
)

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

multilib_src_configure() {
	local myconf=(
		--disable-static
		--disable-tools  # only useful for librsvg developers
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_with tools gtk3)
		$(multilib_native_use_enable vala)
		--enable-pixbuf-loader
	)

	# -Bsymbolic is not supported by the Darwin toolchain
	[[ ${CHOST} == *-darwin* ]] && myconf+=( --disable-Bsymbolic )

	ECONF_SOURCE=${S} gnome2_src_configure "${myconf[@]}"

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
