# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils versionator pax-utils multilib-minimal

MY_PVM=$(get_version_component_range 1-2)

MY_PLAT_x86="Linux x86"
MY_BITS_x86=32
MY_A_x86="${PN/oracle-/}-basic-linux-${PV}.0.zip"
MY_A_x86_sdk="${MY_A_x86/basic/sdk}"
MY_A_x86_odbc="${MY_A_x86/basic/odbc}"
MY_A_x86_jdbc="${MY_A_x86/basic/jdbc}"
MY_A_x86_sqlplus="${MY_A_x86/basic/sqlplus}"
MY_A_x86_tools="${MY_A_x86/basic/tools}"

MY_PLAT_amd64="Linux x86-64"
MY_BITS_amd64=64
MY_A_amd64="${PN/oracle-}-basic-linux.x64-${PV}.0.zip"
MY_A_amd64_sdk="${MY_A_amd64/basic/sdk}"
MY_A_amd64_odbc="${MY_A_amd64/basic/odbc}"
MY_A_amd64_jdbc="${MY_A_amd64/basic/jdbc}"
MY_A_amd64_sqlplus="${MY_A_amd64/basic/sqlplus}"
MY_A_amd64_tools="${MY_A_amd64/basic/tools}"

DESCRIPTION="Oracle 12c Instant Client with SDK"
HOMEPAGE="http://www.oracle.com/technetwork/database/features/instant-client/index.html"
SRC_URI="
	abi_x86_32? (
		${MY_A_x86}
		odbc? ( ${MY_A_x86_odbc} )
		jdbc? ( ${MY_A_x86_jdbc} )
		!abi_x86_64? (
			sdk?     ( ${MY_A_x86_sdk}     )
			sqlplus? ( ${MY_A_x86_sqlplus} )
			tools?   ( ${MY_A_x86_tools}   )
	) )
	abi_x86_64? (
		${MY_A_amd64}
		odbc?    ( ${MY_A_amd64_odbc}    )
		jdbc?    ( ${MY_A_amd64_jdbc}    )
		sdk?     ( ${MY_A_amd64_sdk}     )
		sqlplus? ( ${MY_A_amd64_sqlplus} )
		tools?   ( ${MY_A_amd64_tools}   )
	)
"

LICENSE="OTN"
SLOT="0/${MY_PVM}"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch splitdebug"
IUSE="jdbc odbc +sdk +sqlplus tools"

DEPEND="app-arch/unzip"
RDEPEND="
	>=dev-libs/libaio-0.3.109-r5[${MULTILIB_USEDEP}]
	!<dev-db/oracle-instantclient-basic-12
	!<dev-db/oracle-instantclient-odbc-12
	!<dev-db/oracle-instantclient-jdbc-12
	!<dev-db/oracle-instantclient-sqlplus-12
"

S="${WORKDIR}"

QA_PREBUILT="usr/lib*/oracle/*/client/lib*/lib*"

set_my_abivars() {
	S="${WORKDIR}/${ABI}/instantclient_$(
		replace_version_separator 1 "_" "${MY_PVM}"
	)"

	local abi=${ABI}
	[[ ${abi} == 'default' ]] && abi=${ARCH}
	MY_PLAT=MY_PLAT_${abi}          ; MY_PLAT=${!MY_PLAT}         # platform name
	MY_BITS=MY_BITS_${abi}          ; MY_BITS=${!MY_BITS}         # platform bitwidth
	MY_A=MY_A_${abi}                ; MY_A=${!MY_A}               # runtime distfile
	MY_A_sdk=MY_A_${abi}_sdk        ; MY_A_sdk=${!MY_A_sdk}         # sdk distfile
	MY_A_odbc=MY_A_${abi}_odbc      ; MY_A_odbc=${!MY_A_odbc}       # odbc distfile
	MY_A_jdbc=MY_A_${abi}_jdbc      ; MY_A_jdbc=${!MY_A_jdbc}       # jdbc distfile
	MY_A_sqlplus=MY_A_${abi}_sqlplus; MY_A_sqlplus=${!MY_A_sqlplus} # sqlplus distfile
	MY_A_tools=MY_A_${abi}_tools    ; MY_A_tools=${!MY_A_tools}     # tools distfile

	[[ -n ${MY_PLAT} ]]
}

oic_distfile_status() {
	if [[ -r ${DISTDIR}/${1} ]]; then
		echo "already here"
	else
		echo "still absent"
	fi
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
		eerror "    Basic: ($(oic_distfile_status ${MY_A})) ${MY_A}"
		use odbc &&
		eerror "     ODBC: ($(oic_distfile_status ${MY_A_odbc})) ${MY_A_odbc}"
		use jdbc &&
		eerror "     JDBC: ($(oic_distfile_status ${MY_A_jdbc})) ${MY_A_jdbc}"
		if multilib_is_native_abi; then
			use sdk &&
			eerror "      SDK: ($(oic_distfile_status ${MY_A_sdk})) ${MY_A_sdk}"
			use sqlplus &&
			eerror " SQL*Plus: ($(oic_distfile_status ${MY_A_sqlplus})) ${MY_A_sqlplus}"
			use tools &&
			eerror "      WRC: ($(oic_distfile_status ${MY_A_tools})) ${MY_A_tools}"
		fi
	done
	eerror "After downloading these files (for *all* shown architectures), put them in:"
	eerror "    ${DISTDIR}/"
}

src_unpack() {
	local ABI
	for ABI in $(multilib_get_enabled_abis)
	do
		set_my_abivars || continue
		mkdir "${WORKDIR}"/${ABI} || die
		cd "${WORKDIR}"/${ABI} || die
		unpack ${MY_A}
		use odbc && unpack ${MY_A_odbc}
		use jdbc && unpack ${MY_A_jdbc}
		if multilib_is_native_abi; then
			use sdk     && unpack ${MY_A_sdk}
			use sqlplus && unpack ${MY_A_sqlplus}
			use tools   && unpack ${MY_A_tools}
		fi
	done
}

src_prepare() {
	use sdk && PATCHES=( "${FILESDIR}"/12.1.0.2-makefile.patch )
	default
}

# silence configure&compile messages from multilib-minimal
src_configure() { :; }
src_compile() { :; }

src_install() {
	# all content goes here
	local oracle_home=usr/$(get_libdir)/oracle/${MY_PVM}/client
	into "/${oracle_home}"

	local ldpath= ABI
	for ABI in $(multilib_get_enabled_abis) # last iteration is final ABI
	do
		if ! set_my_abivars; then
			elog "Skipping unsupported ABI ${ABI}."
			continue
		fi
		einfo "Installing runtime for ${MY_PLAT} ..."

		cd "${S}" || die

		# shared libraries
		dolib.so lib*$(get_libname)*

		# ensure to be linkable
		[[ -e libocci$(get_libname) ]] ||
		dosym libocci$(get_libname ${MY_PVM}) \
			"/${oracle_home}"/$(get_libdir)/libocci$(get_libname)
		[[ -e libclntsh$(get_libname) ]] ||
		dosym libclntsh$(get_libname ${MY_PVM}) \
			"/${oracle_home}"/$(get_libdir)/libclntsh$(get_libname)

		# java archives
		insinto "/${oracle_home}"/$(get_libdir)
		doins *.jar

		# runtime library path
		ldpath+=${ldpath:+:}/${oracle_home}/$(get_libdir)

		eend $?
	done

	local DOCS=()
	local HTML_DOCS=()
	local paxbins=( adrci genezi uidrvci )
	local scripts=()

	use sqlplus && paxbins+=( sqlplus )
	use tools   && paxbins+=( wrc )

	if use odbc; then
		scripts+=( odbc_update_ini.sh )
		HTML_DOCS+=( ODBC_IC_Readme_Unix.html help )
	fi

	einfo "Installing binaries for ${MY_PLAT} ..."
	dobin ${paxbins[@]} ${scripts}
	cd "${ED}${oracle_home}"/bin || die
	pax-mark -c ${paxbins[@]} || die
	cd "${S}" || die
	eend $?

	if use sqlplus; then
		insinto "/${oracle_home}"/sqlplus/admin
		doins glogin.sql
		dosym "/${oracle_home}"/bin/sqlplus /usr/bin/sqlplus
	fi

	if use sdk; then
		einfo "Installing SDK ..."

		DOCS+=( sdk/demo )
		cd "${S}"/sdk || die

		# SDK makefile, for #165834
		# As we change the relative filesystem layout compared
		# to vanilla instantclient.zip content, it feels easier
		# to fake the layout found in Oracle eXpress Edition.
		# Both layouts are known to DBD::Oracle (cpan).
		insinto "/${oracle_home}"/rdbms/demo
		newins demo/demo.mk demo_xe.mk

		# Remove ldap.h, #299562
		rm include/ldap.h || die
		# DBD::Oracle needs rdbms/public as real directory
		insinto "/${oracle_home}"/rdbms/public
		doins include/*.h
		dosym rdbms/public "/${oracle_home}"/include
		# ruby-oci8 expects the headers here
		dosym "/${oracle_home}"/rdbms/public /usr/include/oracle/${MY_PVM}/client

		# ott
		insinto "/${oracle_home}"/$(get_libdir)
		dobin ott
		doins *.zip

		# more files found in the zip
		insinto "/${oracle_home}"/admin
		doins admin/oraaccess.xsd

		eend $?
	fi

	cd "${S}" || die
	einstalldocs

	# create path for tnsnames.ora
	insinto /etc/oracle
	doins "${FILESDIR}"/tnsnames.ora.sample

	# Add OCI libs to library path
	{
		echo "# ${EPREFIX}/etc/env.d/50${PN}"
		echo "# Do not edit this file, but 99${PN} instead"
		echo
		echo "ORACLE_HOME=${EPREFIX}/${oracle_home}"
		echo "LDPATH=${ldpath}"
		echo "TNS_ADMIN=/etc/oracle/"
	} > "${T}"/50${PN}

	doenvd "${T}"/50${PN}

	# ensure ORACLE_HOME/lib exists
	[[ -e ${ED}${oracle_home}/lib/. ]] ||
	dosym $(get_libdir) "${oracle_home}"/lib
}

pkg_preinst() {
	if [[ -r ${EROOT}/etc/env.d/99${PN} ]]; then
		cp "${EROOT}/etc/env.d/99${PN}" "${ED}/etc/env.d/" || die
	else
		{
			echo "# ${EPREFIX}/etc/env.d/99${PN}"
			echo "# Configure system-wide defaults for your Oracle Instant Client here"
			echo
			echo "#$(grep '^ORACLE_HOME=' "${ED}/etc/env.d/50${PN}")"
			echo "#$(grep '^TNS_ADMIN=' "${ED}/etc/env.d/50${PN}")"
			echo "#NLS_LANG="
		} > "${ED}/etc/env.d/99${PN}"
	fi
}

pkg_postinst() {
	elog "${P} does not provide an sqlnet.ora"
	elog "configuration file, redirecting oracle diagnostics for database-"
	elog "and network-issues into ~USER/oradiag_USER/ instead."
	elog "It should be safe to ignore this message in sqlnet.log there:"
	elog "   Directory does not exist for read/write [ORACLE_HOME/client/log] []"
	elog "See https://bugs.gentoo.org/show_bug.cgi?id=465252 for reference."
	elog "If you want to directly analyse low-level debug info or don't want"
	elog "to see it at all, so you really need an sqlnet.ora file, please"
	elog "consult http://search.oracle.com/search/search?q=sqlnet.ora"
	elog ""
	elog "TNS_ADMIN has been set to ${EROOT}etc/oracle by default,"
	elog "put your tnsnames.ora there or configure TNS_ADMIN"
	elog "to point to your user specific configuration."
	ewarn "Please re-source your shell settings for ORACLE_HOME"
	ewarn "  changes, such as: source /etc/profile"
}
