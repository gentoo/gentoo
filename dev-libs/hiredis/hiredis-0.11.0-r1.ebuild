# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib

DESCRIPTION="Minimalistic C client library for the Redis database"
HOMEPAGE="https://github.com/redis/hiredis"
SRC_URI="https://github.com/redis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x64-solaris"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}/${P}-disable-network-tests.patch"

	# use GNU ld syntax on Solaris
	sed -i -e '/DYLIB_MAKE_CMD=.* -G/d' Makefile || die
}

_emake() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		ARCH= \
		DEBUG= \
		OPTIMIZATION="${CPPFLAGS}" \
		"$@"
}

src_compile() {
	# The static lib re-uses the same objects as the shared lib, so
	# overhead is low w/creating it all the time.  It's also needed
	# by the tests.
	_emake dynamic static
}

src_test() {
	_emake test
}

src_install() {
	_emake PREFIX="${ED}/usr" LIBRARY_PATH="$(get_libdir)" install
	use static-libs || rm "${ED}/usr/$(get_libdir)/libhiredis.a"
	dodoc CHANGELOG.md README.md
}
