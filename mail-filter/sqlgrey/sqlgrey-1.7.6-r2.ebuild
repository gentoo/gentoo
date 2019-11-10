# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd user

DESCRIPTION="A postfix policy service implementing a grey-listing policy"
HOMEPAGE="http://sqlgrey.sourceforge.net/"
SRC_URI="mirror://sourceforge/sqlgrey/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"
IUSE="mysql +postgres sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="dev-lang/perl
	dev-perl/DBI
	dev-perl/Date-Calc
	dev-perl/Net-Server
	virtual/mailx
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	sqlite? ( dev-perl/DBD-SQLite )"
DEPEND="${RDEPEND}
	sys-apps/sed"

PATCHES=(
	"${FILESDIR}/${P}-init.patch"
)

pkg_setup() {
	enewgroup sqlgrey
	enewuser sqlgrey -1 -1 /var/spool/sqlgrey sqlgrey
}

src_install () {
	emake gentoo-install ROOTDIR="${D}"
	dodoc HOWTO FAQ README README.OPTINOUT README.PERF TODO Changelog

	# keeps SQLgrey data in /var/spool/sqlgrey
	diropts -m0775 -o sqlgrey -g sqlgrey
	keepdir /var/spool/sqlgrey

	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	elog "To make use of greylisting, please update your postfix config."
	elog
	elog "Put something like this in /etc/postfix/main.cf:"
	elog "    smtpd_recipient_restrictions ="
	elog "           ..."
	elog "           check_policy_service inet:127.0.0.1:2501"
	elog
	elog "Remember to restart Postfix after that change. Also remember"
	elog "to make the daemon start durig boot:"
	elog "  rc-update add sqlgrey default"
	elog
	elog
	elog "To setup SQLgrey to run out-of-the-box on your system, run:"
	elog "emerge --config ${PN}"
	elog
	ewarn "Read the documentation for more info (perldoc sqlgrey) or the"
	ewarn "included howto /usr/share/doc/${PF}/HOWTO.gz"
	ewarn
	ewarn "If you are using MySQL >= 4.1 use \"latin1\" as charset for"
	ewarn "the SQLgrey db"
}

pkg_config () {
	# SQLgrey configuration file
	local SQLgrey_CONFIG="/etc/sqlgrey/sqlgrey.conf"
	local SQLgrey_DB_USER_NAME="sqlgrey"
	local SQLgrey_DB_NAME="sqlgrey"

	# Check if a password is set in sqlgrey.conf
	local SQLgrey_CONF_PWD=""
	if [ -f "${SQLgrey_CONFIG}" ]; then
		if (grep -iq "^[\t ]*db_pass[\t ]*=[\t ]*.*$" ${SQLgrey_CONFIG}); then
			# User already has a db_pass entry
			SQLgrey_CONF_PWD="$(sed -n 's:^[\t ]*db_pass[\t ]*=[\t ]*\(.*\)[\t ]*:\1:gIp' ${SQLgrey_CONFIG})"
		else
			SQLgrey_CONF_PWD=""
		fi
	else
		ewarn "SQLgrey configuration missing. Exiting now."
		echo
		exit 0
	fi

	# Check if we need SQLgrey to configure for this system or not
	local SQLgrey_DB_HOST="localhost"
	local SQLgrey_KEY_INPUT="l,r,x"
	einfo "SQLgrey database backend configuration"
	einfo "  Please select where SQLgrey database will run:"
	einfo "    [l] Database backend runs on localhost"
	einfo "    [r] Database backend runs on remote host"
	einfo "    [x] Exit"
	echo
	einfo "  Press one of the keys [${SQLgrey_KEY_INPUT}]: "
	while true; do
		read -n 1 -s SQLgrey_ACCESS_TYPE
		case "${SQLgrey_ACCESS_TYPE}" in
			"r" | "R" )
				SQLgrey_ACCESS_TYPE="r"
				einfo "  remote setup"
				read -p "     Please enter the remote hostname: " SQLgrey_DB_HOST
				echo
				break
			;;
			"l" | "L" )
				SQLgrey_ACCESS_TYPE="l"
				einfo "  local setup"
				echo
				break
			;;
			"x" | "X" )
				exit 0
			;;
		esac
	done

	# Generate random password
	if [[ "${SQLgrey_CONF_PWD}" == "" ]]; then
		einfo "Generating random database user password..."
		local SQLgrey_PWD_MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
		local SQLgrey_DB_USER_PWD=""
		while [ "${n:=1}" -le "16" ]; do
			SQLgrey_DB_USER_PWD="${SQLgrey_DB_USER_PWD}${SQLgrey_PWD_MATRIX:$(($RANDOM%${#SQLgrey_PWD_MATRIX})):1}"
			let n+=1
		done
	else
		einfo "Reusing current database user password..."
		local SQLgrey_DB_USER_PWD="${SQLgrey_CONF_PWD}"
	fi
	echo

	# Configure the various database backends
	local SQLgrey_KEY_INPUT=""
	einfo "Creating SQLgrey database backend data and configuration"
	einfo "  Please select what kind of database you like to use:"
	if use postgres || has_version dev-perl/DBD-Pg ; then
		einfo "    [p] PostgreSQL"
		SQLgrey_KEY_INPUT="${SQLgrey_KEY_INPUT},p"
	fi
	if use mysql || has_version dev-perl/DBD-mysql ; then
		einfo "    [m] MySQL"
		SQLgrey_KEY_INPUT="${SQLgrey_KEY_INPUT},m"
	fi
	if use sqlite || has_version dev-perl/DBD-SQLite ; then
		einfo "    [s] SQLite"
		SQLgrey_KEY_INPUT="${SQLgrey_KEY_INPUT},s"
	fi
	einfo "    [x] Exit"
	SQLgrey_KEY_INPUT="${SQLgrey_KEY_INPUT},x"
	echo
	einfo "  Press one of the keys [${SQLgrey_KEY_INPUT:1}]: "
	while true; do
		read -n 1 -s SQLgrey_DB_TYPE
		case "${SQLgrey_DB_TYPE}" in
			"p" | "P" )
				SQLgrey_DB_TYPE="p"
				einfo "  PostgreSQL database backend"
				echo
				break
			;;
			"m" | "M" )
				SQLgrey_DB_TYPE="m"
				einfo "  MySQL database backend"
				echo
				break
			;;
			"s" | "S" )
				SQLgrey_DB_TYPE="s"
				einfo "  SQLite database backend"
				echo
				break
			;;
			"x" | "X" )
				exit 0
			;;
		esac
	done

	# If we don't use SQLite, the password must not be set
	if [[ ( "${SQLgrey_DB_TYPE}" != "s" ) && ( "${SQLgrey_CONF_PWD}" != "" ) ]]; then
		ewarn "This configuration is only for new installations. You seem to"
		ewarn "have already a modified sqlgrey.conf"
		ewarn "Do you want to continue?"
		SQLgrey_KEY_INPUT="y,n"
		einfo "   Press one of the keys [$SQLgrey_KEY_INPUT]: "
		while true; do
			read -n 1 -s SQLgrey_Ignore
			case "$SQLgrey_Ignore" in
				"y"|"Y" )
					break
				;;
				"n"|"N" )
					exit 0
				;;
			esac
		done
	fi

	## Per-RDBMS configuration ##
	# POSTGRESQL
	if [[ "${SQLgrey_DB_TYPE}" == "p" ]] ; then

		ewarn "If prompted for a password, please enter your PgSQL postgres password"
		ewarn ""

		einfo "Creating SQLgrey PostgreSQL database \"${SQLgrey_DB_NAME}\" and user \"${SQLgrey_DB_USER_NAME}\""
		/usr/bin/psql -h ${SQLgrey_DB_HOST} -d template1 -U postgres -c "CREATE USER ${SQLgrey_DB_USER_NAME} WITH PASSWORD '${SQLgrey_DB_USER_PWD}' NOCREATEDB NOCREATEUSER; CREATE DATABASE ${SQLgrey_DB_NAME}; GRANT ALL PRIVILEGES ON DATABASE ${SQLgrey_DB_NAME} TO ${SQLgrey_DB_USER_NAME}; GRANT ALL PRIVILEGES ON SCHEMA public TO ${SQLgrey_DB_USER_NAME}; UPDATE pg_database SET datdba=(SELECT usesysid FROM pg_shadow WHERE usename='${SQLgrey_DB_USER_NAME}') WHERE datname='${SQLgrey_DB_NAME}';"

		einfo "Changing SQLgrey configuration in sqlgrey.conf"
		sed -i "s:^[# ]*\(db_type[ \t]*= \).*:\1Pg:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_user[ \t]*= \).*:\1${SQLgrey_DB_USER_NAME}:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_pass[ \t]*= \).*:\1${SQLgrey_DB_USER_PWD}:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_host[ \t]*= \).*:\1${SQLgrey_DB_HOST}:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_name[ \t]*= \).*:\1${SQLgrey_DB_NAME}:gI" ${SQLgrey_CONFIG}
	elif [[ "${SQLgrey_DB_TYPE}" == "m" ]] ; then
	# MYSQL
		ewarn "If prompted for a password, please enter your MySQL root password"
		ewarn ""

		einfo "Creating SQLgrey MySQL database \"${SQLgrey_DB_NAME}\" and user \"${SQLgrey_DB_USER_NAME}\""
		echo -ne "     "
		/usr/bin/mysql -u root -h ${SQLgrey_DB_HOST} -p -e "CREATE DATABASE IF NOT EXISTS ${SQLgrey_DB_NAME} CHARACTER SET latin1; GRANT ALL ON ${SQLgrey_DB_NAME}.* TO ${SQLgrey_DB_USER_NAME}@${SQLgrey_DB_HOST} IDENTIFIED BY '${SQLgrey_DB_USER_PWD}';FLUSH PRIVILEGES;" -D mysql
		echo

		einfo "Changing SQLgrey configuration in sqlgrey.conf"
		sed -i "s:^[# ]*\(db_type[ \t]*= \).*:\1mysql:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_user[ \t]*= \).*:\1${SQLgrey_DB_USER_NAME}:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_pass[ \t]*= \).*:\1${SQLgrey_DB_USER_PWD}:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_host[ \t]*= \).*:\1${SQLgrey_DB_HOST}:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_name[ \t]*= \).*:\1${SQLgrey_DB_NAME}:gI" ${SQLgrey_CONFIG}
	elif [[ "${SQLgrey_DB_TYPE}" == "s" ]] ; then
		einfo "Changing SQLgrey configuration in sqlgrey.conf"
		sed -i "s:^[# ]*\(db_type[ \t]*= \).*:\1SQLite:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_name[ \t]*= \).*:\1${SQLgrey_DB_NAME}:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_user[ \t]*=.*\)$:# \1:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_pass[ \t]*= .*\)$:# \1:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_host[ \t]*= .*\)$:# \1:gI" ${SQLgrey_CONFIG}
		sed -i "s:^[# ]*\(db_cleandelay[ \t]*= .*\)$:# \1:gI" ${SQLgrey_CONFIG}
	fi
	echo
	if [[ "${SQLgrey_DB_TYPE}" != "s" ]]; then
		einfo "Note: the database password is stored in $SQLgrey_CONFIG"
	fi
}
