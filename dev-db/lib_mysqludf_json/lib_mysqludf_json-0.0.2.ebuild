# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="MySQL UDFs to map relational data to the JSON format"
HOMEPAGE="http://www.mysqludf.org/lib_mysqludf_json/"
SRC_URI="http://www.mysqludf.org/${PN}/${PN}_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/mysql-5.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

# compile helper
_compile() {
	local CC="$(tc-getCC)"
	echo "${CC} ${@}" && "${CC}" "${@}"
}

pkg_setup() {
	MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
	MYSQL_INCLUDE="$(mysql_config --include)"
}

src_prepare() {
	# remove precompiled object
	rm -f -- ${PN}.so
}

src_compile() {
	_compile ${CFLAGS} -Wall -fPIC ${MYSQL_INCLUDE} \
		-shared ${LDFLAGS} -o ${PN}.so ${PN}.c
}

src_install() {
	exeinto "${MYSQL_PLUGINDIR}"
	doexe ${PN}.so
	dodoc ${PN}.sql
	dohtml ${PN}.html
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
