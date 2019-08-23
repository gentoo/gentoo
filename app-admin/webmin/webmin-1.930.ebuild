# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# ssl-cert eclass does not support EAPI 7 yet.
EAPI=6

inherit pam ssl-cert systemd

# For further Virtualmin & Modules version bumps just change versioning here,
# and make revbump.
# While emerging the config script will upgrade Virtualmin & Modules automatically.
virtualmin_ver="6.07"
virtualmin_nginx_ver="2.5"
virtualmin_nginx_ssl_ver="1.6"
virtualmin_awstats_ver="5.6"
virtualmin_git_ver="1.8"
virtualmin_mailman_ver="6.7"
virtualmin_dav_ver="3.8"
virtualmin_password_recovery_ver="1.7"

DESCRIPTION="A web-based Unix systems administration interface"
HOMEPAGE="http://www.webmin.com/
	  https://www.virtualmin.com/
	  https://github.com/virtualmin
	  https://github.com/webmin/webmin"
SRC_URI="mirror://sourceforge/webadmin/${P}.tar.gz
	 lemp? ( https://github.com/virtualmin/virtualmin-nginx/archive/v${virtualmin_nginx_ver}.tar.gz ->
		 ${P}-virtualmin-nginx-v${virtualmin_nginx_ver}.tar.gz
		 http://software.virtualmin.com/gpl/wbm/virtualmin-nginx-ssl-${virtualmin_nginx_ssl_ver}.wbm.gz ->
		 ${P}-virtualmin-nginx-ssl-${virtualmin_nginx_ssl_ver}.wbm.gz )
	 virtualmin? ( http://download.webmin.com/download/virtualmin/virtual-server-${virtualmin_ver}.gpl.wbm.gz ->
		       ${P}-virtual-server-${virtualmin_ver}.gpl.wbm.gz
		       http://software.virtualmin.com/gpl/wbm/virtualmin-awstats-${virtualmin_awstats_ver}.wbm.gz ->
		       ${P}-virtualmin-awstats-${virtualmin_awstats_ver}.wbm.gz
		       http://software.virtualmin.com/gpl/wbm/virtualmin-git-${virtualmin_git_ver}.wbm.gz ->
		       ${P}-virtualmin-git-${virtualmin_git_ver}.wbm.gz
		       http://software.virtualmin.com/gpl/wbm/virtualmin-mailman-${virtualmin_mailman_ver}.wbm.gz ->
		       ${P}-virtualmin-mailman-${virtualmin_mailman_ver}.wbm.gz
		       http://software.virtualmin.com/gpl/wbm/virtualmin-password-recovery-${virtualmin_password_recovery_ver}.wbm.gz ->
		       ${P}-virtualmin-password-recovery-${virtualmin_password_recovery_ver}.wbm.gz
		       http://software.virtualmin.com/gpl/wbm/virtualmin-dav-${virtualmin_dav_ver}.wbm.gz ->
		       ${P}-virtualmin-dav-${virtualmin_dav_ver}.wbm.gz )"
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# NOTE: The ssl flag auto added by ssl-cert eclass is not used actually
# because openssl is forced by dev-perl/Net-SSLeay
IUSE="lamp lemp ldap +mysql postgres +ssl virtualmin"
REQUIRED_USE="|| ( mysql postgres )
	      virtualmin? ( ^^ ( lamp lemp ) )"

# All the required perl modules can be found easily using (in Webmin's root src dir):
# find . -name cpan_modules.pl -exec grep "::" {} \;
# NOTE: If Webmin doesn't find the required perl modules, it offers(runtime) the user
# to install them using the in-built cpan module, and this will mess up perl on the system
# That's why some modules are forced without a use flag
# NOTE: pam, ssl and dnssec-tools deps are forced for security and Gentoo compliance installation reasons
DEPEND="dev-perl/Authen-Libwrap
	dev-perl/Authen-PAM
	dev-perl/Encode-Detect
	dev-perl/IO-Tty
	dev-perl/MD5
	dev-perl/Net-SSLeay
	dev-perl/Sys-Hostname-Long
	>=net-dns/dnssec-tools-1.13
	virtual/perl-MIME-Base64
	virtual/perl-Socket
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
	virtual/perl-Time-Local
	dev-perl/XML-Generator
	dev-perl/XML-Parser
	ldap? ( dev-perl/perl-ldap )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	virtualmin? ( app-admin/logrotate
		      app-admin/webalizer[-nls]
		      app-antivirus/clamav
		      dev-perl/Config-IniFiles
		      dev-perl/Image-Info
		      mail-filter/amavisd-new
		      mail-filter/opendkim
	              mail-filter/postgrey
		      mail-filter/procmail
		      mail-filter/procmail-lib
		      mail-filter/spamassassin
		      mail-mta/postfix
		      net-analyzer/fail2ban
		      net-dns/bind
		      net-dns/bind-tools
		      net-ftp/proftpd
		      net-mail/dovecot
		      sys-fs/quota
		      www-misc/awstats
		      lamp? ( app-crypt/certbot-apache
			      dev-lang/php:*[apache2,cgi,cli,fpm,mysql?,mysqli,postgres?]
			      dev-php/pear
			      www-servers/apache:2[suexec,apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_dav_lock]
			      www-apache/mod_fcgid
			      mysql? ( || ( dev-db/mariadb:* dev-db/mysql:* ) ) )
		      lemp? ( app-crypt/certbot-nginx
			      dev-lang/php:*[cgi,cli,fpm,mysql?,mysqli,postgres?]
			      dev-php/pear
			      www-servers/nginx:*
			      mysql? ( || ( dev-db/mariadb:* dev-db/mysql:* ) ) )
)"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	local perl="$( which perl )"

	# Remove modules that we do not support and stuff that is not needed
	rm -rf acl/Authen-SolarisRBAC-0.1* || die
	rm -rf {format,{bsd,hpux,sgi}exports,zones,rbac} || die
	rm -f mount/{free,net,open}bsd-mounts* || die
	rm -f mount/macos-mounts* || die

	# For security reasons remove the SSL certificate that comes with Webmin
	# We will create our own later
	rm -f miniserv.pem || die

	# Remove the Webmin setup scripts to avoid Webmin in runtime to mess up config
	# We will use our own later
	rm -f setup.{sh,pl} || die

	# Don't allow webmin to update itself, must update via emerge
	rm {webmin,usermin}/{update.cgi,update.pl,update_sched.cgi,upgrade.cgi,edit_upgrade.cgi,install_theme.cgi} || die

	# Disable Webmin manual module installation
	rm webmin/edit_mods.cgi || die

	# Set the installation type/mode to Gentoo
	echo "gentoo" > install-type || die

	# Module version of virtualmin-nginx-2.3 has issues
	# So we use git source for latest virtualmin-nginx-2.5 module
	if use lemp; then
		mv "${WORKDIR}/virtualmin-nginx-${virtualmin_nginx_ver}" "${S}/virtualmin-nginx" || die
	fi

	# Fix the permissions of the install files
	chmod -R og-w "${S}" || die
	chmod -R a+rx "${S}" || die

	# Since we should not modify any files after install
	# we set the perl path in all cgi and pl files here using Webmin's routines
	# The pl file is Prefix safe and works only on provided input, no other filesystem files
	ebegin "Fixing perl path in source files"
	(find "${S}" -name '*.cgi' -print ; find "${S}" -name '*.pl' -print) | $perl "${S}"/perlpath.pl $perl -
	eend $?
}

src_install() {
	# Create config dir and keep
	diropts -m0755
	dodir /etc/webmin
	keepdir /etc/webmin

	# Create install dir
	# Third party modules installed through Webmin go here too, so keep
	dodir /usr/libexec/webmin
	keepdir /usr/libexec/webmin

	# Copy our own setup script to installation folder
	insinto /usr/libexec/webmin
	newins "${FILESDIR}"/gentoo-setup.r1 gentoo-setup.r1.sh
	newins "${FILESDIR}"/webmin.nginx.reverse.proxy nginx.reverse.proxy
	fperms 0744 /usr/libexec/webmin/gentoo-setup.r1.sh

	# Copy procmail files for Virtualmin setup
	if use virtualmin; then
		newins "${FILESDIR}"/procmailrc procmailrc
		newins "${FILESDIR}"/procmail-wrapper.c procmail-wrapper.c
	fi

	# This is here if we ever want in future ebuilds to add some specific
	# config values in the /etc/webmin/miniserv.conf
	# The format of this file should be the same as the one of miniserv.conf:
	# var=value
	#
	# Uncomment it if you use such file. Before that check if upstream
	# has this file in root dir too.

	## Added with Webmin version 1.930. Use force PAM.
	newins "${FILESDIR}/miniserv-conf" miniserv-conf

	## Added with Webmin version 1.930. More logging.
	newins "${FILESDIR}/config-general" config-general

	# Create the log dir and keep
	diropts -m0700
	dodir /var/log/webmin
	keepdir /var/log/webmin

	# Create the init.d file and put the neccessary variables there
	newinitd "${FILESDIR}"/init.d.webmin webmin
	sed -i \
		-e "s:%exe%:${EROOT%/}/usr/libexec/webmin/miniserv.pl:" \
		-e "s:%pid%:${EROOT%/}/run/webmin.pid:" \
		-e "s:%conf%:${EROOT%/}/etc/webmin/miniserv.conf:" \
		-e "s:%config%:${EROOT%/}/etc/webmin/config:" \
		-e "s:%perllib%:${EROOT%/}/usr/libexec/webmin:" \
		"${ED%/}/etc/init.d/webmin" \
		|| die "Failed to patch the webmin init file"

	# Create the systemd service file and put the neccessary variables there
	systemd_newunit "${FILESDIR}"/webmin.service webmin.service
	systemd_newtmpfilesd "${FILESDIR}/webmin.tmpfiles" webmin.conf
	sed -i \
		-e "s:%exe%:${EROOT%/}/usr/libexec/webmin/miniserv.pl:" \
		-e "s:%pid%:${EROOT%/}/run/webmin.pid:" \
		-e "s:%conf%:${EROOT%/}/etc/webmin/miniserv.conf:" \
		-e "s:%config%:${EROOT%/}/etc/webmin/config:" \
		-e "s:%perllib%:${EROOT}usr/libexec/webmin:" \
		"${ED%/}/$(_systemd_get_systemunitdir)/webmin.service" \
		|| die "Failed to patch the webmin systemd service file"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/webmin.logrotate" webmin

	# Setup pam
	pamd_mimic system-auth webmin auth account session

	# Copy files to installation folder
	ebegin "Copying Webmin install files to destination"
	cp -pPR "${S}"/* "${ED%/}/usr/libexec/webmin"
	eend $?

	# Copy Virtualmin and modules to installation folder
	if use virtualmin; then
		ebegin "Copying Virtualmin install files to destination"
		cp -r "${DISTDIR}"/*.wbm.gz "${ED%/}/usr/libexec/webmin"
		eend $?
	fi
}

pkg_preinst() {
	# First stop service if running so Webmin to not messup our config
	ebegin "Stopping any running Webmin instance prior merging"
	if systemd_is_booted ; then
		systemctl stop webmin.service 2>/dev/null
	else
		rc-service --ifexists -- webmin --ifstarted stop
	fi
	eend $?
}

pkg_postinst() {
	# Run webmin_config first - non interactively
	export INTERACTIVE="no"
	webmin_config
	# Every next time webmin_config should be interactive
	INTERACTIVE="yes"

	ewarn
	ewarn "Bare in mind that not all Webmin & Virtualmin modules are Gentoo tweaked and may have some issues."
	ewarn "Always be careful when using modules that modify init entries, install CPAN modules etc."
	ewarn "To avoid problems, please before using any module, look at its configuration options first."
	ewarn "(Usually there is a link at top in the right pane of Webmin for configuring the module.)"
	ewarn
	if use virtualmin; then
		ewarn "For Virtualmin a fresh Gentoo installation is strongly recommended."
		ewarn "If you are on production system be very careful while working with Virtualmin."
		ewarn "If you save module changes on the fly it may mess up your current stable configurations."
		ewarn "Keep in mind that for fully functional Virtualmin you need to tweak modules first."
		ewarn "The bundled LAMP & LEMP setup are minimal so you may have to recompile according to your needs."
		ewarn "To keep Virtualmin isolated automatic software installation scripts such as PHPMYADMIN disabled "
		ewarn
	fi
	if systemd_is_booted ; then
		elog "- To make Webmin start at boot time, run: 'systemctl enable webmin.service'"
	else
		elog "- To make Webmin start at boot time, run: 'rc-update add webmin default'"
	fi
	elog "- The default URL to connect to Webmin is: https://localhost:10000"
	elog "- The default user that can login is: root"
	elog "- To reconfigure Webmin in case of problems run 'emerge --config app-admin/webmin'"
}

pkg_prerm() {
	# First stop service if running - we do not want Webmin to mess up config
	ebegin "Stopping any running Webmin instance prior unmerging"
	if systemd_is_booted ; then
		systemctl stop webmin.service 2>/dev/null
	else
		rc-service --ifexists -- webmin --ifstarted stop
	fi
	eend $?
}

pkg_postrm() {
	# If removing webmin completely, remind the user for the Webmin's own cron jobs.
	if [[ ! ${REPLACED_BY_VERSION} ]]; then
		# Remove obsolute Webmin/Virtualmin files
		ebegin "Deleting Webmin config folder"
		[[ -d "${ROOT}etc/webmin" ]] && rm -rf "${ROOT}etc/webmin"
		eend $?
		if use virtualmin; then
			ebegin "Deleting Virtualmin"
			[[ -d "${ROOT}usr/libexec/webmin" ]] && rm -rf "${ROOT}usr/libexec/webmin"
			eend $?
		fi
		ebegin "Deleting Webmin logs"
		[[ -d "${ROOT}var/log/webmin" ]] && rm -rf "${ROOT}var/log/webmin"
		eend $?
		ebegin "Deleting Webmin certificates"
		[[ -d "${ROOT}etc/ssl/webmin" ]] && rm -rf "${ROOT}etc/ssl/webmin"
		eend $?
		ewarn
		ewarn "You have uninstalled Webmin, so have in mind that all cron jobs scheduled"
		ewarn "by Webmin for its own modules, are left active and they will fail when Webmin is missing."
		ewarn "To fix this just disable them if you intend to use Webmin again,"
		ewarn "OR delete them if not."
		ewarn
	fi
}

pkg_config() {
	webmin_config
}

webmin_config() {
	# First stop service if running
	ebegin "Stopping any running Webmin instance"
	if systemd_is_booted ; then
		systemctl stop webmin.service 2>/dev/null
	else
		rc-service --ifexists -- webmin --ifstarted stop
	fi
	eend $?

	# Next set the default reset variable to 'none'
	# reset/_reset can be:
	# 'none' - does not reset anything, just upgrades if a conf is present
	#		   OR installs new conf if a conf is missing
	# 'soft' - deletes only $config_dir/config file and thus resetting most
	#		  conf values to their defaults. Keeps the specific Webmin cron jobs
	# 'hard' - deletes all files in $config_dir (keeping the .keep_* Gentoo file)
	#		  and thus resetting all Webmin. Deletes the specific Webmin cron jobs too.
	local _reset="none"

	# If in interactive mode ask user what should we do
	if [[ "${INTERACTIVE}" = "yes" ]]; then
		einfo
		einfo "Please enter the number of the action you would like to perform?"
		einfo
		einfo "1. Update configuration"
		einfo "   (keeps old config options and adds the new ones)"
		einfo "2. Soft reset configuration"
		einfo "   (keeps some old config options, the other options are set to default)"
		ewarn "   All Webmin users will be reset"
		einfo "3. Hard reset configuration"
		einfo "   (all options including module options are set to default)"
		ewarn "   You will lose all Webmin configuration options you have done till now"
		einfo "4. Exit this configuration utility (default)"
		while [ "$correct" != "true" ] ; do
			read answer
			if [[ "$answer" = "1" ]] ; then
				_reset="none"
				correct="true"
			elif [[ "$answer" = "2" ]] ; then
				_reset="soft"
				correct="true"
			elif  [[ "$answer" = "3" ]] ; then
				_reset="hard"
				correct="true"
			elif  [ "$answer" = "4" -o "$answer" = "" ] ; then
				die "User aborted configuration."
			else
				echo "Answer not recognized. Enter a number from 1 to 4"
			fi
		done

		if [[ "$_reset" = "hard" ]]; then
			while [ "$sure" != "true" ] ; do
				ewarn "You will lose all Webmin configuration options you have done till now."
				ewarn "Are you sure you want to do this? (y/n)"
				read answer
				if [[ $answer =~ ^[Yy]([Ee][Ss])?$ ]] ; then
					sure="true"
				elif [[ $answer =~ ^[Nn]([Oo])?$ ]] ; then
					die "User aborted configuration."
				else
					echo "Answer not recognized. Enter 'y' or 'n'"
				fi
			done
		fi
	fi

	export reset=$_reset

	# Create ssl certificate for Webmin if there is not one in the proper place
	if [[ ! -e "${EROOT%/}/etc/ssl/webmin/server.pem" ]]; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Webmin Server}"
		SSL_COMMONNAME="${SSL_COMMONNAME:-*}"
		install_cert "${EROOT%/}/etc/ssl/webmin/server"
	fi

	# Ensure all paths passed to the setup script use EROOT
	export wadir="${EROOT%/}/usr/libexec/webmin"
	export config_dir="${EROOT%/}/etc/webmin"
	export var_dir="${EROOT%/}/var/log/webmin"
	export tempdir="${T}"
	export pidfile="${EROOT%/}/run/webmin.pid"
	export perl="$( which perl )"
	export os_type='gentoo-linux'
	export os_version='*'
	export real_os_type='Gentoo Linux'
	export real_os_version='Any version'
	# Forcing 'ssl', 'no_ssl2', 'no_ssl3', 'ssl_redirect', 'no_sslcompression',
	# 'ssl_honorcipherorder', 'no_tls1' and 'no_tls1_1' for tightening security
	export ssl=1
	export no_ssl2=1
	export no_ssl3=1
	export ssl_redirect=1
	export ssl_honorcipherorder=1
	export no_sslcompression=1
	export no_tls1=1
	export no_tls1_1=1
	export keyfile="${EROOT%/}/etc/ssl/webmin/server.pem"
	export port=10000
	export atboot=0

	# Export virtualmin depended environment variables
	if use virtualmin; then
		export virtualmin=0
		export webmin="${P}"
		export virtualmin_ver="${virtualmin_ver}"
		export virtualmin_awstats_ver="${virtualmin_awstats_ver}"
		export virtualmin_git_ver="${virtualmin_git_ver}"
		export virtualmin_mailman_ver="${virtualmin_mailman_ver}"
		export virtualmin_dav_ver="${virtualmin_dav_ver}"
		export virtualmin_password_recovery_ver="${virtualmin_password_recovery_ver}"
		# LEMP specific variables
		if use lemp; then
			export nginx=0
			export virtualmin_nginx_ssl_ver="${virtualmin_nginx_ssl_ver}"
			export virtualmin_nginx_ver="${virtualmin_nginx_ver}"
		fi
		# LAMP specific variables
		if use lamp; then
			export apache=0
		fi
	fi

	einfo "Executing Webmin's configure script"
	"${wadir}"/gentoo-setup.r1.sh

	einfo "Configuration of Webmin done"
}
