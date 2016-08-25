# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils libtool

DESCRIPTION="Library to handle, display and manipulate GIF images"
HOMEPAGE="https://sourceforge.net/projects/giflib/"
SRC_URI="mirror://sourceforge/giflib/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="rle static-libs X"

DEPEND="X? (
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libICE
		x11-libs/libSM
	)
	rle? ( media-libs/urt )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gif2rle.patch
	epatch "${FILESDIR}"/${P}-giffix-null-Extension-fix.patch
	elibtoolize
	epunt_cxx
}

src_configure() {
	local myconf=""

	# prevent circular depend #111455
	if has_version media-libs/urt ; then
		myconf="${myconf} $(use_enable rle)"
	else
		myconf="${myconf} --disable-rle"
	fi

	econf \
		--disable-gl \
		$(use_enable static-libs static) \
		$(use_enable X x11) \
		${myconf}
}

src_install() {
	default
	# for static libs the .la file is required if build with +rle or +X
	use static-libs || find "${ED}" -name '*.la' -exec rm -f {} +
	dodoc AUTHORS BUGS ChangeLog NEWS ONEWS README TODO doc/*.txt
	dohtml -r doc
}
