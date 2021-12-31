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
IUSE="doc fits gnome nls openexr perl ruby sourceview xml X"

RDEPEND="
	>=dev-libs/glib-2.32
	dev-libs/libzip
	media-libs/libpng:0=
	>=sci-libs/fftw-3.1:3.0=
	x11-libs/cairo
	>=x11-libs/gtk+-2.18:2
	x11-libs/libXmu
	x11-libs/pango
	fits? ( sci-libs/cfitsio )
	gnome? ( gnome-base/gconf:2 )
	openexr? ( media-libs/openexr:= )
	perl? ( dev-lang/perl:= )
	ruby? ( dev-ruby/narray )
	sourceview? ( x11-libs/gtksourceview:2.0 )
	xml? ( dev-libs/libxml2:2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gtk-doc
"
# gtk-doc usually only needed for doc useflag, but our
# mime patch requires it...

PATCHES=(
	"${FILESDIR}/${PN}-2.55-automagic.patch"
	"${FILESDIR}/${PN}-2.55-mime.patch"
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
		--without-gl \
		$(use_with openexr exr) \
		$(use_with sourceview gtksourceview) \
		$(use_with xml libxml2) \
		$(use_with X x) \
		--with-zip=libzip
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
	xdg_pkg_postinst
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}
