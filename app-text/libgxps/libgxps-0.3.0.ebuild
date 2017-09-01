# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org meson xdg-utils

DESCRIPTION="Library for handling and rendering XPS documents"
HOMEPAGE="https://wiki.gnome.org/Projects/libgxps"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ia64 ~ppc ~ppc64 ~x86"
IUSE="+introspection jpeg lcms tiff"

RDEPEND="
	>=app-arch/libarchive-2.8
	>=dev-libs/glib-2.36:2
	media-libs/freetype:2
	media-libs/libpng:0
	>=x11-libs/cairo-1.10[svg]
	introspection? ( >=dev-libs/gobject-introspection-0.10.1:= )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	tiff? ( media-libs/tiff:0[zlib] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

# There is no automatic test suite, only an interactive test application
RESTRICT="test"

src_configure() {
	local emesonargs=(
		-Denable-test=false
		-Denable-gtk-doc=false
		-Denable-man=true
		-Ddisable-introspection=$(usex introspection false true)
		-Dwith-liblcms2=$(usex lcms true false)
		-Dwith-libjpeg=$(usex jpeg true false)
		-Dwith-libtiff=$(usex tiff true false)
	)

	xdg_environment_reset
	meson_src_configure
}
