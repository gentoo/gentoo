# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/cairo/cairo.git"
else
	SRC_URI="https://gitlab.freedesktop.org/cairo/cairo/-/archive/${PV}/cairo-${PV}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="https://www.cairographics.org/ https://gitlab.freedesktop.org/cairo/cairo"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
IUSE="X aqua debug +glib gtk-doc test"
# Tests need more wiring up like e.g. https://gitlab.freedesktop.org/cairo/cairo/-/blob/master/.gitlab-ci.yml
# any2ppm tests seem to hang for now.
RESTRICT="test !test? ( test )"

RDEPEND="
	>=dev-libs/lzo-2.06-r1:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.13.92[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.13:2[png,${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.42.3[${MULTILIB_USEDEP}]
	debug? ( sys-libs/binutils-libs:0=[${MULTILIB_USEDEP}] )
	glib? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.9.1:=[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	test? (
		app-text/ghostscript-gpl
		app-text/poppler[cairo]
		gnome-base/librsvg
	)
	X? ( x11-base/xorg-proto )"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )"

PATCHES=(
	"${FILESDIR}"/${PN}-respect-fontconfig.patch
	"${FILESDIR}"/${P}-cups.patch
)

multilib_src_configure() {
	local emesonargs=(
		-Ddwrite=disabled
		-Dfontconfig=enabled
		-Dfreetype=enabled
		-Dpng=enabled
		$(meson_feature aqua quartz)
		$(meson_feature X tee)
		$(meson_feature X xcb)
		$(meson_feature X xlib)
		-Dxlib-xcb=disabled
		-Dzlib=enabled

		# Requires poppler-glib (poppler[cairo]) which isn't available in multilib
		$(meson_native_use_feature test tests)

		-Dgtk2-utils=disabled

		$(meson_feature glib)
		-Dspectre=disabled # only used for tests
		$(meson_feature debug symbol-lookup)

		$(meson_use gtk-doc gtk_doc)
	)

	meson_src_configure
}

multilib_src_test() {
	multilib_is_native_abi && meson_src_test
}

multilib_src_install_all() {
	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/cairo || die
		mv "${ED}"/usr/share/gtk-doc/{html/cairo,cairo/html} || die
		rmdir "${ED}"/usr/share/gtk-doc/html || die
	fi
}
