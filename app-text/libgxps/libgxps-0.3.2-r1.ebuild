# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson xdg-utils

DESCRIPTION="Library for handling and rendering XPS documents"
HOMEPAGE="https://wiki.gnome.org/Projects/libgxps"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="gtk-doc +introspection jpeg lcms tiff"

RDEPEND="
	>=app-arch/libarchive-2.8
	>=dev-libs/glib-2.36:2
	media-libs/freetype:2
	media-libs/libpng:0
	>=x11-libs/cairo-1.10[svg(+)]
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	lcms? ( media-libs/lcms:2 )
	tiff? ( media-libs/tiff:0[zlib] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	gtk-doc? ( dev-util/gtk-doc )
	virtual/pkgconfig
"

# There is no automatic test suite, only an interactive test application
RESTRICT="test"

src_configure() {
	local emesonargs=(
		-Denable-test=false
		$(meson_use gtk-doc enable-gtk-doc)
		-Denable-man=true
		-Ddisable-introspection=$(usex introspection false true)
		$(meson_use lcms with-liblcms2)
		$(meson_use jpeg with-libjpeg)
		$(meson_use tiff with-libtiff)
	)

	xdg_environment_reset
	meson_src_configure
}
