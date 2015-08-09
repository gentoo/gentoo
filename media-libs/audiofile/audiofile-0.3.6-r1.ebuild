# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib gnome.org

DESCRIPTION="An elegant API for accessing audio files"
HOMEPAGE="http://www.68k.org/~michael/audiofile/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/1" # subslot = soname major version
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="flac static-libs test"

RDEPEND="flac? ( >=media-libs/flac-1.2.1[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r1
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"

DOCS=( ACKNOWLEDGEMENTS AUTHORS ChangeLog NEWS NOTES README TODO )

PATCHES=( "${FILESDIR}"/${P}-system-gtest.patch )

src_configure() {
	local myeconfargs=(
		--enable-largefile
		--disable-werror
		--disable-examples
		$(use_enable flac)
	)
	autotools-multilib_src_configure
}

src_test() {
	autotools-multilib_src_test -C test
}
