# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

_dpatch=15

DESCRIPTION="A program for converting bitmaps to vector graphics"
HOMEPAGE="http://packages.qa.debian.org/a/autotrace.html http://autotrace.sourceforge.net/"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/a/${PN}/${PN}_${PV}-${_dpatch}.diff.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ia64 ~ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+imagemagick static-libs"

RDEPEND="media-libs/libexif:=
	media-libs/libpng:0=
	>=media-libs/ming-0.4.2:=
	>=media-gfx/pstoedit-3.50:=
	imagemagick? ( >=media-gfx/imagemagick-6.6.2.5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	epatch "${WORKDIR}"/${PN}_${PV}-${_dpatch}.diff

	epatch \
		"${FILESDIR}"/${P}-{m4,libpng14,pkgconfig}.patch \
		"${FILESDIR}"/${P}-swf-output.patch \
		"${FILESDIR}"/${P}-GetOnePixel.patch \
		"${FILESDIR}"/${P}-libpng-1.5.patch

	# Fix building on PowerPC with Altivec
	epatch "${FILESDIR}"/${P}-bool.patch

	# Addresses bug #466078
	epatch "${FILESDIR}"/${P}-CVE-2013-1953.patch

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die #468496

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with imagemagick magick) \
		--with-ming \
		--with-pstoedit
}

src_install() {
	default
	prune_libtool_files --all
}
