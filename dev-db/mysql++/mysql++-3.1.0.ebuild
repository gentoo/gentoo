# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="C++ API interface to the MySQL database"
HOMEPAGE="http://tangentsoft.net/mysql++/"
SRC_URI="http://www.tangentsoft.net/mysql++/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/3"
KEYWORDS="alpha amd64 hppa ~mips ppc sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=">=virtual/mysql-4.0"
DEPEND="${RDEPEND}
		|| ( >=sys-devel/gcc-3 >=sys-devel/gcc-apple-4 )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0-gcc-as-needed.patch
	epatch "${FILESDIR}"/${PN}-3.2.1-gold.patch

	for i in "${S}"/lib/*.h ; do
		sed -i \
			-e '/#include </s,mysql.h,mysql/mysql.h,g' \
			-e '/#include </s,mysql_version.h,mysql/mysql_version.h,g' \
			"${i}"
	done
	epatch_user
}

src_configure() {
	local myconf
	use prefix || local EPREFIX=
	myconf="--enable-thread-check --with-mysql=${EPREFIX}/usr"

	CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install
	# install the docs and HTML pages
	dodoc README* CREDITS* ChangeLog HACKERS.txt Wishlist doc/ssqls-pretty
	dodoc -r doc/pdf/ doc/refman/ doc/userman/
	dohtml -r doc/html/
}
