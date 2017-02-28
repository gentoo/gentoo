# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils pam ssl-cert systemd

DESCRIPTION="A web-based Unix systems administration interface"
HOMEPAGE="http://www.webmin.com/"
SRC_URI="minimal? ( mirror://sourceforge/webadmin/${P}-minimal.tar.gz )
	!minimal? ( mirror://sourceforge/webadmin/${P}.tar.gz )"

LICENSE="BSD GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

# NOTE: The ssl flag auto added by ssl-cert eclass is not used actually
# because openssl is forced by dev-perl/Net-SSLeay
IUSE="minimal +ssl mysql postgres ldap"
REQUIRED_USE="minimal? ( !mysql !postgres !ldap )"

# All the required perl modules can be found easily using (in Webmin's root src dir):
# find . -name cpan_modules.pl -exec grep "::" {} \;
# NOTE: If Webmin doesn't find the required perl modules, it offers(runtime) the user
# to install them using the in-built cpan module, and this will mess up perl on the system
# That's why some modules are forced without a use flag
# NOTE: pam, ssl and dnssec-tools deps are forced for security and Gentoo compliance installation reasons
DEPEND="virtual/perl-MIME-Base64
	virtual/perl-Socket
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
	virtual/perl-Time-Local
	dev-perl/Authen-Libwrap
	dev-perl/IO-Tty
	dev-perl/MD5
	dev-perl/Net-SSLeay
	dev-perl/Authen-PAM
	dev-perl/Sys-Hostname-Long
	>=net-dns/dnssec-tools-1.13
	!minimal? (
		mysql? ( dev-perl/DBD-mysql )
		postgres? ( dev-perl/DBD-Pg )
		ldap? ( dev-perl/perl-ldap )
		dev-perl/XML-Generator
		dev-perl/XML-Parser
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	local perl="$( which perl )"

	# Remove the unnecessary and incompatible files
	rm -rf acl/Authen-SolarisRBAC-0.1*
	if ! use minimal ; then
		rm -rf {format,{bsd,hpux,sgi}exports,zones,rbac}
		rm -f mount/{free,net,open}bsd-mounts*
		rm -f mount/macos-mounts*
	fi

	# For security reasons remove the SSL certificate that comes with Webmin
	# We will create our own later
	rm -f miniserv.pem

	# Remove the Webmin setup scripts to avoid Webmin in runtime to mess up config
	# We will use our own later
	rm -f setup.{sh,pl}

	# Set the installation type/mode to Gentoo
	echo "gentoo" > install-type

	# Fix the permissions of the install files
	chmod -R og-w "${S}"

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
	newins "${FILESDIR}"/gentoo-setup-${PV} gentoo-setup.sh
	fperms 0744 /usr/libexec/webmin/gentoo-setup.sh

	# This is here if we ever want in future ebuilds to add some specific
	# config values in the /etc/webmin/miniserv.conf
	# The format of this file should be the same as the one of miniserv.conf:
	# var=value
	#
	# Uncomment it if you use such file. Before that check if upstream
	# has this file in root dir too.
	#newins "${FILESDIR}/miniserv-conf" miniserv-conf

	# Create the log dir and keep
	diropts -m0700
	dodir /var/log/webmin
	keepdir /var/log/webmin

	# Create the init.d file and put the neccessary variables there
	newinitd "${FILESDIR}"/init.d.webmin webmin
	sed -i \
		-e "s:%exe%:${EROOT}usr/libexec/webmin/miniserv.pl:" \
		-e "s:%pid%:${EROOT}var/run/webmin.pid:" \
		-e "s:%conf%:${EROOT}etc/webmin/miniserv.conf:" \
		-e "s:%config%:${EROOT}etc/webmin/config:" \
		-e "s:%perllib%:${EROOT}usr/libexec/webmin:" \
		"${ED}etc/init.d/webmin" \
		|| die "Failed to patch the webmin init file"

	# Create the systemd service file and put the neccessary variables there
	systemd_newunit "${FILESDIR}"/webmin.service webmin.service
	sed -i \
		-e "s:%exe%:${EROOT}usr/libexec/webmin/miniserv.pl:" \
		-e "s:%pid%:${EROOT}var/run/webmin.pid:" \
		-e "s:%conf%:${EROOT}etc/webmin/miniserv.conf:" \
		-e "s:%config%:${EROOT}etc/webmin/config:" \
		-e "s:%perllib%:${EROOT}usr/libexec/webmin:" \
		"${ED}$(_systemd_get_systemunitdir)/webmin.service" \
		|| die "Failed to patch the webmin systemd service file"

	# Setup pam
	pamd_mimic system-auth webmin auth account session

	# Copy files to installation folder
	ebegin "Copying install files to destination"
	cp -pPR "${S}"/* "${ED}usr/libexec/webmin"
	eend $?
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
	# Run pkg_config phase first - non interactively
	export INTERACTIVE="no"
	pkg_config
	# Every next time pkg_config should be interactive
	INTERACTIVE="yes"

	ewarn
	ewarn "Bare in mind that not all Webmin modules are Gentoo tweaked and may have some issues."
	ewarn "Always be careful when using modules that modify init entries, do update of webmin, install CPAN modules etc."
	ewarn "To avoid problems, please before using any module, look at its configuration options first."
	ewarn "(Usually there is a link at top in the right pane of Webmin for configuring the module.)"
	ewarn
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
		ewarn
		ewarn "You have uninstalled Webmin, so have in mind that all cron jobs scheduled"
		ewarn "by Webmin for its own modules, are left active and they will fail when Webmin is missing."
		ewarn "To fix this just disable them if you intend to use Webmin again,"
		ewarn "OR delete them if not."
		ewarn
	fi
}

pkg_config(){
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
	if [[ ! -e "${EROOT}etc/ssl/webmin/server.pem" ]]; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Webmin Server}"
		SSL_COMMONNAME="${SSL_COMMONNAME:-*}"
		install_cert "${EROOT}/etc/ssl/webmin/server"
	fi

	# Ensure all paths passed to the setup script use EROOT
	export wadir="${EROOT}usr/libexec/webmin"
	export config_dir="${EROOT}etc/webmin"
	export var_dir="${EROOT}var/log/webmin"
	export tempdir="${T}"
	export pidfile="${EROOT}var/run/webmin.pid"
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
	export keyfile="${EROOT}etc/ssl/webmin/server.pem"
	export port=10000

	export atboot=0

	einfo "Executing Webmin's configure script"
	$wadir/gentoo-setup.sh

	einfo "Configuration of Webmin done"
}
