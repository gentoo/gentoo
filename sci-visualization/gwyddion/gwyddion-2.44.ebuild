# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils fdo-mime gnome2-utils python-single-r1

DESCRIPTION="Framework for Scanning Mode Microscopy data analysis"
HOMEPAGE="http://gwyddion.net/"
SRC_URI="http://gwyddion.net/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fits fftw gnome kde nls opengl perl python ruby sourceview xml X"

RDEPEND="
	media-libs/libpng:0
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libXmu
	x11-libs/pango
	fits? ( sci-libs/cfitsio )
	fftw? ( sci-libs/fftw:3.0 )
	gnome? ( gnome-base/gconf:2 )
	kde? ( kde-base/kdelibs:4 )
	opengl? ( virtual/opengl x11-libs/gtkglext )
	perl? ( dev-lang/perl )
	python? (
		${PYTHON_DEPS}
		dev-python/pygtk:2[${PYTHON_USEDEP}]
	)
	ruby? ( dev-ruby/narray )
	sourceview? ( x11-libs/gtksourceview:2.0 )
	xml? ( dev-libs/libxml2:2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

MAKEOPTS+=" V=1"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=(
		--disable-rpath
		$(use_enable doc gtk-doc)
		$(use_enable nls)
		$(use_enable python pygwy)
		$(use_enable fits cfitsio)
		$(use_with perl)
		$(use_with python)
		$(use_with ruby)
		$(use_with fftw fftw3)
		$(use_with opengl gl) \
		$(use_with sourceview gtksourceview)
		$(use_with xml libxml2)
		$(use_with X x)
		$(use_with kde kde4-thumbnailer)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use python && dodoc modules/pygwy/README.pygwy
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
	fdo-mime_desktop_database_update
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
