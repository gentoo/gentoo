# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/lib_mysqludf_sys/lib_mysqludf_sys-0.0.3.ebuild,v 1.1 2011/10/24 03:13:07 sbriesen Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="MySQL UDFs that allows one to interact with the operating system"
HOMEPAGE="http://www.mysqludf.org/lib_mysqludf_sys/"
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
