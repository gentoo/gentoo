# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/stk/stk-4.4.4-r1.ebuild,v 1.1 2012/11/24 16:13:41 aballier Exp $

EAPI="2"
inherit eutils autotools

DESCRIPTION="Synthesis ToolKit in C++"
HOMEPAGE="http://ccrma.stanford.edu/software/stk/"
SRC_URI="http://ccrma.stanford.edu/software/stk/release/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug doc jack oss"

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
		RAWWAVE_PATH=/usr/share/stk/rawwaves/
}

src_install() {
	dodoc README || die "Failed to install README"
	# install the lib
	dolib src/libstk.* || die "Failed to install libstk.*"
	# install headers
	insinto /usr/include/stk || die "Failed to create header directory."
	doins include/*.h include/*.msg include/*.tbl \
		|| die "Failed to install msg, tbl and h files."
	# install rawwaves
	insinto /usr/share/stk/rawwaves || die "Failed to create rawwave directory."
	doins rawwaves/*.raw || die "Failed to install rawwave files."
	# install docs
	if use doc; then
		dohtml -r doc/html/* || die "Failed to install docs."
	fi
}
