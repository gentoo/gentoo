# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib toolchain-funcs

DESCRIPTION="Library for lzip compression"
HOMEPAGE="http://www.nongnu.org/lzip/lzlib.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/lzip/${PN}/${P}.tar.gz"

LICENSE="libstdc++" # fancy form of GPL-2+ with library exception
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_configure() {
	local myconf=(
		--enable-shared
		--disable-static
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		CC="$(tc-getCC)"
		CPPFLAGS="${CPPFLAGS}"
		CFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	# not autotools-based
	./configure "${myconf[@]}" || die
}

src_install() {
	emake DESTDIR="${D}" LDCONFIG=: install
	einstalldocs
}
