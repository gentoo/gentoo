# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lzlib/lzlib-1.6.ebuild,v 1.1 2015/01/27 15:29:15 mgorny Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Library for lzip compression"
HOMEPAGE="http://www.nongnu.org/lzip/lzlib.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/lzip/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_configure() {
	# not autotools-based
	./configure \
		--enable-shared \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CPPFLAGS}" \
		CFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" LDCONFIG=: install
	einstalldocs

	# this sucking thing does not support disabling static libs
	if ! use static-libs; then
		rm "${ED%/}"/usr/$(get_libdir)/*.a || die
	fi
}
