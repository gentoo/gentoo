# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib

MY_P_x86="${PN/oracle-/}-linux32-${PV}.0"
MY_PSDK_x86="${MY_P_x86/basic/sdk}"

MY_PBASE_amd64="${PN/oracle-instantclient-basic/instantclient-basic-linux}-x86-64-${PV}.0"
MY_P_amd64="${PN/oracle-instantclient-basic/instantclient-basic-linux}-x86-64-${PV}.0"
MY_PSDK_amd64="${MY_PBASE_amd64/basic/sdk}"

DESCRIPTION="Oracle 11g client installation for Linux with SDK"
HOMEPAGE="http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html"
SRC_URI="x86? ( ${MY_P_x86}.zip ${MY_PSDK_x86}.zip )
		 amd64? ( ${MY_P_amd64}.zip ${MY_PSDK_amd64}.zip )"

LICENSE="OTN"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
RESTRICT="fetch"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-libs/libaio"

S="${WORKDIR}"

my_arch() {
	MY_P=MY_P_${ARCH}
	export MY_P=${!MY_P}
	MY_PSDK=MY_PSDK_${ARCH}
	export MY_PSDK=${!MY_PSDK}
}

pkg_setup() {
	my_arch
}

pkg_nofetch() {
	my_arch
	eerror "Please go to:"
	eerror "  ${HOMEPAGE}"
	eerror "select your platform and download the"
	eerror "Basic client package with SDK, which are:"
	eerror "  ${MY_P}.zip"
	eerror "  ${MY_PSDK}.zip"
	eerror "Then after downloading put them in:"
	eerror "  ${DISTDIR}"
}

src_unpack() {
	unzip "${DISTDIR}"/${MY_P}.zip || die "unsuccesful unzip ${MY_P}.zip"
	unzip "${DISTDIR}"/${MY_PSDK}.zip || die "unsuccesful unzip ${MY_PSDK}.zip"
}

src_install() {
	# SDK makefile
	dodir /usr/$(get_libdir)/oracle/${PV}/client/rdbms/demo
	cd "${S}"/instantclient_11_2/sdk/demo
	mv demo.mk demo_xe.mk
	insinto /usr/$(get_libdir)/oracle/${PV}/client/rdbms/demo
	doins demo_xe.mk

	# library
	dodir /usr/$(get_libdir)/oracle/${PV}/client/lib
	cd "${S}"/instantclient_11_2
	insinto /usr/$(get_libdir)/oracle/${PV}/client/lib
	doins *.jar *.so *.so.11.1

	# fixes symlinks
	dosym /usr/$(get_libdir)/oracle/${PV}/client/lib/libocci.so.11.1 /usr/$(get_libdir)/oracle/${PV}/client/lib/libocci.so
	dosym /usr/$(get_libdir)/oracle/${PV}/client/lib/libclntsh.so.11.1 /usr/$(get_libdir)/oracle/${PV}/client/lib/libclntsh.so
	dosym /usr/$(get_libdir)/oracle/${PV}/client/include /usr/$(get_libdir)/oracle/${PV}/client/rdbms/public

	# includes
	dodir /usr/$(get_libdir)/oracle/${PV}/client/include
	insinto /usr/$(get_libdir)/oracle/${PV}/client/include
	cd "${S}"/instantclient_11_2/sdk/include
	# Remove ldap.h, #299562
	rm ldap.h || die "rm failed"
	doins *.h
	# link to original location
	dodir /usr/include/oracle/${PV}/
	ln -s "${D}"/usr/$(get_libdir)/oracle/${PV}/client/include "${D}"/usr/include/oracle/${PV}/client

	# share info
	cd "${S}"/instantclient_11_2/sdk/demo
	dodoc *

	# Add OCI libs to library path
	dodir /etc/env.d
	echo "ORACLE_HOME=/usr/$(get_libdir)/oracle/${PV}/client" >> "${D}"/etc/env.d/50oracle-instantclient-basic
	echo "LDPATH=/usr/$(get_libdir)/oracle/${PV}/client/lib" >> "${D}"/etc/env.d/50oracle-instantclient-basic
	echo "C_INCLUDE_PATH=/usr/$(get_libdir)/oracle/${PV}/client/include" >> "${D}"/etc/env.d/50oracle-instantclient-basic
	echo "TNS_ADMIN=/etc/oracle/" >> "${D}"/etc/env.d/50oracle-instantclient-basic

	# create path for tnsnames.ora
	dodir /etc/oracle
}

pkg_postinst() {
	elog "The Basic client package for Oracle 11g has been installed."
	elog "You may also wish to install the oracle-instantclient-jdbc (for"
	elog "supplemental JDBC functionality with Oracle) and the"
	elog "oracle-instantclient-sqlplus (for running the SQL*Plus application)"
	elog "packages as well."
	elog
	elog "Examples are located in /usr/share/doc/${PF}/"
	elog
	elog "TNS_ADMIN has been set to "${ROOT}"etc/oracle by default, put your"
	elog "tnsnames.ora there or configure TNS_ADMIN to point to"
	elog "your user specific configuration."
}
