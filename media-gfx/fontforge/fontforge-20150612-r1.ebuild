# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit autotools eutils fdo-mime python-single-r1

DESCRIPTION="postscript font editor and converter"
HOMEPAGE="http://fontforge.github.io/"
SRC_URI="https://github.com/fontforge/fontforge/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="cairo truetype-debugger gif gtk jpeg png +python readline tiff svg unicode X"

REQUIRED_USE="
	cairo? ( png )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	dev-libs/libltdl:0
	dev-libs/libxml2:2=
	>=media-libs/freetype-2.3.7:2=
	cairo? (
		>=x11-libs/cairo-1.6:0=
		x11-libs/pango:0=
	)
	gif? ( media-libs/giflib:0= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )
	truetype-debugger? ( >=media-libs/freetype-2.3.8:2[fontforge,-bindist(-)] )
	gtk? ( x11-libs/gtk+:2= )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	unicode? ( media-libs/libuninameslist:0= )
	X? (
		x11-libs/libX11:0=
		x11-libs/libXi:0=
		x11-libs/libxkbui:0=
		>=x11-libs/pango-1.10:0=[X]
	)
	!media-gfx/pfaedit
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	X? ( x11-proto/inputproto )
"

# Needs keywording on many arches.
#	zeromq? (
#		>=net-libs/czmq-2.2.0:0=
#		>=net-libs/zeromq-4.0.4:0=
#	)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

gnulib_import() {
	(
		func_add_hook() { :; }
		source bootstrap.conf
		set -- "${S}/gnulib/gnulib-tool" --libtool --import ${gnulib_modules}
		echo "$@"
		"$@"
	)
}

src_prepare() {
	# Tarball comes with broken absolute symlinks
	# https://github.com/fontforge/fontforge/issues/2439
	find . -lname "/*" -delete || die
	gnulib_import || die
	epatch_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable truetype-debugger freetype-debugger "${EPREFIX}/usr/include/freetype2/internal4fontforge")
		$(use_enable gtk gtk2-use)
		$(use_enable python python-extension)
		$(use_enable python python-scripting)
		--enable-tile-path
		--enable-gb12345
		$(use_with cairo)
		$(use_with gif giflib)
		$(use_with jpeg libjpeg)
		$(use_with png libpng)
		$(use_with readline libreadline)
		--without-libspiro
		$(use_with tiff libtiff)
		$(use_with unicode libuninameslist)
		#$(use_with zeromq libzmq)
		--without-libzmq
		$(use_with X x)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Build system deps are broken
	emake -C plugins
	emake
}

src_install() {
	default
	prune_libtool_files --modules
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
