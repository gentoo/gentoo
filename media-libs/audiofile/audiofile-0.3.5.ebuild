# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/audiofile/audiofile-0.3.5.ebuild,v 1.13 2013/04/10 20:21:58 ago Exp $

EAPI=5

inherit autotools eutils gnome.org

DESCRIPTION="An elegant API for accessing audio files"
HOMEPAGE="http://www.68k.org/~michael/audiofile/"

LICENSE="GPL-2 LGPL-2"
SLOT="0/1" # subslot = soname major version
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs test"

RDEPEND=""
DEPEND="test? ( dev-cpp/gtest )"

DOCS=( ACKNOWLEDGEMENTS AUTHORS ChangeLog NEWS NOTES README TODO )

src_prepare() {
	# don't build examples wrt #455978
	sed -i '/^SUBDIRS/s: examples::' Makefile.am || die

	epatch "${FILESDIR}"/${P}-system-gtest.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-werror \
		--enable-largefile
}

src_test() {
	emake -C test check
}

src_install() {
	default
	prune_libtool_files
}
