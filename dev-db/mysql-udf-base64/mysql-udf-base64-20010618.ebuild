# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql-udf-base64/mysql-udf-base64-20010618.ebuild,v 1.2 2011/10/19 12:01:21 sbriesen Exp $

EAPI=4

inherit eutils toolchain-funcs

MY_PN="${PN//-/_}"

DESCRIPTION="MySQL UDFs that provide base64 encode/decode"
HOMEPAGE="http://mirrors.sohu.com/mysql/Contrib/Old-Versions/"
SRC_URI="http://mirrors.sohu.com/mysql/Contrib/Old-Versions/${PN}.c -> ${P}.c
	http://mirrors.sohu.com/mysql/Contrib/Old-Versions/${PN}.readme -> ${P}.readme"

LICENSE="PHP-2.02"
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

src_unpack() {
	cp -f "${DISTDIR}/${P}.c"      "${S}/${PN}.c"
	cp -f "${DISTDIR}/${P}.readme" "${S}/${PN}.readme"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-signedness.patch"
}

src_compile() {
	_compile ${CFLAGS} -Wall -fPIC ${MYSQL_INCLUDE} \
		-shared ${LDFLAGS} -o ${MY_PN}.so ${PN}.c
}

src_install() {
	exeinto "${MYSQL_PLUGINDIR}"
	doexe ${MY_PN}.so
	newdoc ${PN}.readme README
	newdoc "${FILESDIR}/${PN}.sql" ${MY_PN}.sql
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
