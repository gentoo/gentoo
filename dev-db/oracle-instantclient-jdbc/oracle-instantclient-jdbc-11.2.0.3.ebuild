# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/oracle-instantclient-jdbc/oracle-instantclient-jdbc-11.2.0.3.ebuild,v 1.7 2012/11/15 19:50:09 haubi Exp $

EAPI="4"

inherit eutils multilib

MY_PLAT_x86="Linux x86"
MY_A_x86="${PN/oracle-/}-linux-${PV}.0.zip"

MY_PLAT_amd64="Linux x86-64"
MY_A_amd64="${PN/oracle-/}-linux.x64-${PV}.0.zip"

DESCRIPTION="Oracle 11g Instant Client: JDBC supplement"
HOMEPAGE="http://www.oracle.com/technetwork/database/features/instant-client/index.html"
SRC_URI="
	x86?   ( ${MY_A_x86}                             )
	amd64? ( ${MY_A_amd64} multilib? ( ${MY_A_x86} ) )
"

LICENSE="OTN"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="fetch"
IUSE="multilib"

DEPEND="app-arch/unzip"
RDEPEND="~dev-db/oracle-instantclient-basic-${PV}"

S="${WORKDIR}"

QA_PREBUILT="usr/lib*/oracle/${PV}/client/lib*/lib*"

default_abi() {
	[[ ${DEFAULT_ABI} == 'default' ]] && echo ${ARCH} || echo ${DEFAULT_ABI}
}

abi_list() {
	if use multilib; then
		echo ${MULTILIB_ABIS}
	else
		default_abi
	fi
	return 0
}

set_abivars() {
	local abi=$1
	# platform name
	MY_PLAT=MY_PLAT_${abi}
	MY_PLAT=${!MY_PLAT}
	# runtime distfile
	MY_A=MY_A_${abi}
	MY_A=${!MY_A}
	# abi sourcedir
	MY_S="${S}/${abi}/instantclient_11_2"
	# ABI might not need to be set at all
	[[ -n ${ABI} ]] && MY_ABI=${abi} || MY_ABI=
	# abi libdir
	MY_LIBDIR=$(ABI=${MY_ABI} get_libdir)
}

pkg_nofetch() {
	eerror "Please go to"
	eerror "  ${HOMEPAGE%/*}/index-097480.html"
	eerror "  and download"
	local abi
	for abi in $(abi_list)
	do
		set_abivars ${abi}
		eerror "Instant Client for ${MY_PLAT}"
		eerror "    JDBC: ${MY_A}"
	done
	eerror "After downloading, put them in:"
	eerror "    ${DISTDIR}/"
}

src_unpack() {
	local abi
	for abi in $(abi_list)
	do
		set_abivars ${abi}
		mkdir -p "${MY_S%/*}" || die
		cd "${MY_S%/*}" || die
		unpack ${MY_A}
	done
}

src_install() {
	# all binaries go here
	local oracle_home=/usr/$(get_libdir)/oracle/${PV}/client
	into "${oracle_home}"

	local abi
	for abi in $(abi_list)
	do
		set_abivars ${abi}
		einfo "Installing runtime for ${MY_PLAT} ..."

		cd "${MY_S}" || die

		ABI=${MY_ABI} dolib.so lib*$(get_libname)*

		insinto "${oracle_home}"/${MY_LIBDIR}
		doins *.jar

		eend $?
	done
}
