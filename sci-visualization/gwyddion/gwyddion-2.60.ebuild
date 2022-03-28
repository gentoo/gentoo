# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Framework for Scanning Mode Microscopy data analysis"
HOMEPAGE="http://gwyddion.net/"
SRC_URI="http://gwyddion.net/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 doc fits jansson hdf5 nls openexr openmp perl ruby sourceview unique xml X zlib"

RDEPEND="
	>=dev-libs/glib-2.32
	dev-libs/libzip
	media-libs/libpng:0=
	>=sci-libs/fftw-3.1:3.0=[openmp?]
	virtual/libiconv
	virtual/libintl
	x11-libs/cairo
	>=x11-libs/gtk+-2.18:2
	x11-libs/libXmu
	x11-libs/pango
	bzip2? ( app-arch/bzip2 )
	fits? ( sci-libs/cfitsio[bzip2?] )
	jansson? ( dev-libs/jansson )
	hdf5? ( sci-libs/hdf5[zlib?] )
	openexr? ( media-libs/openexr:= )
	perl? ( dev-lang/perl:= )
	ruby? ( dev-ruby/narray )
	unique? ( dev-libs/libunique:3 )
	sourceview? ( x11-libs/gtksourceview:2.0 )
	xml? ( dev-libs/libxml2:2 )
	zlib? ( sys-libs/zlib )
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.60-automagic.patch"
)

src_prepare() {
	default
	eautoreconf
}

# There are python bindings (--enable-pygwy) but they are py2 only
# 3D opengl rendering requires deprecated GTK-2 x11-libs/gtkglext
src_configure() {
	# hack for bug 741840
	use doc && export GTK_DOC_PATH=/usr/share/gtk-doc

	econf \
		--disable-rpath \
		--without-kde4-thumbnailer \
		$(use_enable doc gtk-doc) \
		$(use_enable openmp) \
		$(use_enable nls) \
		--disable-pygwy \
		--without-python \
		$(use_with bzip2) \
		$(use_with fits cfitsio) \
		$(use_with hdf5) \
		$(use_with perl) \
		$(use_with ruby) \
		$(use_with openexr exr) \
		--without-gl \
		$(use_with sourceview gtksourceview) \
		$(use_with unique) \
		$(use_with xml libxml2) \
		$(use_with X x) \
		$(use_with zlib) \
		--with-zip=libzip
}
