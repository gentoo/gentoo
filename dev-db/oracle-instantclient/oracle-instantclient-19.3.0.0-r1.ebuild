# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils pax-utils multilib-minimal

DESCRIPTION="Oracle 18c Instant Client with SDK"
HOMEPAGE="https://www.oracle.com/technetwork/database/database-technologies/instant-client/overview/index.html"

MY_SOVER=18.1 # the library soname found in the zip files

IUSE="jdbc odbc precomp +sdk +sqlplus tools"
REQUIRED_USE="precomp? ( sdk )"

MY_PVM=$(ver_cut 1-2)
MY_P="instantclient_$(ver_rs 1 _ ${MY_PVM})"

MY_PV=$(ver_cut 1-4)
MY_PVP=$(ver_cut 5) # p2

MY_PLAT_x86="Linux x86"
MY_BITS_x86=32
MY_A_x86="${PN/oracle-/}-basic-linux-${MY_PV}.0dbru.zip"
MY_A_x86_jdbc="${MY_A_x86/basic/jdbc}"
MY_A_x86_odbc="${MY_A_x86/basic/odbc}"
MY_A_x86_precomp="${MY_A_x86/basic/precomp}"
MY_A_x86_sdk="${MY_A_x86/basic/sdk}"
MY_A_x86_sqlplus="${MY_A_x86/basic/sqlplus}"
MY_A_x86_tools="${MY_A_x86/basic/tools}"

MY_PLAT_amd64="Linux x86-64"
MY_BITS_amd64=64
MY_A_amd64="${PN/oracle-}-basic-linux.x64-${MY_PV}.0dbru.zip"
MY_A_amd64_jdbc="${MY_A_amd64/basic/jdbc}"
MY_A_amd64_odbc="${MY_A_amd64/basic/odbc}"
MY_A_amd64_precomp="${MY_A_amd64/basic/precomp}"
MY_A_amd64_sdk="${MY_A_amd64/basic/sdk}"
MY_A_amd64_sqlplus="${MY_A_amd64/basic/sqlplus}"
MY_A_amd64_tools="${MY_A_amd64/basic/tools}"

if [[ ${MY_PVP} == p* ]]
then
	MY_PVP=-${MY_PVP#p}
	# Updated 9/22/2017: instantclient-odbc-linux-12.2.0.1.0-2.zip
	MY_A_x86_odbc="${MY_A_x86_odbc%.zip}${MY_PVP}.zip"
	MY_A_amd64_odbc="${MY_A_amd64_odbc%.zip}${MY_PVP}.zip"
fi

SRC_URI="
	abi_x86_32? (
		${MY_A_x86}
		jdbc?    ( ${MY_A_x86_jdbc}    )
		odbc?    ( ${MY_A_x86_odbc}    )
		precomp? ( ${MY_A_x86_precomp} )
		!abi_x86_64? (
			sdk?     ( ${MY_A_x86_sdk}     )
			sqlplus? ( ${MY_A_x86_sqlplus} )
			tools?   ( ${MY_A_x86_tools}   )
	) )
	abi_x86_64? (
		${MY_A_amd64}
		jdbc?    ( ${MY_A_amd64_jdbc}    )
		odbc?    ( ${MY_A_amd64_odbc}    )
		precomp? ( ${MY_A_amd64_precomp} )
		sdk?     ( ${MY_A_amd64_sdk}     )
		sqlplus? ( ${MY_A_amd64_sqlplus} )
		tools?   ( ${MY_A_amd64_tools}   )
	)
"

LICENSE="OTN"
SLOT="0/${MY_SOVER}"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch splitdebug"

DEPEND="app-arch/unzip"
RDEPEND="
	>=dev-libs/libaio-0.3.109-r5[${MULTILIB_USEDEP}]
	!<dev-db/oracle-instantclient-basic-12
	!<dev-db/oracle-instantclient-odbc-12
	!<dev-db/oracle-instantclient-jdbc-12
	!<dev-db/oracle-instantclient-sqlplus-12
"

S="${WORKDIR}/${MY_P}"

QA_PREBUILT="usr/lib*/oracle/client/*/*"

set_my_abivars() {
	if multilib_is_native_abi; then
		MY_WORKDIR="${WORKDIR}"
		MY_S="${S}"
	else
		MY_WORKDIR="${WORKDIR}/${ABI}"
		MY_S="${MY_WORKDIR}/${MY_P}"
	fi

	local abi=${ABI}
	[[ ${abi} == 'default' ]] && abi=${ARCH}
	MY_PLAT=MY_PLAT_${abi}          ; MY_PLAT=${!MY_PLAT}         # platform name
	MY_BITS=MY_BITS_${abi}          ; MY_BITS=${!MY_BITS}         # platform bitwidth
	MY_A=MY_A_${abi}                ; MY_A=${!MY_A}               # runtime distfile
	MY_A_jdbc=MY_A_${abi}_jdbc      ; MY_A_jdbc=${!MY_A_jdbc}       # jdbc distfile
	MY_A_odbc=MY_A_${abi}_odbc      ; MY_A_odbc=${!MY_A_odbc}       # odbc distfile
	MY_A_precomp=MY_A_${abi}_precomp; MY_A_precomp=${!MY_A_precomp} # precomp distfile
	MY_A_sdk=MY_A_${abi}_sdk        ; MY_A_sdk=${!MY_A_sdk}         # sdk distfile
	MY_A_sqlplus=MY_A_${abi}_sqlplus; MY_A_sqlplus=${!MY_A_sqlplus} # sqlplus distfile
	MY_A_tools=MY_A_${abi}_tools    ; MY_A_tools=${!MY_A_tools}     # tools distfile

	[[ -n ${MY_PLAT} ]]
}

oic_distfile_status() {
	: # We must not access DISTDIR in pkg_* phase, bug#612966.
# Not removing this lines yet, we may eventually specify this feature.
#	if [[ -r ${DISTDIR}/${1} ]]; then
#		echo "already here"
#	else
#		echo "still absent"
#	fi
}

pkg_nofetch() {
	eerror "Please go to"
	eerror "  ${HOMEPAGE//overview/downloads}"
	eerror "  and download"
	local ABI
	for ABI in $(multilib_get_enabled_abis)
	do
		set_my_abivars || continue
		eerror "Instant Client for ${MY_PLAT}"
		# convenient ordering like Linux x86-64 download site
		eerror "            Basic: $(oic_distfile_status ${MY_A}) ${MY_A}"
		use sqlplus && multilib_is_native_abi &&
		eerror "         SQL*Plus: $(oic_distfile_status ${MY_A_sqlplus}) ${MY_A_sqlplus}"
		use tools && multilib_is_native_abi &&
		eerror "            Tools: $(oic_distfile_status ${MY_A_tools}) ${MY_A_tools}"
		use sdk && multilib_is_native_abi &&
		eerror "              SDK: $(oic_distfile_status ${MY_A_sdk}) ${MY_A_sdk}"
		use jdbc &&
		eerror "             JDBC: $(oic_distfile_status ${MY_A_jdbc}) ${MY_A_jdbc}"
		use odbc &&
		eerror "             ODBC: $(oic_distfile_status ${MY_A_odbc}) ${MY_A_odbc}"
		use precomp &&
		eerror "      Precompiler: $(oic_distfile_status ${MY_A_precomp}) ${MY_A_precomp}"
	done
	eerror "After downloading these files (for *all* shown architectures),"
	eerror "put them in your DISTDIR filesystem directory."
}

src_unpack() {
	local ABI
	for ABI in $(multilib_get_enabled_abis)
	do
		set_my_abivars || continue
		mkdir -p "${MY_WORKDIR}" || die
		cd "${MY_WORKDIR}" || die
		unpack ${MY_A}
		use jdbc    && unpack ${MY_A_jdbc}
		use odbc    && unpack ${MY_A_odbc}
		use precomp && unpack ${MY_A_precomp}
		if multilib_is_native_abi; then
			use sdk     && unpack ${MY_A_sdk}
			use sqlplus && unpack ${MY_A_sqlplus}
			use tools   && unpack ${MY_A_tools}
		fi
	done
}

src_prepare() {
	local PATCHES=()
	if use precomp; then
		PATCHES+=( "${FILESDIR}"/18.3.0.0-proc-makefile.patch )
		# Not supporting COBOL for now
		rm -f sdk/demo/*procob*
	fi
	if use sdk; then
		PATCHES+=( "${FILESDIR}"/18.3.0.0-makefile.patch )
		rm sdk/include/ldap.h || die #299562
	fi
	default
}

# silence configure&compile messages from multilib-minimal
src_configure() { :; }
src_compile() { :; }

src_install() {
	# all content goes here without version number, bug#578402
	local oracle_home=/usr/$(get_libdir)/oracle/client
	local oracle_home_to_root=../../../.. # for dosym
	local ldpath=

	local ABI
	for ABI in $(multilib_get_enabled_abis) # last iteration is final ABI
	do
		if ! set_my_abivars; then
			elog "Skipping unsupported ABI ${ABI}."
			continue
		fi
		einfo "Installing runtime for ${MY_PLAT} ..."

		cd "${MY_S}" || die

		# shared libraries
		into "${oracle_home}"
		dolib.so lib*$(get_libname)*
		use precomp && dolib.a cobsqlintf.o

		# ensure to be linkable
		[[ -e libocci$(get_libname) ]] ||
		dosym libocci$(get_libname ${MY_SOVER}) \
			"${oracle_home}"/$(get_libdir)/libocci$(get_libname)
		[[ -e libclntsh$(get_libname) ]] ||
		dosym libclntsh$(get_libname ${MY_SOVER}) \
			"${oracle_home}"/$(get_libdir)/libclntsh$(get_libname)

		# java archives
		insinto "${oracle_home}"/$(get_libdir)
		doins *.jar

		# runtime library path
		ldpath+=${ldpath:+:}${oracle_home}/$(get_libdir)

		# Vanilla filesystem layout does not support multilib
		# installation, so we need to move the libs into the
		# ABI specific libdir.  However, ruby-oci8 build system
		# detects an instantclient along the shared libraries,
		# and does expect the sdk right there.
		use sdk && dosym ../sdk "${oracle_home}"/$(get_libdir)/sdk

		eend $?
	done

	local DOCS=( BASIC_README )
	local HTML_DOCS=()
	local paxbins=( adrci genezi uidrvci )
	local scripts=()

	if use jdbc; then
		DOCS+=( JDBC_README )
	fi
	if use odbc; then
		DOCS+=( ODBC_README )
		HTML_DOCS+=( help )
		scripts+=( odbc_update_ini.sh )
	fi
	if use precomp; then
		DOCS+=( PRECOMP_README )
		paxbins+=( sdk/proc )
		# Install pcscfg.cfg into /etc/oracle, as the user probably
		# wants to add the include path for the compiler headers
		# here and we do not want this to be overwritten.
		insinto /etc/oracle
		doins precomp/admin/pcscfg.cfg
		sed -i -e "s%^sys_include=.*%sys_include=(${oracle_home}/sdk/include,${EPREFIX}/usr/include)%" \
			"${ED}"/etc/oracle/pcscfg.cfg || die
		dosym ../../${oracle_home_to_root}/etc/oracle/pcscfg.cfg "${oracle_home}/precomp/admin/pcscfg.cfg"
		dosym ../.."${oracle_home}"/bin/proc /usr/bin/proc
		# Not supporting COBOL for now
		# paxbins+=( sdk/{procob,rtsora} )
		# doins precomp/admin/pcbcfg.cfg
	fi
	if use sdk; then
		einfo "Installing SDK ..."
		DOCS+=( SDK_README )
		scripts+=( sdk/ott )
		insinto "${oracle_home}"/$(get_libdir)
		doins sdk/ottclasses.zip
		insinto "${oracle_home}"/sdk
		doins -r sdk/{admin,demo,include}
		# Some build systems simply expect ORACLE_HOME/include.
		dosym sdk/include "${oracle_home}"/include
		# Some build systems do not know the instant client,
		# expecting headers in rdbms/public, see bug#669316.
		# Additionally, some (probably older ruby-oci8) do
		# require rdbms/public to be a real directory.
		insinto "${oracle_home}"/rdbms/public
		doins -r sdk/include/*
		# Others (like the DBD::Oracle perl module) know the Oracle
		# eXpress Edition's client, parsing an rdbms/demo/demo_xe.mk.
		dosym ../../sdk/demo/demo.mk "${oracle_home}"/rdbms/demo/demo_xe.mk
		# And some do expect /usr/include/oracle/<ver>/client/include,
		# querying 'sqlplus' for the version number, also see bug#652096.
		dosym ../../../.."${oracle_home}"/sdk/include /usr/include/oracle/${MY_PVM}/client
		eend $?
	fi
	if use sqlplus; then
		DOCS+=( SQLPLUS_README )
		paxbins+=( sqlplus )
		insinto "${oracle_home}"/sqlplus/admin
		doins glogin.sql
		dosym ../.."${oracle_home}"/bin/sqlplus /usr/bin/sqlplus
	fi
	if use tools; then
		DOCS+=( TOOLS_README )
		paxbins+=( exp expdp imp impdp sqlldr wrc )
	fi

	einfo "Installing binaries for ${MY_PLAT} ..."
	into "${oracle_home}"
	dobin ${paxbins[*]} ${scripts[*]}
	pushd "${ED}${oracle_home}/bin" >/dev/null || die
	pax-mark -c ${paxbins[*]#*/} || die
	popd >/dev/null || die
	eend $?

	einstalldocs

	# create path for tnsnames.ora
	insinto /etc/oracle
	doins "${FILESDIR}"/tnsnames.ora.sample

	# Add OCI libs to library path
	{
		echo "# ${EPREFIX}/etc/env.d/50${PN}"
		echo "# Do not edit this file, but 99${PN} instead"
		echo
		echo "ORACLE_HOME=${EPREFIX}${oracle_home}"
		echo "LDPATH=${ldpath}"
		echo "TNS_ADMIN=${EPREFIX}/etc/oracle/"
	} > "${T}"/50${PN}

	doenvd "${T}"/50${PN}

	# ensure ORACLE_HOME/lib exists
	[[ -e ${ED}${oracle_home}/lib/. ]] ||
	dosym $(get_libdir) "${oracle_home#/}"/lib
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
	elog "TNS_ADMIN has been set to ${EPREFIX}/etc/oracle by default,"
	elog "put your tnsnames.ora there or configure TNS_ADMIN"
	elog "to point to your user specific configuration."
	if use precomp; then
		elog ""
		elog "The proc precompiler uses the system library headers, which in"
		elog "turn include the headers of the used compiler."
		elog "To make proc work, please add the compiler header path of your"
		elog "preferred compiler to sys_include in:"
		elog "  ${EPREFIX}/etc/oracle/pcscfg.cfg"
		elog "Remember to update this setting when you switch or update the"
		elog "compiler."
		elog "For gcc, the headers are usually found in a path matching the"
		elog "following pattern:"
		elog "  ${EPREFIX}/usr/lib/gcc/*/*/include"
		elog "The exact details depend on the architecture and the version of"
		elog "the compiler to be used."
	fi
	ewarn "Please re-source your shell settings for ORACLE_HOME"
	ewarn "  changes, such as: source ${EPREFIX}/etc/profile"
}
