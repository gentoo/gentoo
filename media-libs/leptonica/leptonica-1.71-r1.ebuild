# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/leptonica/leptonica-1.71-r1.ebuild,v 1.7 2015/02/24 08:48:36 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF="1"
inherit eutils autotools-utils

DESCRIPTION="C library for image processing and analysis"
HOMEPAGE="http://code.google.com/p/leptonica/"
SRC_URI="http://www.leptonica.com/source/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="gif jpeg jpeg2k png tiff webp utils zlib static-libs test"

# N.b. Tests need all tested features enabled:
REQUIRED_USE="test? ( gif jpeg jpeg2k png tiff webp )"

DEPEND="gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg )
	jpeg2k? ( media-libs/openjpeg:2= )
	png? ( media-libs/libpng
		   sys-libs/zlib
		 )
	tiff? ( media-libs/tiff )
	webp? ( media-libs/libwebp )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

DOCS=( README version-notes )
PATCHES=( "${FILESDIR}"/"${P}"-fix-openjpeg-test.patch )

src_prepare() {
	if has_version "=media-libs/openjpeg-2.0.0" ; then
		epatch "${FILESDIR}"/"${P}"-openjpeg-2.0.patch
	fi

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
