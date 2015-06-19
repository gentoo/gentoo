# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pstoedit/pstoedit-3.62.ebuild,v 1.9 2015/04/14 13:23:57 ago Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="Translate PostScript and PDF graphics into other vector formats"
HOMEPAGE="http://sourceforge.net/projects/pstoedit/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="emf flash imagemagick plotutils pptx static-libs"

RDEPEND="
	>=media-libs/libpng-1.4.3
	>=media-libs/gd-2.0.35-r1
	>=app-text/ghostscript-gpl-8.71-r1
	emf? ( >=media-libs/libemf-1.0.3 )
	flash? ( >=media-libs/ming-0.4.3 )
	imagemagick? ( >=media-gfx/imagemagick-6.6.1.2[cxx] )
	plotutils? ( media-libs/plotutils )
	pptx? ( dev-libs/libzip )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -i \
		-e '/CXXFLAGS="-g"/d' \
		-e 's:-pedantic::' \
		configure.ac || die

	epatch "${FILESDIR}"/${PN}-3.62-parallel.patch
	epatch "${FILESDIR}"/${PN}-3.60-libdl.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with emf) \
		$(use_with imagemagick magick) \
		$(use_with plotutils libplot) \
		$(use_with flash swf) \
		$(use_with pptx)
}

src_install() {
	default
	doman doc/pstoedit.1
	dodoc doc/*.txt
	dohtml doc/*.htm

	prune_libtool_files
}
