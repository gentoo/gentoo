# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils

DESCRIPTION="A library for reading vector images in Microsoft's Windows Metafile Format (WMF)"
HOMEPAGE="http://wvware.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/wvware/${PN}/${PV}/${P}.tar.gz"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc expat X"

RDEPEND="app-text/ghostscript-gpl
	media-fonts/urw-fonts
	media-libs/freetype:2=
	media-libs/libpng:0=
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	virtual/jpeg:0=
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2:2= )
	X? ( x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXpm )"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "AUTHORS" "BUILDING" "ChangeLog" "CREDITS" "INSTALL" "NEWS" "README" "TODO" )

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-CVE-2015-0848+CVE-2015-4588.patch
	"${FILESDIR}"/${P}-CVE-2015-4695.patch
	"${FILESDIR}"/${P}-CVE-2015-4696.patch
	"${FILESDIR}"/${P}-gdk-pixbuf.patch
	"${FILESDIR}"/${P}-intoverflow.patch
	"${FILESDIR}"/${P}-libpng-1.5.patch
	"${FILESDIR}"/${P}-pngfix.patch
	"${FILESDIR}"/${P}-use-freetype2-pkg-config.patch
	"${FILESDIR}"/${P}-use-system-fonts.patch
	)

src_prepare() {
	default

	# Fixes QA warning "This package has a configure.in file which has long been deprecated"
	# Since there is already a configure.ac, we don't need the deprecated configure.in
	rm configure.in || die

	if ! use doc ; then
		sed -i -e 's:doc::' Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	# Support for GD is disabled, since it's never linked, even, when enabled
	# See https://bugs.gentoo.org/268161
	local myeconfargs=(
		--disable-gd
		--disable-static
		$(use_enable debug)
		$(use_with expat)
		$(use_with !expat libxml2)
		$(use_with X x)
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		--with-fontdir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-freetype
		--with-gsfontdir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-gsfontmap="${EPREFIX}"/usr/share/ghostscript/9.21/Resource/Init/Fontmap
		--with-jpeg
		--with-layers
		--with-png
		--with-sys-gd
		--with-zlib
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	# address parallel build issue, bug 677566
	MAKEOPTS=-j1

	default
	find "${D}" -name '*.la' -delete || die
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
