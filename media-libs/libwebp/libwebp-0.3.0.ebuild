# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib-minimal

DESCRIPTION="A lossy image compression format"
HOMEPAGE="https://code.google.com/p/webp/"
SRC_URI="https://webp.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="experimental gif +jpeg +png static-libs swap-16bit-csp tiff"

RDEPEND="gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )"
DEPEND="${RDEPEND}"

ECONF_SOURCE=${S}

multilib_src_configure() {
	ac_cv_header_gif_lib_h=$(usex gif) \
	ac_cv_header_jpeglib_h=$(usex jpeg) \
	ac_cv_header_png_h=$(usex png) \
	ac_cv_header_tiffio_h=$(usex tiff) \
		econf \
			$(use_enable static-libs static) \
			$(use_enable swap-16bit-csp) \
			$(use_enable experimental) \
			--enable-libwebpmux \
			--enable-libwebpdemux \
			--enable-libwebpdecoder
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	prune_libtool_files
	dodoc AUTHORS ChangeLog doc/*.txt NEWS README{,.mux}
}
