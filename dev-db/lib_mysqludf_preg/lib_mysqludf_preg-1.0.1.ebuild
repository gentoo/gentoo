# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs autotools

DESCRIPTION="MySQL UDFs that provide access to the PCRE library for pattern matching"
HOMEPAGE="http://www.mysqludf.org/lib_mysqludf_preg/"
SRC_URI="http://www.mysqludf.org/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/mysql-5.1
	dev-libs/libpcre"
RDEPEND="${DEPEND}"

RESTRICT="test"

pkg_setup() {
	MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
	MYSQL_INCLUDE="$(mysql_config --include)"
}

src_prepare() {
	edos2unix README
	eautoreconf
}

src_configure() {
	econf --with-pic --disable-static --libdir="${MYSQL_PLUGINDIR}"
}

src_install() {
	local X
	emake DESTDIR="${D}" install
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
