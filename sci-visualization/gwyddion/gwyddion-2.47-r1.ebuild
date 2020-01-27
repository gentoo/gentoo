# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils xdg

DESCRIPTION="Framework for Scanning Mode Microscopy data analysis"
HOMEPAGE="http://gwyddion.net/"
SRC_URI="http://gwyddion.net/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc fits fftw gnome nls opengl perl ruby sourceview xml X"

RDEPEND="
	media-libs/libpng:0=
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libXmu
	x11-libs/pango
	fits? ( sci-libs/cfitsio )
	fftw? ( sci-libs/fftw:3.0= )
	gnome? ( gnome-base/gconf:2 )
	opengl? ( virtual/opengl x11-libs/gtkglext )
	perl? ( dev-lang/perl:= )
	ruby? ( dev-ruby/narray )
	sourceview? ( x11-libs/gtksourceview:2.0 )
	xml? ( dev-libs/libxml2:2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.47-cfitsio.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-rpath \
		--without-kde4-thumbnailer \
		$(use_enable doc gtk-doc) \
		$(use_enable nls) \
		--disable-pygwy \
		$(use_with fits cfitsio) \
		$(use_with perl) \
		--without-python \
		$(use_with ruby) \
		$(use_with fftw fftw3) \
		$(use_with opengl gl) \
		$(use_with sourceview gtksourceview) \
		$(use_with xml libxml2) \
		$(use_with X x)
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
	xdg_pkg_postinst
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}
