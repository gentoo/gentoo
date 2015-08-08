# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs autotools

MY_REV="a8e623c"    # checkout revision
MY_USR="joaocosta"  # user name

MY_P="${MY_USR}-${PN}-${MY_REV}"

DESCRIPTION="MySQL UDFs with technical analysis functions"
HOMEPAGE="http://www.mysqludf.org/lib_mysqludf_ta/"
SRC_URI="https://github.com/${MY_USR}/${PN}/tarball/${MY_REV} -> ${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/mysql-5.1"
RDEPEND="${DEPEND}"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
	MYSQL_INCLUDE="$(mysql_config --include)"
}

src_prepare() {

	# fix Makefile.am
	sed -i -e "s|\(-shared\)|\1 -avoid-version|g" Makefile.am

	# convert to UTF-8
	iconv -f LATIN1 -t UTF-8 < README > README~
	mv -f README~ README

	edos2unix README
	eautoreconf
}

src_configure() {
	econf --with-pic --disable-static --libdir="${MYSQL_PLUGINDIR}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README sampledb.sql

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
