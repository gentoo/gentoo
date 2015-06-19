# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql-udf-http/mysql-udf-http-1.0.ebuild,v 1.2 2011/10/19 12:09:10 sbriesen Exp $

EAPI=4

inherit eutils toolchain-funcs autotools

DESCRIPTION="MySQL User-defined function (UDF) for HTTP REST"
HOMEPAGE="http://code.google.com/p/mysql-udf-http/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/mysql-5.1
	net-misc/curl"
RDEPEND="${DEPEND}"

pkg_setup() {
	MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
	MYSQL_INCLUDE="$(mysql_config --include)"
}

src_prepare() {
	# fix README
	sed -i -e "s|${PN}\(\.so\)|${PN//-/_}\1|g" README

	# fix Makefile.am
	sed -i -e "s|${PN}\([_\.]la\)|${PN//-/_}\1|g" \
		-e "s|\(-module\)|\1 -avoid-version|g" src/Makefile.am

	epatch "${FILESDIR}/${PN}-stdlib.patch"
	eautoreconf
}

src_configure() {
	econf --with-pic --disable-static --libdir="${MYSQL_PLUGINDIR}" \
		--with-mysql="$(type -p mysql_config)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README

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
