# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gavl/gavl-1.2.0.ebuild,v 1.7 2013/05/15 11:28:52 ssuominen Exp $

EAPI=4
inherit autotools-utils

DESCRIPTION="library for handling uncompressed audio and video data"
HOMEPAGE="http://gmerlin.sourceforge.net"
SRC_URI="mirror://sourceforge/gmerlin/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 hppa ppc ~ppc64 x86"
IUSE="doc"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )
	virtual/pkgconfig"
# pkg-config is only here to satisfy autotools-utils.eclass wrt #432796

DOCS=( AUTHORS README TODO )

src_prepare() {
	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:-mfpmath=387::g' \
		-e 's:-O3 -funroll-all-loops -fomit-frame-pointer -ffast-math::g' \
		-e '/LDFLAGS=/d' \
		configure.ac || die

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	# --disable-libpng because it's only used for tests
	local myeconfargs=(
		--docdir=/usr/share/doc/${PF}/html
		--disable-libpng
		$(use_with doc doxygen)
		--without-cpuflags
		)

	autotools-utils_src_configure
}
