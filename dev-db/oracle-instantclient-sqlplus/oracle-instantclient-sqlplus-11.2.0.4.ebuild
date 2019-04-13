# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils pax-utils

MY_PLAT_x86="Linux x86"
MY_A_x86="${PN#oracle-}-linux-${PV}.0.zip"

MY_PLAT_amd64="Linux x86-64"
MY_A_amd64="${PN#oracle-}-linux.x64-${PV}.0.zip"

DESCRIPTION="Oracle 11g Instant Client: SQL*Plus"
HOMEPAGE="http://www.oracle.com/technetwork/database/features/instant-client/index.html"
SRC_URI="
	x86?   ( ${MY_A_x86}   )
	amd64? ( ${MY_A_amd64} )
"

LICENSE="OTN"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="fetch splitdebug"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="~dev-db/oracle-instantclient-basic-${PV}"

S="${WORKDIR}"/instantclient_11_2

QA_PREBUILT="
	usr/lib*/oracle/${PV}/client/lib*/lib*
	usr/lib*/oracle/${PV}/client/bin/sqlplus
"

my_arch() {
	# platform name
	MY_PLAT=MY_PLAT_${ARCH}
	export MY_PLAT=${!MY_PLAT}
	# distfile
	MY_A=MY_A_${ARCH}
	export MY_A=${!MY_A}
}

pkg_nofetch() {
	my_arch
	eerror "Please go to"
	eerror "  ${HOMEPAGE%/*}/index-097480.html"
	eerror "  and download"
	eerror "Instant Client for ${MY_PLAT}"
	eerror "    SQL*Plus: ${MY_A}"
	eerror "After downloading, put it into your DISTDIR directory."
}

src_install() {
	# all binaries go here
	local oracle_home=usr/$(get_libdir)/oracle/${PV}/client
	into /"${oracle_home}"

	dolib.so libsqlplus$(get_libname) libsqlplusic$(get_libname)
	dobin sqlplus

	insinto /"${oracle_home}"/sqlplus/admin
	doins glogin.sql

	pax-mark -c "${ED}${oracle_home}"/bin/sqlplus || die

	dosym /"${oracle_home}"/bin/sqlplus /usr/bin/sqlplus
}
