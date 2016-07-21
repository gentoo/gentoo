# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

DESCRIPTION="Synthesis ToolKit in C++"
HOMEPAGE="http://ccrma.stanford.edu/software/stk/"
SRC_URI="http://ccrma.stanford.edu/software/stk/release/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug doc jack oss static-libs"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-lang/perl"

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${FILESDIR}/${P}"
	eautoreconf
}

src_configure() {
	#breaks with --disable-foo...uses as --enable-foo
	local myconf
	if use debug; then
		myconf="${myconf} --enable-debug"
	fi
	if use oss; then
		myconf="${myconf} --with-oss"
	fi
	if use alsa; then
		myconf="${myconf} --with-alsa"
	fi
	if use jack; then
		myconf="${myconf} --with-jack"
	fi

	econf ${myconf} \
		--enable-shared \
		$(use_enable static-libs static) \
		RAWWAVE_PATH=/usr/share/stk/rawwaves/
}

src_install() {
	dodoc README.md

	# install the lib
	dolib src/libstk.*

	# install headers
	insinto /usr/include/stk
	doins include/*.h include/*.msg include/*.tbl

	# install rawwaves
	insinto /usr/share/stk/rawwaves
	doins rawwaves/*.raw

	# install docs
	if use doc; then
		dohtml -r doc/html/*
	fi
}
