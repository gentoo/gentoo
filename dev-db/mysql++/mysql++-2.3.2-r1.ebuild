# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="C++ API interface to the MySQL database"
HOMEPAGE="http://tangentsoft.net/mysqlpp/"
SRC_URI="http://www.tangentsoft.net/mysqlpp/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-db/mysql-connector-c:="
DEPEND="${RDEPEND}"

HTML_DOCS=( doc/html/{refman,userman} )
DOCS=( README{,.cygwin,.examples,.mingw,.unix,.vc} CREDITS ChangeLog
	HACKERS Wishlist doc/pdf doc/README.devel doc/README.manuals
	doc/refman doc/ssqls-pretty doc/userman )

src_prepare() {
	eapply "${FILESDIR}"/${P}-gcc-4.3.patch

	for i in "${S}"/lib/*.h ; do
		sed -i \
			-e '/#include </s,mysql.h,mysql/mysql.h,g' \
			-e '/#include </s,mysql_version.h,mysql/mysql_version.h,g' \
			"${i}" || die "Failed to sed ${i} for fixing MySQL includes"
	done
	sed -i 's/mysqlclient_r/mysqlclient/' "${S}/configure" || die
	eapply_user
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
