# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-multilib

DESCRIPTION="library for handling uncompressed audio and video data"
HOMEPAGE="http://gmerlin.sourceforge.net"
SRC_URI="mirror://sourceforge/gmerlin/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 hppa ppc ~ppc64 x86"
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( AUTHORS README TODO )

src_prepare() {
	epatch "${FILESDIR}/${PV}-x32.diff"

	# AC_CONFIG_HEADERS, bug #467736
	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:-mfpmath=387::g' \
		-e 's:-O3 -funroll-all-loops -fomit-frame-pointer -ffast-math::g' \
		-e '/LDFLAGS=/d' \
		configure.ac || die

	export AT_M4DIR="m4"

	autotools-multilib_src_prepare
}

src_configure() {
	# --disable-libpng because it's only used for tests
	local myeconfargs=(
		--docdir=/usr/share/doc/${PF}/html
		--disable-libpng
		$(use_with doc doxygen)
		--without-cpuflags
		)

	autotools-multilib_src_configure
}
