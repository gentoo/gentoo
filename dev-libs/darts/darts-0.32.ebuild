# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/darts/darts-0.32.ebuild,v 1.7 2010/04/09 09:28:39 hwoarang Exp $

DESCRIPTION="A C++ template library that implements Double-Array"
HOMEPAGE="http://chasen.org/~taku/software/darts/"
SRC_URI="http://chasen.org/~taku/software/darts/src/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="zlib"
DEPEND="zlib? ( sys-libs/zlib )"

src_compile() {
	econf `use_with zlib` || die
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README || die
	dohtml doc/* || die
}
