# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils gnome2-utils

#The configure script finds the 5.50 ghostscript Fontmap file while run.
#This will probably work, especially since the real one (6.50) in this case
#is empty. However beware in case there is any trouble

DESCRIPTION="library for converting WMF files"
HOMEPAGE="http://wvware.sourceforge.net/"
SRC_URI="mirror://sourceforge/wvware/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="X debug doc expat xml"

RDEPEND="
	app-text/ghostscript-gpl
	media-fonts/urw-fonts
	media-libs/freetype:2=
	>=media-libs/libpng-1.4:0=
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2[X?]
	virtual/jpeg:0=
	xml? (
		expat? ( dev-libs/expat )
		!expat? (  dev-libs/libxml2 )
	)
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? (
		x11-libs/libXt
		x11-libs/libXpm
	)"
# plotutils are not really supported yet, so looks like that's it

REQUIRED_USE="expat? ( xml )"

DOCS=( README AUTHORS CREDITS ChangeLog NEWS TODO )

PATCHES=(
	"${FILESDIR}"/${P}-intoverflow.patch
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-pngfix.patch
	"${FILESDIR}"/${P}-libpng-1.5.patch
	"${FILESDIR}"/${P}-use-system-fonts.patch
	"${FILESDIR}"/${P}-gdk-pixbuf.patch
	"${FILESDIR}"/${P}-CVE-2015-0848+CVE-2015-4588.patch
	"${FILESDIR}"/${P}-CVE-2015-4695.patch
	"${FILESDIR}"/${P}-CVE-2015-4696.patch
	)

AUTOTOOLS_PRUNE_LIBTOOL_FILES='modules'

src_prepare() {
	if ! use doc ; then
		sed -e 's:doc::' -i Makefile.am || die
	fi
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=()
	# NOTE: The gd that is included is gd-2.0.0. Even with --with-sys-gd, that gd is built
	# and included in libwmf. Since nothing in-tree seems to use media-libs/libwmf[gd],
	# we're explicitly disabling gd use w.r.t. bug 268161
	if use expat; then
		myeconfargs+=( --without-libxml2 )
	else
		myeconfargs+=( $(use_with xml libxml2) )
	fi

	myeconfargs+=(
		--disable-static
		$(use_enable debug)
		$(use_with X x)
		$(use_with expat)
		--disable-gd
		--with-sys-gd
		--with-gsfontdir="${EPREFIX}"/usr/share/ghostscript/fonts
		--with-fontdir="${EPREFIX}"/usr/share/fonts/urw-fonts/
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		)
	autotools-utils_src_configure
}

src_install() {
	MAKEOPTS+=" -j1"
	autotools-utils_src_install
}

pkg_preinst() {
	gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	gnome2_gdk_pixbuf_update
}
