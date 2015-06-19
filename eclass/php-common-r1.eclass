# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php-common-r1.eclass,v 1.20 2015/06/17 19:23:34 grknight Exp $

# Based on robbat2's work on the php4 sapi eclass
# Based on stuart's work on the php5 sapi eclass

# @ECLASS: php-common-r1.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @BLURB: Common functions which are shared between the PHP4 and PHP5 packages.
# @DESCRIPTION:
# This eclass provides common functions which are shared between the PHP4 and PHP5 packages.
# It is only used by php*-sapi eclasses currently and the functions are not intended
# for direct use in ebuilds.
# This eclass is no longer in use and scheduled to be removed on 2015-07-17
# @DEAD

# ========================================================================
# CFLAG SANITY
# ========================================================================

php_check_cflags() {
	# Fixes bug #14067.
	# Changed order to run it in reverse for bug #32022 and #12021.
	replace-cpu-flags "k6*" "i586"
}

# ========================================================================
# IMAP SUPPORT
# ========================================================================

php_check_imap() {
	if ! use "imap" && ! phpconfutils_usecheck "imap" ; then
		return
	fi

	if use "ssl" || phpconfutils_usecheck "ssl" ; then
		if ! built_with_use virtual/imap-c-client ssl ; then
			eerror
			eerror "IMAP with SSL requested, but your IMAP C-Client libraries are built without SSL!"
			eerror
			die "Please recompile the IMAP C-Client libraries with SSL support enabled"
		fi
	else
		if built_with_use virtual/imap-c-client ssl ; then
			eerror
			eerror "IMAP without SSL requested, but your IMAP C-Client libraries are built with SSL!"
			eerror
			die "Please recompile the IMAP C-Client libraries with SSL support disabled"
		fi
	fi

	if use "kolab" || phpconfutils_usecheck "kolab" ; then
		if ! built_with_use net-libs/c-client kolab ; then
			eerror
			eerror "IMAP with annotations support requested, but net-libs/c-client is built without it!"
			eerror
			die "Please recompile net-libs/c-client with USE=kolab."
		fi
	fi
}

# ========================================================================
# JAVA EXTENSION SUPPORT
#
# The bundled java extension is unique to PHP4, but there is
# now the PHP-Java-Bridge that works under both PHP4 and PHP5.
# ========================================================================

php_check_java() {
	if ! use "java-internal" && ! phpconfutils_usecheck "java-internal" ; then
		return
	fi

	JDKHOME="$(java-config --jdk-home)"
	NOJDKERROR="You need to use the 'java-config' utility to set your JVM to a JDK!"
	if [[ -z "${JDKHOME}" ]] || [[ ! -d "${JDKHOME}" ]] ; then
		eerror "${NOJDKERROR}"
		die "${NOJDKERROR}"
	fi

	# stuart@gentoo.org - 2003/05/18
	# Kaffe JVM is not a drop-in replacement for the Sun JDK at this time
	if echo ${JDKHOME} | grep kaffe > /dev/null 2>&1 ; then
		eerror
		eerror "PHP will not build using the Kaffe Java Virtual Machine."
		eerror "Please change your JVM to either Blackdown or Sun's."
		eerror
		eerror "To build PHP without Java support, please re-run this emerge"
		eerror "and place the line:"
		eerror "  USE='-java-internal'"
		eerror "in front of your emerge command, for example:"
		eerror "  USE='-java-internal' emerge =dev-lang/php-4*"
		eerror
		eerror "or edit your USE flags in /etc/portage/make.conf."
		die "Kaffe JVM not supported"
	fi

	JDKVER=$(java-config --java-version 2>&1 | awk '/^java version/ { print $3 }' | xargs )
	einfo "Active JDK version: ${JDKVER}"
	case "${JDKVER}" in
		1.4.*) ;;
		1.5.*) ewarn "Java 1.5 is NOT supported at this time, and might not work." ;;
		*) eerror "A Java 1.4 JDK is recommended for Java support in PHP." ; die ;;
	esac
}

php_install_java() {
	if ! use "java-internal" && ! phpconfutils_usecheck "java-internal" ; then
		return
	fi

	# We put these into /usr/lib so that they cannot conflict with
	# other versions of PHP (e.g. PHP 4 & PHP 5)
	insinto "${PHPEXTDIR}"

	einfo "Installing PHP java extension"
	doins "modules/java.so"

	einfo "Creating PHP java extension symlink"
	dosym "${PHPEXTDIR}/java.so" "${PHPEXTDIR}/libphp_java.so"

	einfo "Installing JAR for PHP"
	doins "ext/java/php_java.jar"

	einfo "Installing Java test page"
	newins "ext/java/except.php" "java-test.php"
}

php_install_java_inifile() {
	if ! use "java-internal" && ! phpconfutils_usecheck "java-internal" ; then
		return
	fi

	JAVA_LIBRARY="$(grep -- '-DJAVALIB' Makefile | sed -e 's,.\+-DJAVALIB=\"\([^"]*\)\".*$,\1,g;' | sort -u)"

	echo "extension = java.so" >> "${D}/${PHP_EXT_INI_DIR}/java.ini"
	echo "java.library = ${JAVA_LIBRARY}" >> "${D}/${PHP_EXT_INI_DIR}/java.ini"
	echo "java.class.path = ${PHPEXTDIR}/php_java.jar" >> "${D}/${PHP_EXT_INI_DIR}/java.ini"
	echo "java.library.path = ${PHPEXTDIR}" >> "${D}/${PHP_EXT_INI_DIR}/java.ini"

	dosym "${PHP_EXT_INI_DIR}/java.ini" "${PHP_EXT_INI_DIR_ACTIVE}/java.ini"
}

# ========================================================================
# MTA SUPPORT
# ========================================================================

php_check_mta() {
	if ! [[ -x "${ROOT}/usr/sbin/sendmail" ]] ; then
		ewarn
		ewarn "You need a virtual/mta that provides a sendmail compatible binary!"
		ewarn "All major MTAs provide this, and it's usually some symlink created"
		ewarn "as '${ROOT}/usr/sbin/sendmail*'. You should also be able to use other"
		ewarn "MTAs directly, but you'll have to edit the sendmail_path directive"
		ewarn "in your php.ini for this to work."
		ewarn
	fi
}

# ========================================================================
# ORACLE SUPPORT
# ========================================================================

php_check_oracle_all() {
	if use "oci8" && [[ -z "${ORACLE_HOME}" ]] ; then
		eerror
		eerror "You must have the ORACLE_HOME variable set in your environment to"
		eerror "compile the Oracle extension."
		eerror
		die "Oracle configuration incorrect; user error"
	fi

	if use "oci8" || use "oracle7" ; then
		if has_version 'dev-db/oracle-instantclient-basic' ; then
			ewarn
			ewarn "Please ensure you have a full install of the Oracle client."
			ewarn "'dev-db/oracle-instantclient-basic' is NOT sufficient."
			ewarn "Please enable the 'oci8-instant-client' USE flag instead, if you"
			ewarn "want to use 'dev-db/oracle-instantclient-basic' as Oracle client."
			ewarn
		fi
	fi
}

php_check_oracle_8() {
	if use "oci8" && [[ -z "${ORACLE_HOME}" ]] ; then
		eerror
		eerror "You must have the ORACLE_HOME variable set in your environment to"
		eerror "compile the Oracle extension."
		eerror
		die "Oracle configuration incorrect; user error"
	fi

	if use "oci8" ; then
		if has_version 'dev-db/oracle-instantclient-basic' ; then
			ewarn
			ewarn "Please ensure you have a full install of the Oracle client."
			ewarn "'dev-db/oracle-instantclient-basic' is NOT sufficient."
			ewarn "Please enable the 'oci8-instant-client' USE flag instead, if you"
			ewarn "want to use 'dev-db/oracle-instantclient-basic' as Oracle client."
			ewarn
		fi
	fi
}

# ========================================================================
# POSTGRESQL SUPPORT
# ========================================================================

php_check_pgsql() {
	if use "postgres" && use "apache2" && use "threads" ; then
		if has_version dev-db/libpq ; then
			if has_version ">=dev-db/libpq-8" && \
				! built_with_use ">=dev-db/libpq-8" "threads" ; then
				eerror
				eerror "You must build dev-db/libpq with USE=threads"
				eerror "if you want to build PHP with threads support!"
				eerror
				die "Rebuild dev-db/libpq with USE=threads"
			fi
		else
			local pgsql_ver=$(eselect postgresql show)
			if [[ ${pgsql_ver} == "(none)" ]]; then
				eerror "QA: Please select your PostgreSQL version \"eselect postgresql list\""
				die "Can't determine PgSQL."
			fi
			if ! built_with_use "=dev-db/postgresql-base-${pgsql_ver}*" threads ; then
				eerror
				eerror "You must build =dev-db/postgresql-base-${pgsql_ver} with USE=threads"
				eerror "if you want to build PHP with threads support!"
				eerror
				die "Rebuild =dev-db/postgresql-base-${pgsql_ver} with USE=threads"
			fi
		fi
	fi
}

# ========================================================================
# MYSQL CHARSET DETECTION SUPPORT ## Thanks to hoffie
# ========================================================================

php_get_mycnf_charset() {
	# nothing todo if no mysql installed
	if [[ ! -f "${ROOT}/etc/mysql/my.cnf" ]]; then
		echo "empty"
		return
	fi
	local sapi="${1}"
	local section=""
	local client_charset=""
	local sapi_charset=""

	# remove comments and pipe the output to our while loop
	while read line ; do
		line=$(echo "${line}" | sed 's:[;#][^\n]*::g')

		# skip empty lines
		if [[ "${line}" == "" ]] ; then
			continue
		fi

		# capture sections
		tmp=$(echo "${line}" | sed 's:\[\([-a-z0-9\_]*\)\]:\1:')
		if [[ "${line}" != "${tmp}" ]] ; then
			section=${tmp}
		else
			# we don't need to check lines which are not in a section we are interested about
			if [[ "${section}" != "client" && "${section}" != "php-${sapi}" ]] ; then
				continue
			fi

			# match default-character-set= lines
			tmp=$(echo "${line}" | sed 's|^[[:space:]\ ]*default-character-set[[:space:]\ ]*=[[:space:]\ ]*\"\?\([a-z0-9\-]*\)\"\?|\1|')
			if [[ "${line}" == "${tmp}" ]] ; then
				# nothing changed, irrelevant line
				continue
			fi
			if [[ "${section}" == "client" ]] ; then
				client_charset="${tmp}"
			else
				if [[ "${section}" == "php-${sapi}" ]] ; then
					sapi_charset="${tmp}"
				fi
			fi
		fi
	done < "${ROOT}/etc/mysql/my.cnf"
	# if a sapi-specific section with a default-character-set= value was found we use it, otherwise we use the client charset (which may be empty)
	if [[ -n "${sapi_charset}" ]] ; then
		echo "${sapi_charset}"
	elif [[ -n "${client_charset}" ]] ; then
		echo "${client_charset}"
	else
		echo "empty"
	fi
}
