# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/lib_mysqludf_stem/lib_mysqludf_stem-0.9.1.ebuild,v 1.1 2011/10/19 12:23:45 sbriesen Exp $

EAPI=4

inherit eutils toolchain-funcs autotools

DESCRIPTION="MySQL UDFs which provides stemming capability for a variety of languages"
HOMEPAGE="http://www.mysqludf.org/lib_mysqludf_stem/"
SRC_URI="http://www.mysqludf.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/mysql-5.1"
RDEPEND="${DEPEND}"

RESTRICT="test"

pkg_setup() {
	MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
	MYSQL_INCLUDE="$(mysql_config --include)"
}

src_prepare() {
	# add AC_PROG_CXX to configure.ac
	sed -i -e 's|\(AC_PROG_CC\)|\1\nAC_PROG_CXX|g' configure.ac

	# fix ax_lib_mysql.m4 + ax_mysql_bin.m4
	epatch "${FILESDIR}/${PN}-mysql_m4.patch"

	# fix and clean libstemmer_c
	sed -i -e 's|^\(CFLAGS\)=|\1+=-fPIC |g' libstemmer_c/Makefile
	rm -f -- libstemmer_c/stemwords libstemmer_c/*.{o,a} libstemmer_c/*/*.o

	edos2unix installdb.sql
	eautoreconf
}

src_configure() {
	econf --with-pic --disable-static --libdir="${MYSQL_PLUGINDIR}"
}

src_install() {
	local X
	emake DESTDIR="${D}" install
	dodoc libstemmer_c/libstemmer/*.txt
	[ -f ${PN}.html ] && dohtml ${PN}.html
	[ -d doc/html ] && dohtml -r doc/html/.
	for X in API AUTHORS ChangeLog NEWS README *installdb.sql; do
		[ -s "${X}" ] && dodoc "${X}"
	done

	# remove obsolete *.la file
	rm -f -- "${D}${MYSQL_PLUGINDIR}"/*.la
}

pkg_postinst() {
	elog
	elog "Please have a look at the documentation, how to"
	elog "enable/disable the UDF functions of ${PN}."
	elog
	elog "The documentation is located here:"
	elog "/usr/share/doc/${PF}"
	elog
}
