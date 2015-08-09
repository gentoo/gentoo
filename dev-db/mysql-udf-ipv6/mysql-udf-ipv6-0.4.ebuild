# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

MY_REV="01c591b05b79"  # checkout revision
MY_USR="watchmouse"    # user name

MY_P="${MY_USR}-${PN}-${MY_REV}"

DESCRIPTION="IPv6 and internationalized domain (IDNA) functions for MySQL"
HOMEPAGE="http://labs.watchmouse.com/2009/10/extending-mysql-5-with-ipv6-functions/"
SRC_URI="https://bitbucket.org/${MY_USR}/${PN}/get/${MY_REV}.tar.bz2 -> ${MY_P}.tar.bz2"

LICENSE="EUPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="idn"

DEPEND=">=virtual/mysql-5.1
	idn? ( net-dns/libidn )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

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
	epatch "${FILESDIR}/${PN}-warnings.patch"
}

src_compile() {
	_compile ${CFLAGS} -Wall -fPIC ${MYSQL_INCLUDE} \
		-shared ${LDFLAGS} -o mysql_udf_ipv6.so mysql_udf_ipv6.c

	if use idn; then
		_compile ${CFLAGS} -Wall -fPIC ${MYSQL_INCLUDE} -lidn \
			-shared ${LDFLAGS} -o mysql_udf_idna.so mysql_udf_idna.c
	fi
}

src_install() {
	exeinto "${MYSQL_PLUGINDIR}"
	doexe mysql_udf_*.so
	newdoc Changelog ChangeLog
	dodoc README
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
