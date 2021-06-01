# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson multilib-minimal toolchain-funcs xdg

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="https://www.pango.org/"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/pango/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ppc64 sparc x86"

IUSE="gtk-doc +introspection sysprof test X"
RESTRICT="!test? ( test )"
REQUIRED_USE="gtk-doc? ( introspection )"

RDEPEND="
	>=dev-libs/fribidi-0.19.7[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.62.2:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.12.92:1.0=[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2=[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.0:=[glib(+),introspection?,truetype(+),${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.10:=[X?,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	X? (
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.3.1-r1[${MULTILIB_USEDEP}]
		x11-libs/libXrender[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	sysprof? ( dev-util/sysprof-capture:4[${MULTILIB_USEDEP}] )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	dev-util/glib-utils
	sys-apps/help2man
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gi-docgen
		app-text/docbook-xml-dtd:4.2
		app-text/docbook-xml-dtd:4.5
	)
"

src_prepare() {
	xdg_src_prepare
	gnome2_environment_reset
}

multilib_src_configure() {
	local emesonargs=(
		# Never use gi-docgen subproject
		--wrap-mode nofallback

		$(meson_feature sysprof)
		$(meson_feature X xft)
		-Dcairo=enabled
		-Dfontconfig=enabled
		-Dfreetype=enabled
		-Dgtk_doc="$(multilib_native_usex gtk-doc true false)"
		-Dintrospection="$(multilib_native_usex introspection enabled disabled)"
		-Dinstall-tests=false
		-Dlibthai=disabled
	)
	meson_src_configure
}

muiltilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	einstalldocs
	if use gtk-doc; then
		mv "${ED}"/usr/share/doc/{${PN}/reference/,${PF}/html/} || die
		rmdir "${ED}"/usr/share/doc/${PN} || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
