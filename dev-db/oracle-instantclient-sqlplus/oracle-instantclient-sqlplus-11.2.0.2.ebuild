# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib

MY_P_x86="${PN/oracle-/}-linux32-${PV}.0"
MY_P_amd64="${PN/oracle-instantclient-/instantclient-}-linux-x86-64-${PV}.0"

S="${WORKDIR}"
DESCRIPTION="Oracle 11g client installation for Linux: SQL*Plus"
HOMEPAGE="http://www.oracle.com/technology/tech/oci/instantclient/index.html"
SRC_URI="x86? ( ${MY_P_x86}.zip )
	amd64? ( ${MY_P_amd64}.zip )"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="fetch"
IUSE=""

RDEPEND=">=dev-db/oracle-instantclient-basic-${PV}"
DEPEND="${RDEPEND}
	app-arch/unzip"

pkg_setup() {
	MY_P=MY_P_${ARCH}
	export MY_P=${!MY_P}
}

pkg_nofetch() {
	eerror "Please go to:"
	eerror "  ${HOMEPAGE}"
	eerror "select your platform and download the"
	eerror "SQL*Plus package.  Put it in:"
	eerror "  ${DISTDIR}"
	eerror "after downloading it."
}

src_unpack() {
	unzip "${DISTDIR}"/${MY_P}.zip
}

src_install() {
	dodir /usr/$(get_libdir)/oracle/${PV}/client/lib
	cd "${S}"/instantclient_11_2
	insinto /usr/$(get_libdir)/oracle/${PV}/client/lib
	doins libsqlplus.so libsqlplusic.so
	insinto /usr/$(get_libdir)/oracle/${PV}/client/sqlplus/admin/
	doins glogin.sql

	dodir /usr/$(get_libdir)/oracle/${PV}/client/bin
	cd "${S}"/instantclient_11_2
	exeinto /usr/$(get_libdir)/oracle/${PV}/client/bin
	doexe sqlplus

	dodir /usr/bin
	dosym "${D}"/usr/$(get_libdir)/oracle/${PV}/client/bin/sqlplus /usr/bin/sqlplus
}

pkg_postinst() {
	elog "The SQL*Plus package for Oracle 11g has been installed."
	elog "You may wish to install the oracle-instantclient-jdbc (for"
	elog "the supplemental JDBC functionality) package as well."
	elog
	elog "If you have any questions, be sure to read the README:"
	elog "http://otn.oracle.com/docs/tech/sql_plus/10102/readme_ic.htm"
}
