# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Image editor with tiff, jpeg and png support"
HOMEPAGE="http://sf-xpaint.sourceforge.net/"
SRC_URI="mirror://sourceforge/sf-xpaint/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg2k pgf tiff"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:0
	x11-libs/libICE
	x11-libs/libX11
	>=x11-libs/libXaw3dXft-1.6.2c
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	sys-libs/zlib
	virtual/jpeg:62
	jpeg2k? ( media-libs/openjpeg:0 )
	pgf? ( media-libs/libpgf )
	tiff? (
		media-libs/jbigkit:0
		media-libs/tiff:0
	)"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.9.9.4-{QA1,submake,parallel-make}.patch \
		"${FILESDIR}"/${PN}-2.9.10.2-{QA2,tiff}.patch \
		"${FILESDIR}"/${PN}-2.9.10.3-Fix-build-with-clang.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable tiff) \
		$(use_enable jpeg2k libopenjpeg)
}

src_compile() {
	# clean up
	emake clean
	emake -C util clean

	# parallel make still fails sometimes
	emake substads
	emake xpaint.1

	default
	emake \
		WITH_PGF="$(usex pgf "yes" "no")" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		-C util
}

src_install() {
	default
	emake \
		WITH_PGF="$(usex pgf "yes" "no")" \
		DESTDIR="${ED}" \
		-C util install
}

pkg_postinst() {
	elog "optional dependencies:"
	elog "  app-text/gv (external viewer for PostScript output)"
	elog "  media-gfx/imagemagick (external viewer for pixel graphics)"
	elog "  net-print/cups (printing)"
}
