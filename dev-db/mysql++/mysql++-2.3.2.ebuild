# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql++/mysql++-2.3.2.ebuild,v 1.11 2014/07/20 02:21:13 grknight Exp $

EAPI=5

inherit eutils

DESCRIPTION="C++ API interface to the MySQL database"
HOMEPAGE="http://tangentsoft.net/mysql++/"
SRC_URI="http://www.tangentsoft.net/mysql++/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc sparc x86"
IUSE=""

RDEPEND=">=virtual/mysql-4.0"
DEPEND="${RDEPEND}
		>=sys-devel/gcc-3"

src_prepare() {

	epatch "${FILESDIR}"/${P}-gcc-4.3.patch

	for i in "${S}"/lib/*.h ; do
		sed -i \
			-e '/#include </s,mysql.h,mysql/mysql.h,g' \
			-e '/#include </s,mysql_version.h,mysql/mysql_version.h,g' \
			"${i}" || die "Failed to sed ${i} for fixing MySQL includes"
	done
}

src_configure() {
	local myconf
	# we want C++ exceptions turned on
	myconf="--enable-exceptions"
	# give threads a try
	myconf="${myconf} --enable-thread-check"
	# not including the directives to where MySQL is because it seems to
	# find it just fine without

	# force the cflags into place otherwise they get totally ignored by
	# configure
	CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
	econf ${myconf}
}

src_install() {
	default
	# install the docs and HTML pages
	dodoc README* CREDITS ChangeLog HACKERS Wishlist
	dohtml -r doc/html/*
	rm -r doc/html || die
	dodoc -r doc/*
}
