# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib-minimal

MY_PLAT_x86="Linux x86"
MY_A_x86="${PN/oracle-/}-linux-${PV}.0.zip"

MY_PLAT_amd64="Linux x86-64"
MY_A_amd64="${PN/oracle-/}-linux.x64-${PV}.0.zip"

DESCRIPTION="Oracle 11g Instant Client: JDBC supplement"
HOMEPAGE="http://www.oracle.com/technetwork/database/features/instant-client/index.html"
SRC_URI="
	abi_x86_32? ( ${MY_A_x86}   )
	abi_x86_64? ( ${MY_A_amd64} )
"

LICENSE="OTN"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="fetch splitdebug"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="~dev-db/oracle-instantclient-basic-${PV}"

S="${WORKDIR}"

QA_PREBUILT="usr/lib*/oracle/${PV}/client/lib*/lib*"

set_my_abivars() {
	MY_PLAT=MY_PLAT_${ABI}; MY_PLAT=${!MY_PLAT} # platform name
	MY_A=MY_A_${ABI}      ; MY_A=${!MY_A}       # runtime distfile
	# ABI sourcedir
	MY_S="${S}/${ABI}/instantclient_11_2"

	[[ -n ${MY_PLAT} ]]
}

pkg_nofetch() {
	eerror "Please go to"
	eerror "  ${HOMEPAGE%/*}/index-097480.html"
	eerror "  and download"
	local ABI
	for ABI in $(multilib_get_enabled_abis)
	do
		set_my_abivars || continue
		eerror "Instant Client for ${MY_PLAT}"
		eerror "    JDBC: ${MY_A}"
	done
	eerror "After downloading, put them in:"
	eerror "    ${DISTDIR}/"
}

src_unpack() {
	local ABI
	for ABI in $(multilib_get_enabled_abis)
	do
		set_my_abivars || continue
		mkdir -p "${MY_S%/*}" || die
		cd "${MY_S%/*}" || die
		unpack ${MY_A}
	done
}

src_install() {
	# all binaries go here
	local oracle_home=/usr/$(get_libdir)/oracle/${PV}/client
	into "${oracle_home}"

	local ABI
	for ABI in $(multilib_get_enabled_abis)
	do
		if ! set_my_abivars; then
			elog "Skipping unsupported ABI ${ABI}."
			continue
		fi
		einfo "Installing runtime for ${MY_PLAT} ..."

		cd "${MY_S}" || die

		dolib.so lib*$(get_libname)*

		insinto "${oracle_home}"/$(get_libdir)
		doins *.jar

		eend $?
	done
}
