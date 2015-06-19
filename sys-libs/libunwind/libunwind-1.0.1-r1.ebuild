# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libunwind/libunwind-1.0.1-r1.ebuild,v 1.8 2012/12/17 17:04:24 ago Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="http://savannah.nongnu.org/projects/libunwind"
SRC_URI="http://download.savannah.nongnu.org/releases/libunwind/${P}.tar.gz"

LICENSE="MIT"
SLOT="7"
KEYWORDS="amd64 ~arm ia64 ~ppc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug debug-frame static-libs"

# https://savannah.nongnu.org/bugs/?22368
# https://bugs.gentoo.org/273372
RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

QA_DT_NEEDED_x86_fbsd="usr/lib/libunwind.so.7.0.0"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.1-disable-setjmp.patch
	epatch "${FILESDIR}"/${PN}-1.0.1-ia64.patch #425736
	eautoreconf
}

src_configure() {
	# do not $(use_enable) because the configure.in is broken and parses
	# --disable-debug the same as --enable-debug.
	# https://savannah.nongnu.org/bugs/index.php?34324
	# --enable-cxx-exceptions: always enable it, headers provide the interface
	# and on some archs it is disabled by default causing a mismatch between the
	# API and the ABI, bug #418253
	# conservative-checks: validate memory addresses before use; as of 1.0.1,
	# only x86_64 supports this, yet may be useful for debugging, couple it with
	# debug useflag.
	econf \
		--enable-cxx-exceptions \
		$(use_enable debug-frame) \
		$(use_enable static-libs static) \
		$(use_enable debug conservative_checks) \
		$(use debug && echo --enable-debug)
}

src_test() {
	# explicitly allow parallel build of tests
	emake check
}

src_install() {
	default
	# libunwind-ptrace.a (and libunwind-ptrace.h) is separate API and without
	# shared library, so we keep it in any case
	use static-libs || rm -f "${ED}"usr/lib*/libunwind{-generic.a,*.la}
}
