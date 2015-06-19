# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql++/mysql++-3.2.1.ebuild,v 1.2 2015/06/11 15:04:49 ago Exp $

EAPI="5"

inherit eutils

DESCRIPTION="C++ API interface to the MySQL database"
HOMEPAGE="http://tangentsoft.net/mysql++/"
SRC_URI="http://www.tangentsoft.net/mysql++/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~hppa ~mips ~ppc ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=">=virtual/mysql-4.0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-gold.patch"
	epatch_user
}

src_configure() {
	local myconf="--enable-thread-check --with-mysql=${EPREFIX}/usr"
	econf ${myconf}
}

src_install() {
	default
	# install the docs and HTML pages
	dodoc CREDITS* HACKERS.txt Wishlist doc/ssqls-pretty
	dodoc -r doc/pdf/ doc/refman/ doc/userman/
	dohtml -r doc/html/
}
