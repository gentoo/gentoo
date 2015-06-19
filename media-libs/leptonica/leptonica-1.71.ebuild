# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/leptonica/leptonica-1.71.ebuild,v 1.11 2014/11/02 09:08:16 ago Exp $

EAPI=4

inherit eutils autotools-utils

DESCRIPTION="C library for image processing and analysis"
HOMEPAGE="http://code.google.com/p/leptonica/"
SRC_URI="http://www.leptonica.com/source/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 ~sparc x86"
IUSE="gif jpeg jpeg2k png tiff webp utils zlib static-libs"

DEPEND="gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg )
	jpeg2k? ( >=media-libs/openjpeg-2.1 )
	!jpeg2k? ( !<media-libs/openjpeg-2.1 )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	webp? ( media-libs/libwebp )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

DOCS=( README version-notes )

src_prepare() {
	# unhtmlize docs
	local X
	for X in ${DOCS[@]}; do
		awk '/<\/pre>/{s--} {if (s) print $0} /<pre>/{s++}' \
			"${X}.html" > "${X}" || die 'awk failed'
		rm -f -- "${X}.html"
	done
	autotools-utils_src_prepare
}

src_configure() {
	# $(use_with webp libwebp) -> unknown
	# so use-flag just for pulling dependencies
	# zlib handling see bug 454890
	local myeconfargs=(
		$(use_with gif giflib)
		$(use_with jpeg)
		$(use_with jpeg2k libopenjpeg)
		$(use_with png libpng)
		$(use_with tiff libtiff)
		$(use_enable utils programs)
		$(use_enable static-libs static)
	)
	# libpng requires zlib:
	if use png && ! use zlib ; then
		# Ignore users non-sensical choice of -zlib
		myeconfargs+=("--with-zlib")
	else
		myeconfargs+=( $(use_with zlib) )
	fi
	autotools-utils_src_configure
}
