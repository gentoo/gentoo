# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/cairo/cairo.git"
	SRC_URI=""
else
	SRC_URI="https://gitlab.freedesktop.org/cairo/cairo/-/archive/${PV}/cairo-${PV}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="https://www.cairographics.org/ https://gitlab.freedesktop.org/cairo/cairo"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
IUSE="X aqua debug gles2-only gles3 +glib gtk-doc opengl test"
REQUIRED_USE="
	gles2-only? ( !opengl )
	gles3? ( gles2-only )
"
RESTRICT="!test? ( test ) test" # Requires poppler-glib, which isn't available in multilib

RDEPEND="
	>=dev-libs/lzo-2.06-r1:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2[png,${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.36[${MULTILIB_USEDEP}]
	debug? ( sys-libs/binutils-libs:0=[${MULTILIB_USEDEP}] )
	gles2-only? ( >=media-libs/mesa-9.1.6[gles2,${MULTILIB_USEDEP}] )
	glib? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	opengl? ( >=media-libs/mesa-9.1.6[egl(+),X(+),${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.9.1:=[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-respect-fontconfig.patch
)

multilib_src_configure() {
	local emesonargs=(
		-Dfontconfig=enabled
		-Dfreetype=enabled
		-Dpng=enabled
		$(meson_feature aqua quartz)
		$(meson_feature X tee)
		$(meson_feature X xcb)
		$(meson_feature X xlib)
		-Dxlib-xcb=disabled
		-Dxml=disabled
		-Dzlib=enabled

		$(meson_feature test tests)

		-Dgtk2-utils=disabled

		$(meson_feature glib)
		-Dspectre=disabled # only used for tests
		$(meson_feature debug symbol-lookup)

		$(meson_use gtk-doc gtk_doc)
	)

	if use opengl; then
		emesonargs+=(-Dgl-backend=gl)
	elif use gles2-only; then
		if use gles3; then
			emesonargs+=(-Dgl-backend=glesv3)
		else
			emesonargs+=(-Dgl-backend=glesv2)
		fi
	else
		emesonargs+=(-Dgl-backend=disabled)
	fi

	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/cairo || die
		mv "${ED}"/usr/share/gtk-doc/{html/cairo,cairo/html} || die
		rmdir "${ED}"/usr/share/gtk-doc/html || die
	fi
}
