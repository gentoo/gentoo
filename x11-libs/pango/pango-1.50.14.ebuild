# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome2-utils meson-multilib xdg

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="https://www.pango.org/ https://gitlab.gnome.org/GNOME/pango"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/pango/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE="debug +introspection sysprof test X"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.62.2:2[${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-1.0.6[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.6.0:=[glib(+),introspection?,truetype(+),${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.13.0:1.0=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.10:=[X?,${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2=[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.3.1-r1[${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}] )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	dev-util/glib-utils
	sys-apps/help2man
	virtual/pkgconfig
	test? ( media-fonts/cantarell )
"

src_prepare() {
	default
	xdg_environment_reset
	gnome2_environment_reset
}

multilib_src_configure() {
	if use debug; then
		append-cflags -DPANGO_ENABLE_DEBUG
	else
		append-cflags -DG_DISABLE_CAST_CHECKS
	fi

	local emesonargs=(
		# Never use gi-docgen subproject
		--wrap-mode nofallback

		-Dgtk_doc=false # we ship pregenerated docs
		$(meson_native_use_feature introspection)
		-Dinstall-tests=false
		-Dfontconfig=enabled
		$(meson_feature sysprof)
		-Dlibthai=disabled
		-Dcairo=enabled
		$(meson_feature X xft)
		-Dfreetype=enabled
	)
	meson_src_configure
}

multilib_src_install_all() {
	insinto /usr/share/gtk-doc/html
	# This will install PangoXft API docs regardless of USE=-X, but this is intentional
	doins -r "${S}"/docs/Pango*
}

pkg_postinst() {
	xdg_pkg_postinst

	if has_version 'media-libs/freetype[-harfbuzz]' ; then
		ewarn "media-libs/freetype is installed without harfbuzz support. This may"
		ewarn "lead to minor font rendering problems, see bug 712374."
	fi
}
