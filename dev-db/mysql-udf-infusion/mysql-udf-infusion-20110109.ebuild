# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql-udf-infusion/mysql-udf-infusion-20110109.ebuild,v 1.1 2011/10/20 00:01:20 sbriesen Exp $

EAPI=4

inherit eutils toolchain-funcs

MY_REV="8599a9c"   # checkout revision
MY_USR="infusion"  # user name

MY_PN="udf_infusion"
MY_P="${MY_USR}-${MY_PN}-${MY_REV}"

DESCRIPTION="New functions for MySQL implemented as UDF"
HOMEPAGE="http://www.xarg.org/2010/11/mysql-my-new-playground/"
SRC_URI="https://github.com/${MY_USR}/${MY_PN}/tarball/${MY_REV} -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/mysql-5.1"
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
	# fix soname
	sed -i -e "s|${MY_PN}\.so|${PN//-/_}.so|g" *.sql

	# add LF
	echo >> create.sql
	echo >> delete.sql
}

src_compile() {
	_compile ${CFLAGS} -Wall -fPIC ${MYSQL_INCLUDE} \
		-shared ${LDFLAGS} -o ${PN//-/_}.so ${MY_PN}.c
}

src_install() {
	exeinto "${MYSQL_PLUGINDIR}"
	doexe *.so
	dodoc *.sql
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
