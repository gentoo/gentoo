# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="A statistical-algorithmic hybrid anti-spam filter"
HOMEPAGE="http://dspam.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
DRIVERS_IUSE="+hash mysql postgres sqlite"
SCALES_IUSE="small-scale +domain-scale large-scale"
IUSE="clamav daemon debug ldap static-libs syslog virtual-users user-homedirs ${DRIVERS_IUSE} ${SCALES_IUSE}"

DEPEND="
	net-mail/mailbase
	ldap? ( net-nds/openldap )
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="
	${DEPEND}
	clamav? ( app-antivirus/clamav )
	syslog?	( virtual/logger )
"

# Demands on sane USE flags:
# - find out what driver to use: select at least one
# - if static-libs is set, only one driver may be selected
# - find out what scale to use: select exactly one
# - user-homedirs does not work with virtual-users
REQUIRED_USE="
	|| ( ${DRIVERS_IUSE//+} )
	static-libs? ( ^^ ( ${DRIVERS_IUSE//+} ) )
	^^ ( ${SCALES_IUSE//+} )
	virtual-users? ( !user-homedirs )
"

# dspam setup defaults
DSPAM_HOME=/var/spool/dspam
DSPAM_CONF=/etc/dspam
DSPAM_LOG=/var/log/dspam
DSPAM_MODE=2510
DSPAM_DRIVERS=
DSPAM_DRIVERS_EXTRAS=

pkg_setup() {
	# setup storage, this sets DSPAM_DRIVERS
	dspam_setup_storage_drivers

	# create dspam user and group
	dspam_setup_user
}

src_configure() {
	econf \
		--sysconfdir=${DSPAM_CONF} \
		--with-dspam-home=${DSPAM_HOME} \
		--with-dspam-home-group=dspam \
		--with-dspam-mode=${DSPAM_MODE} \
		--with-dspam-group=dspam \
		--with-logdir=${DSPAM_LOG} \
		--enable-external-lookup \
		--enable-long-usernames \
		--enable-split-configuration \
		$(use_enable clamav) \
		$(use_enable daemon) \
		$(use_enable debug) \
		$(use_enable debug bnr-debug) \
		$(use_enable debug verbose-debug) \
		$(use_enable domain-scale) \
		$(use_enable large-scale) \
		$(use_enable static-libs static) \
		$(use_enable syslog) \
		$(use_enable user-homedirs homedir) \
		$(use_enable virtual-users) \
		--with-storage-driver=${DSPAM_DRIVERS} ${DSPAM_DRIVERS_EXTRAS} \
		$(use mysql || use postgres && echo "--enable-preferences-extension") \
		$(use syslog || echo "--with-logfile=${DSPAM_LOG}/dspam.log")
}

dspam_setup_user() {
	# DSPAM CGI web gui (www-apps/dspam-web) needs to run as a regular user
	# under suexec in apache, so DSPAM user/group need to be regular users too

	local euid egid
	for euid in {1000..5000} ; do
		[ -z "$(egetent passwd ${euid})" ] && break
	done
	for egid in {1000..5000} ; do
		[ -z "$(egetent group ${egid})" ] && break
	done
	enewgroup dspam ${egid}
	enewuser dspam ${euid} -1 "${DSPAM_HOMEDIR}" dspam,mail
}

dspam_setup_storage_drivers() {
	# Find out which storage drivers need to be enabled, and set some
	# variables so that src_configure can pick them up

	if use hash; then
		DSPAM_DRIVERS+=",hash_drv"
	fi

	if use mysql; then
		DSPAM_DRIVERS+=",mysql_drv"
		DSPAM_DRIVERS_EXTRAS+="--with-mysql-includes=/usr/include/mysql "
	fi

	if use postgres; then
		DSPAM_DRIVERS+=",pgsql_drv"
	fi

	if use sqlite; then
		DSPAM_DRIVERS+=",sqlite3_drv"
	fi

	if ! use static-libs; then
		# set the driver name twice to avoid a static build
		DSPAM_DRIVERS+=${DSPAM_DRIVERS}
	fi

	# remove first comma separator
	DSPAM_DRIVERS=${DSPAM_DRIVERS:1}
	einfo "Building with drivers: ${DSPAM_DRIVERS}"
	#echo DSPAM_DRIVERS_EXTRAS=$DSPAM_DRIVERS_EXTRAS
}

src_install() {
	default

	if use daemon; then
		newinitd "${FILESDIR}/dspam.initd" dspam
		newconfd "${FILESDIR}/dspam.confd" dspam
	fi

	if use mysql; then
		insinto "/usr/share/${PN}/mysql"

		local files="mysql_objects-4.1.sql mysql_objects-space.sql mysql_objects-speed.sql purge-4.1.sql purge.sql"
		if use virtual-users; then
			files+=" virtual_user_aliases.sql virtual_users.sql"
		fi

		for file in $files; do
			doins src/tools.mysql_drv/${file}
		done
	fi

	if use postgres; then
		insinto "/usr/share/${PN}/pgsql"

		local files="pgsql_objects.sql purge-pe.sql purge.sql"
		if use virtual-users; then
			files+=" virtual_users.sql"
		fi

		for file in $files; do
			doins src/tools.pgsql_drv/${file}
		done
	fi

	if use sqlite; then
		insinto "/usr/share/${PN}/sqlite"
		newins src/tools.sqlite_drv/purge-3.sql purge.sql
	fi

	insinto "${DSPAM_HOME}/txt"
	doins txt/*.txt
	local i
	for i in spam nonspam; do
		echo "Scanned and tagged with DSPAM ${PV} on Gentoo Linux as ${i} by ISP" > "${T}/msgtag.${i}"
		doins "${T}/msgtag.${i}"
	done

	newbin contrib/dspam_maintenance/dspam_maintenance.sh dspam_maintenance
	exeinto /etc/cron.daily
	newexe "${FILESDIR}/dspam.cron-r4" dspam

	insinto /etc/logrotate.d
	newins "${FILESDIR}/dspam.logrotate" dspam

	dodoc CHANGELOG README* RELEASE.NOTES UPGRADING doc/*.txt

	# stop logrotate-3.8 from complaining
	dodir /var/log/dspam
	fowners dspam:dspam /var/log/dspam
	fperms 0750 /var/log/dspam

	# Install dspamc setgid
	fowners root:dspam /usr/bin/dspamc
	fperms g+s /usr/bin/dspamc
}

pkg_preinst() {
	# dspam-3.10.0: config dir change, should be removed at some later point
	if [ -d "${ROOT}/etc/mail/dspam" ]; then
		ewarn "The configuration directory of DSPAM has been relocated from /etc/mail/dspam to ${DSPAM_CONF}."
		if [ -h "${ROOT}${DSPAM_CONF}" ]; then
			# symlink, this is the setup in older ebuilds
			ewarn "Moving contents of /etc/mail/dspam to ${DSPAM_CONF} ..."
			rm "${ROOT}${DSPAM_CONF}" && mv "${ROOT}/etc/mail/dspam" "${DSPAM_CONF}"
			eend $?

		elif [ -d "${ROOT}${DSPAM_CONF}" ]; then
			# directory and no symlink, do it manually since we cannot decide.
			ewarn "You have both /etc/mail/dspam and ${DSPAM_CONF} directories, please delete the former."

		else
			# nothing interesting in /etc/dspam
			ewarn "Moving contents of /etc/mail/dspam to ${DSPAM_CONF} ..."
			mv "${ROOT}/etc/mail/dspam" "${DSPAM_CONF}"
			eend $?
		fi
	fi
}
