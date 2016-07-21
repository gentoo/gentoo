# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="Portable and efficient API to determine the call-chain of a program"
HOMEPAGE="https://savannah.nongnu.org/projects/libunwind"
SRC_URI="http://download.savannah.nongnu.org/releases/libunwind/${P}.tar.gz"

LICENSE="MIT"
SLOT="7"
KEYWORDS="amd64 ia64 x86"
IUSE="static-libs"

RESTRICT="test"		 # https://savannah.nongnu.org/bugs/?22368
					 # https://bugs.gentoo.org/273372

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-disable-setjmp.patch \
		"${FILESDIR}"/${P}-implicit-declaration.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	# libunwind-ptrace.a (and libunwind-ptrace.h) is separate API and without
	# shared library, so we keep it in any case
	use static-libs || rm -f "${D}"usr/lib*/libunwind{-generic.a,*.la}
}
