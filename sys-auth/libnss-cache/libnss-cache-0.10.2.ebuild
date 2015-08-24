# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils multilib toolchain-funcs

DESCRIPTION="libnss-cache is a library that serves nss lookups"
HOMEPAGE="https://code.google.com/p/nsscache/"
SRC_URI="https://nsscache.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="multilib"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.10.1-make.patch
	epatch "${FILESDIR}"/${PN}-0.10-fix-shadow-test.patch
}

src_compile() {
	emake CC="$(tc-getCC)" nss_cache || die
	if use multilib && has_multilib_profile; then
		emake CC="$(tc-getCC)" nss_cache32 || die
	fi
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="${D}/usr/$(get_libdir)" install || die
	if use multilib && has_multilib_profile; then
		emake DESTDIR="${D}" LIBDIR="${D}/usr/$(get_libdir)" install32 || die
	fi
}
