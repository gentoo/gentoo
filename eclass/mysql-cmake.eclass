# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: mysql-cmake.eclass
# @MAINTAINER:
# Maintainers:
#	- MySQL Team <mysql-bugs@gentoo.org>
#	- Robin H. Johnson <robbat2@gentoo.org>
#	- Jorge Manuel B. S. Vicetto <jmbsvicetto@gentoo.org>
#	- Brian Evans <grknight@gentoo.org>
# @BLURB: This eclass provides the support for cmake based mysql releases
# @DESCRIPTION:
# The mysql-cmake.eclass provides the support to build the mysql
# ebuilds using the cmake build system. This eclass provides
# the src_prepare, src_configure, src_compile, and src_install
# phase hooks.

inherit cmake-utils flag-o-matic multilib prefix eutils toolchain-funcs

#
# HELPER FUNCTIONS:
#

# @FUNCTION: mysql_cmake_disable_test
# @DESCRIPTION:
# Helper function to disable specific tests.
mysql-cmake_disable_test() {

	local rawtestname testname testsuite reason mysql_disabled_file mysql_disabled_dir
	rawtestname="${1}" ; shift
	reason="${@}"
	ewarn "test '${rawtestname}' disabled: '${reason}'"

	testsuite="${rawtestname/.*}"
	testname="${rawtestname/*.}"
	for mysql_disabled_file in \
		${S}/mysql-test/disabled.def \
		${S}/mysql-test/t/disabled.def ; do
		[[ -f ${mysql_disabled_file} ]] && break
	done
	#mysql_disabled_file="${S}/mysql-test/t/disabled.def"
	#einfo "rawtestname=${rawtestname} testname=${testname} testsuite=${testsuite}"
	echo ${testname} : ${reason} >> "${mysql_disabled_file}"

	if [[ ( -n ${testsuite} ) && ( ${testsuite} != "main" ) ]]; then
		for mysql_disabled_file in \
			${S}/mysql-test/suite/${testsuite}/disabled.def \
			${S}/mysql-test/suite/${testsuite}/t/disabled.def \
			FAILED ; do
			[[ -f ${mysql_disabled_file} ]] && break
		done
		if [[ ${mysql_disabled_file} != "FAILED" ]]; then
			echo "${testname} : ${reason}" >> "${mysql_disabled_file}"
		else
			for mysql_disabled_dir in \
				${S}/mysql-test/suite/${testsuite} \
				${S}/mysql-test/suite/${testsuite}/t \
				FAILED ; do
				[[ -d ${mysql_disabled_dir} ]] && break
			done
			if [[ ${mysql_disabled_dir} != "FAILED" ]]; then
				echo "${testname} : ${reason}" >> "${mysql_disabled_dir}/disabled.def"
			else
				ewarn "Could not find testsuite disabled.def location for ${rawtestname}"
			fi
		fi
	fi
}

# @FUNCTION: mysql-cmake_use_plugin
# @DESCRIPTION:
# Helper function to enable/disable plugins by use flags
# cmake-utils_use_with is not enough as some references check WITH_ (0|1)
# and some check WITHOUT_. Also, this can easily extend to non-storage plugins.
mysql-cmake_use_plugin() {
	[[ -z $2 ]] && die "mysql-cmake_use_plugin <USE flag> <flag name>"
	if use_if_iuse $1 ; then
		echo "-DWITH_$2=1 -DPLUGIN_$2=YES"
	else
		echo "-DWITHOUT_$2=1 -DWITH_$2=0 -DPLUGIN_$2=NO"
	fi
}

# @FUNCTION: configure_cmake_locale
# @DESCRIPTION:
# Helper function to configure locale cmake options
configure_cmake_locale() {

	if use_if_iuse minimal ; then
		:
	elif ! in_iuse server || use_if_iuse server ; then
		if [[ ( -n ${MYSQL_DEFAULT_CHARSET} ) && ( -n ${MYSQL_DEFAULT_COLLATION} ) ]]; then
			ewarn "You are using a custom charset of ${MYSQL_DEFAULT_CHARSET}"
			ewarn "and a collation of ${MYSQL_DEFAULT_COLLATION}."
			ewarn "You MUST file bugs without these variables set."

			mycmakeargs+=(
				-DDEFAULT_CHARSET=${MYSQL_DEFAULT_CHARSET}
				-DDEFAULT_COLLATION=${MYSQL_DEFAULT_COLLATION}
			)

		elif ! use latin1 ; then
			mycmakeargs+=(
				-DDEFAULT_CHARSET=utf8
				-DDEFAULT_COLLATION=utf8_general_ci
			)
		else
			mycmakeargs+=(
				-DDEFAULT_CHARSET=latin1
				-DDEFAULT_COLLATION=latin1_swedish_ci
			)
		fi
	fi
}

# @FUNCTION: configure_cmake_minimal
# @DESCRIPTION:
# Helper function to configure minimal build
configure_cmake_minimal() {

	mycmakeargs+=(
		-DWITHOUT_SERVER=1
		-DWITHOUT_EMBEDDED_SERVER=1
		-DEXTRA_CHARSETS=none
		-DINSTALL_SQLBENCHDIR=
		-DWITHOUT_ARCHIVE_STORAGE_ENGINE=1
		-DWITHOUT_BLACKHOLE_STORAGE_ENGINE=1
		-DWITHOUT_CSV_STORAGE_ENGINE=1
		-DWITHOUT_FEDERATED_STORAGE_ENGINE=1
		-DWITHOUT_HEAP_STORAGE_ENGINE=1
		-DWITHOUT_INNOBASE_STORAGE_ENGINE=1
		-DWITHOUT_MYISAMMRG_STORAGE_ENGINE=1
		-DWITHOUT_MYISAM_STORAGE_ENGINE=1
		-DWITHOUT_PARTITION_STORAGE_ENGINE=1
		-DPLUGIN_ARCHIVE=NO
		-DPLUGIN_BLACKHOLE=NO
		-DPLUGIN_CSV=NO
		-DPLUGIN_FEDERATED=NO
		-DPLUGIN_HEAP=NO
		-DPLUGIN_INNOBASE=NO
		-DPLUGIN_MYISAMMRG=NO
		-DPLUGIN_MYISAM=NO
		-DPLUGIN_PARTITION=NO
	)
}

# @FUNCTION: configure_cmake_standard
# @DESCRIPTION:
# Helper function to configure standard build
configure_cmake_standard() {

	mycmakeargs+=(
		-DEXTRA_CHARSETS=all
		-DMYSQL_USER=mysql
		-DMYSQL_UNIX_ADDR=${EPREFIX}/var/run/mysqld/mysqld.sock
		$(cmake-utils_use_disable !static SHARED)
		$(cmake-utils_use_with debug)
		$(cmake-utils_use_with embedded EMBEDDED_SERVER)
		$(cmake-utils_use_with profiling)
		$(cmake-utils_use_enable systemtap DTRACE)
	)

	if use static; then
		mycmakeargs+=( -DWITH_PIC=1 )
	fi

	if use jemalloc; then
		mycmakeargs+=( -DWITH_SAFEMALLOC=OFF )
	fi

	if use tcmalloc; then
		mycmakeargs+=( -DWITH_SAFEMALLOC=OFF )
	fi

	# Storage engines
	mycmakeargs+=(
		-DWITH_ARCHIVE_STORAGE_ENGINE=1
		-DWITH_BLACKHOLE_STORAGE_ENGINE=1
		-DWITH_CSV_STORAGE_ENGINE=1
		-DWITH_HEAP_STORAGE_ENGINE=1
		-DWITH_INNOBASE_STORAGE_ENGINE=1
		-DWITH_MYISAMMRG_STORAGE_ENGINE=1
		-DWITH_MYISAM_STORAGE_ENGINE=1
		-DWITH_PARTITION_STORAGE_ENGINE=1
	)

	if in_iuse pbxt ; then
		mycmakeargs+=( $(cmake-utils_use_with pbxt PBXT_STORAGE_ENGINE) )
	fi

	if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]]; then

		# Federated{,X} must be treated special otherwise they will not be built as plugins
		if ! use extraengine ; then
			mycmakeargs+=(
				-DWITHOUT_FEDERATED_STORAGE_ENGINE=1
				-DPLUGIN_FEDERATED=NO
				-DWITHOUT_FEDERATEDX_STORAGE_ENGINE=1
				-DPLUGIN_FEDERATEDX=NO )
		fi

		mycmakeargs+=(
			$(mysql-cmake_use_plugin oqgraph OQGRAPH)
			$(mysql-cmake_use_plugin sphinx SPHINX)
			$(mysql-cmake_use_plugin tokudb TOKUDB)
			$(mysql-cmake_use_plugin pam AUTH_PAM)
		)

		if mysql_version_is_at_least 10.0.5 ; then
			# CassandraSE needs Apache Thrift which is not in portage
			mycmakeargs+=(
				-DWITHOUT_CASSANDRA=1 -DWITH_CASSANDRA=0
				-DPLUGIN_CASSANDRA=NO
				$(mysql-cmake_use_plugin extraengine SEQUENCE)
				$(mysql-cmake_use_plugin extraengine SPIDER)
				$(mysql-cmake_use_plugin extraengine CONNECT)
				-DCONNECT_WITH_MYSQL=1
				$(cmake-utils_use xml CONNECT_WITH_LIBXML2)
				$(cmake-utils_use odbc CONNECT_WITH_ODBC)
			)
		fi

		if in_iuse mroonga ; then
			use mroonga || mycmakeargs+=( -DWITHOUT_MROONGA=1 )
		else
			mycmakeargs+=( -DWITHOUT_MROONGA=1 )
		fi

		if in_iuse galera ; then
			mycmakeargs+=( $(cmake-utils_use_with galera WSREP) )
		fi

		if mysql_version_is_at_least "10.1.1" ; then
			mycmakeargs+=(  $(cmake-utils_use_with innodb-lz4 INNODB_LZ4)
					$(cmake-utils_use_with innodb-lzo INNODB_LZO) )
		fi

		if in_iuse innodb-snappy ; then
			mycmakeargs+=( $(cmake-utils_use_with innodb-snappy INNODB_SNAPPY)  )
		fi

		if mysql_version_is_at_least "10.1.2" ; then
			mycmakeargs+=( $(mysql-cmake_use_plugin cracklib CRACKLIB_PASSWORD_CHECK ) )
		fi

		# The build forces this to be defined when cross-compiling.  We pass it
		# all the time for simplicity and to make sure it is actually correct.
		mycmakeargs+=( -DSTACK_DIRECTION=$(tc-stack-grows-down && echo -1 || echo 1) )
	else
		mycmakeargs+=( $(cmake-utils_use_with extraengine FEDERATED_STORAGE_ENGINE) )
	fi

	if [[ ${PN} == "percona-server" ]]; then
		mycmakeargs+=(
			$(cmake-utils_use_with pam PAM)
		)
		if in_iuse tokudb ; then
			# TokuDB Backup plugin requires valgrind unconditionally
			mycmakeargs+=(
				$(mysql-cmake_use_plugin tokudb TOKUDB)
				$(usex tokudb-backup-plugin "" -DTOKUDB_BACKUP_DISABLED=1)
			)
		fi
	fi

	if [[ ${PN} == "mysql-cluster" ]]; then
		# TODO: This really should include the following options,
		# but the memcached package doesn't install the files it seeks.
		# -DWITH_BUNDLED_MEMCACHED=OFF
		# -DMEMCACHED_HOME=${EPREFIX}/usr
		mycmakeargs+=(
			-DWITH_BUNDLED_LIBEVENT=OFF
			$(cmake-utils_use_with java NDB_JAVA)
		)
	fi
}

#
# EBUILD FUNCTIONS
#

# @FUNCTION: mysql-cmake_src_prepare
# @DESCRIPTION:
# Apply patches to the source code and remove unneeded bundled libs.
mysql-cmake_src_prepare() {

	debug-print-function ${FUNCNAME} "$@"

	cd "${S}"

	if [[ ${MY_EXTRAS_VER} != none ]]; then

		# Apply the patches for this MySQL version
		EPATCH_SUFFIX="patch"
		mkdir -p "${EPATCH_SOURCE}" || die "Unable to create epatch directory"
		# Clean out old items
		rm -f "${EPATCH_SOURCE}"/*
		# Now link in right patches
		mysql_mv_patches
		# And apply
		epatch
	fi

	# last -fPIC fixup, per bug #305873
	i="${S}"/storage/innodb_plugin/plug.in
	[[ -f ${i} ]] && sed -i -e '/CFLAGS/s,-prefer-non-pic,,g' "${i}"

	rm -f "scripts/mysqlbug"
	if use jemalloc && ! ( [[ ${PN} == "mariadb" ]] && mysql_version_is_at_least "5.5.33" ); then
		echo "TARGET_LINK_LIBRARIES(mysqld jemalloc)" >> "${S}/sql/CMakeLists.txt" || die
	fi

	if use tcmalloc; then
		echo "TARGET_LINK_LIBRARIES(mysqld tcmalloc)" >> "${S}/sql/CMakeLists.txt"
	fi

	if in_iuse tokudb ; then
		# Don't build bundled xz-utils
		if [[ -d "${S}/storage/tokudb/ft-index" ]] ; then
			rm -f "${S}/storage/tokudb/ft-index/cmake_modules/TokuThirdParty.cmake" || die
			touch "${S}/storage/tokudb/ft-index/cmake_modules/TokuThirdParty.cmake" || die
			sed -i 's/ build_lzma//' "${S}/storage/tokudb/ft-index/ft/CMakeLists.txt" || die
		elif [[ -d "${S}/storage/tokudb/PerconaFT" ]] ; then
			rm "${S}/storage/tokudb/PerconaFT/cmake_modules/TokuThirdParty.cmake" || die
			touch "${S}/storage/tokudb/PerconaFT/cmake_modules/TokuThirdParty.cmake" || die
			sed -i -e 's/ build_lzma//' -e 's/ build_snappy//' "${S}/storage/tokudb/PerconaFT/ft/CMakeLists.txt" || die
			sed -i -e 's/add_dependencies\(tokuportability_static_conv build_jemalloc\)//' "${S}/storage/tokudb/PerconaFT/portability/CMakeLists.txt" || die
		fi

		if [[ -d "${S}/plugin/tokudb-backup-plugin" ]] && ! use tokudb-backup-plugin ; then
			 rm -r "${S}/plugin/tokudb-backup-plugin/Percona-TokuBackup" || die
		fi
	fi

	# Remove the bundled groonga if it exists
	# There is no CMake flag, it simply checks for existance
	if [[ -d "${S}"/storage/mroonga/vendor/groonga ]] ; then
		rm -r "${S}"/storage/mroonga/vendor/groonga || die "could not remove packaged groonga"
	fi

	epatch_user
}

# @FUNCTION: mysql-cmake_src_configure
# @DESCRIPTION:
# Configure mysql to build the code for Gentoo respecting the use flags.
mysql-cmake_src_configure() {

	debug-print-function ${FUNCNAME} "$@"

	CMAKE_BUILD_TYPE="RelWithDebInfo"

	# debug hack wrt #497532
	mycmakeargs=(
		-DCMAKE_C_FLAGS_RELWITHDEBINFO="$(usex debug "" "-DNDEBUG")"
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO="$(usex debug "" "-DNDEBUG")"
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
		-DMYSQL_DATADIR=${EPREFIX}/var/lib/mysql
		-DSYSCONFDIR=${EPREFIX}/etc/mysql
		-DINSTALL_BINDIR=bin
		-DINSTALL_DOCDIR=share/doc/${P}
		-DINSTALL_DOCREADMEDIR=share/doc/${P}
		-DINSTALL_INCLUDEDIR=include/mysql
		-DINSTALL_INFODIR=share/info
		-DINSTALL_LIBDIR=$(get_libdir)
		-DINSTALL_ELIBDIR=$(get_libdir)/mysql
		-DINSTALL_MANDIR=share/man
		-DINSTALL_MYSQLDATADIR=${EPREFIX}/var/lib/mysql
		-DINSTALL_MYSQLSHAREDIR=share/mysql
		-DINSTALL_MYSQLTESTDIR=share/mysql/mysql-test
		-DINSTALL_PLUGINDIR=$(get_libdir)/mysql/plugin
		-DINSTALL_SBINDIR=sbin
		-DINSTALL_SCRIPTDIR=share/mysql/scripts
		-DINSTALL_SQLBENCHDIR=share/mysql
		-DINSTALL_SUPPORTFILESDIR=${EPREFIX}/usr/share/mysql
		-DWITH_COMMENT="Gentoo Linux ${PF}"
		$(cmake-utils_use_with test UNIT_TESTS)
		-DWITH_LIBEDIT=0
		-DWITH_ZLIB=system
		-DWITHOUT_LIBWRAP=1
		-DENABLED_LOCAL_INFILE=1
		$(cmake-utils_use_enable static-libs STATIC_LIBS)
		-DWITH_SSL=$(usex ssl system bundled)
		-DWITH_DEFAULT_COMPILER_OPTIONS=0
		-DWITH_DEFAULT_FEATURE_SET=0
	)

	if in_iuse bindist ; then
		mycmakeargs+=(
			-DWITH_READLINE=$(usex bindist 1 0)
			-DNOT_FOR_DISTRIBUTION=$(usex bindist 0 1)
			$(usex bindist -DHAVE_BFD_H=0 '')
		)
	fi

	mycmakeargs+=( -DWITH_EDITLINE=system )

	if [[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]] ; then
		mycmakeargs+=(
			-DWITH_JEMALLOC=$(usex jemalloc system)
		)
		mysql_version_is_at_least "10.0.9" && mycmakeargs+=( -DWITH_PCRE=system )
	fi

	configure_cmake_locale

	if use_if_iuse minimal ; then
		configure_cmake_minimal
	else
		configure_cmake_standard
	fi

	# Bug #114895, bug #110149
	filter-flags "-O" "-O[01]"

	CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	CXXFLAGS="${CXXFLAGS} -felide-constructors"
	# Causes linkage failures. Upstream bug #59607 removes it
	if ! mysql_version_is_at_least "5.6" ; then
		CXXFLAGS="${CXXFLAGS} -fno-implicit-templates"
	fi
	# As of 5.7, exceptions and rtti are used!
	if [[ ${PN} -eq 'percona-server' ]] && mysql_version_is_at_least "5.6.26" ; then
		CXXFLAGS="${CXXFLAGS} -fno-rtti"
	elif ! mysql_version_is_at_least "5.7" ; then
		CXXFLAGS="${CXXFLAGS} -fno-exceptions -fno-rtti"
	fi
	export CXXFLAGS

	# bug #283926, with GCC4.4, this is required to get correct behavior.
	append-flags -fno-strict-aliasing

	cmake-utils_src_configure
}

# @FUNCTION: mysql-cmake_src_compile
# @DESCRIPTION:
# Compile the mysql code.
mysql-cmake_src_compile() {

	debug-print-function ${FUNCNAME} "$@"

	cmake-utils_src_compile
}

# @FUNCTION: mysql-cmake_src_install
# @DESCRIPTION:
# Install mysql.
mysql-cmake_src_install() {

	debug-print-function ${FUNCNAME} "$@"

	# Make sure the vars are correctly initialized
	mysql_init_vars

	cmake-utils_src_install

	if ! in_iuse tools || use_if_iuse tools ; then
		# Convenience links
		einfo "Making Convenience links for mysqlcheck multi-call binary"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqlanalyze"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqlrepair"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqloptimize"
	fi

	# Create a mariadb_config symlink
	[[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]] && dosym "/usr/bin/mysql_config" "/usr/bin/mariadb_config"

	# INSTALL_LAYOUT=STANDALONE causes cmake to create a /usr/data dir
	rm -Rf "${ED}/usr/data"

	# Various junk (my-*.cnf moved elsewhere)
	einfo "Removing duplicate /usr/share/mysql files"

	# Unless they explicitly specific USE=test, then do not install the
	# testsuite. It DOES have a use to be installed, esp. when you want to do a
	# validation of your database configuration after tuning it.
	if ! use test ; then
		rm -rf "${D}"/${MY_SHAREDSTATEDIR}/mysql-test
	fi

	# Configuration stuff
	case ${MYSQL_PV_MAJOR} in
		5.[1-4]*) mysql_mycnf_version="5.1" ;;
		5.5) mysql_mycnf_version="5.5" ;;
		5.[6-9]|6*|7*|8*|9*|10*) mysql_mycnf_version="5.6" ;;
	esac
	einfo "Building default my.cnf (${mysql_mycnf_version})"
	insinto "${MY_SYSCONFDIR#${EPREFIX}}"
	[[ -f "${S}/scripts/mysqlaccess.conf" ]] && doins "${S}"/scripts/mysqlaccess.conf
	mycnf_src="my.cnf-${mysql_mycnf_version}"
	sed -e "s!@DATADIR@!${MY_DATADIR}!g" \
		"${FILESDIR}/${mycnf_src}" \
		> "${TMPDIR}/my.cnf.ok" || die
	use prefix && sed -i -r -e '/^user[[:space:]]*=[[:space:]]*mysql$/d' "${TMPDIR}/my.cnf.ok"
	if use latin1 ; then
		sed -i \
			-e "/character-set/s|utf8|latin1|g" \
			"${TMPDIR}/my.cnf.ok" || die
	fi
	eprefixify "${TMPDIR}/my.cnf.ok"
	newins "${TMPDIR}/my.cnf.ok" my.cnf

	# Minimal builds don't have the MySQL server
	if use_if_iuse minimal ; then
		:
	elif ! in_iuse server || use_if_iuse server ; then
		einfo "Creating initial directories"
		# Empty directories ...
		diropts "-m0750"
		if [[ ${PREVIOUS_DATADIR} != "yes" ]] ; then
			dodir "${MY_DATADIR#${EPREFIX}}"
			keepdir "${MY_DATADIR#${EPREFIX}}"
			chown -R mysql:mysql "${D}/${MY_DATADIR}"
		fi

		diropts "-m0755"
		for folder in "${MY_LOGDIR#${EPREFIX}}" ; do
			dodir "${folder}"
			keepdir "${folder}"
			chown -R mysql:mysql "${ED}/${folder}"
		done
	fi

	# Minimal builds don't have the MySQL server
	if use_if_iuse minimal ; then
		:
	elif ! in_iuse server || use_if_iuse server; then
		einfo "Including support files and sample configurations"
		docinto "support-files"
		for script in \
			"${S}"/support-files/my-*.cnf.sh \
			"${S}"/support-files/magic \
			"${S}"/support-files/ndb-config-2-node.ini.sh
		do
			[[ -f $script ]] && dodoc "${script}"
		done

		docinto "scripts"
		for script in "${S}"/scripts/mysql* ; do
			[[ ( -f $script ) && ( ${script%.sh} == ${script} ) ]] && dodoc "${script}"
		done
	fi

	#Remove mytop if perl is not selected
	[[ ${PN} == "mariadb" || ${PN} == "mariadb-galera" ]] && ! use perl \
	&& rm -f "${ED}/usr/bin/mytop"

	in_iuse client-libs && ! use client-libs && return

	# Percona has decided to rename libmysqlclient to libperconaserverclient
	# Use a symlink to preserve linkages for those who don't use mysql_config
	if [[ ${PN} == "percona-server" ]] && mysql_version_is_at_least "5.5.36" ; then
		dosym libperconaserverclient.so /usr/$(get_libdir)/libmysqlclient.so
		dosym libperconaserverclient.so /usr/$(get_libdir)/libmysqlclient_r.so
		if use static-libs ; then
			dosym libperconaserverclient.a /usr/$(get_libdir)/libmysqlclient.a
			dosym libperconaserverclient.a /usr/$(get_libdir)/libmysqlclient_r.a
		fi
	fi
}
