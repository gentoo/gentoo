# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="BackupPC-${PV}"

inherit depend.apache systemd

DESCRIPTION="High-performance backups to a server's disk"
HOMEPAGE="http://backuppc.sourceforge.net/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="rss samba"

DEPEND="
	acct-group/backuppc
	acct-user/backuppc
	app-admin/apache-tools
	app-admin/makepasswd
	dev-lang/perl
"

# The CGI modules are handled in $RDEPEND.
APACHE_MODULES="apache2_modules_alias," # RedirectMatch
APACHE_MODULES+="apache2_modules_authn_core," # AuthType
APACHE_MODULES+="apache2_modules_authz_core," # Require
APACHE_MODULES+="apache2_modules_authz_host," # Require host
APACHE_MODULES+="apache2_modules_authz_user" # Require valid-user

# Older versions of mod_perl think they're compatibile with apache-2.4,
# so we require the new one explicitly.
RDEPEND="
	${DEPEND}
	app-arch/par2cmdline
	dev-perl/Archive-Zip
	dev-perl/CGI
	dev-perl/File-RsyncP
	dev-perl/libwww-perl
	virtual/mta
	virtual/perl-IO-Compress
	www-apache/mod_perl
	www-apache/mpm_itk
	|| (
		>=www-servers/apache-2.4[${APACHE_MODULES},apache2_modules_cgi]
		>=www-servers/apache-2.4[${APACHE_MODULES},apache2_modules_cgid]
		>=www-servers/apache-2.4[${APACHE_MODULES},apache2_modules_fcgid]
	)
	rss? ( dev-perl/XML-RSS )
	samba? ( net-fs/samba )"

PATCHES=(
	"${FILESDIR}/3.3.0/01-fix-configure.pl.patch"
	"${FILESDIR}/3.3.0/02-fix-config.pl-formatting.patch"
	"${FILESDIR}/3.3.0/03-reasonable-config.pl-defaults.patch"
	"${FILESDIR}/3.2.0/04-add-docdir-marker.patch"
	"${FILESDIR}/3.2.0/05-nicelevel.patch"
	"${FILESDIR}"/${P}-perl522.patch #580254
	"${FILESDIR}"/${P}-perl526.patch #594128
)

CGIDIR="/usr/lib/backuppc/htdocs"
CONFDIR="/etc/BackupPC"
DATADIR="/var/lib/backuppc"
DOCDIR="/usr/share/doc/${PF}"
LOGDIR="/var/log/BackupPC"
need_apache2_4

src_prepare() {
	default

	# Fix initscript
	sed -e 's/runscript/openrc-run/g' -i init.d/src/gentoo-backuppc || die

	# Fix docs location using the marker that we've patched in.
	sed "s+__DOCDIR__+${DOCDIR}+" -i "lib/BackupPC/CGI/View.pm" || die
}

src_install() {
	local myconf
	myconf=""
	if use samba ; then
		myconf="--bin-path smbclient=$(type -p smbclient)"
		myconf="${myconf} --bin-path nmblookup=$(type -p nmblookup)"
	fi

	/usr/bin/env perl ./configure.pl \
		--batch \
		--bin-path perl=$(type -p perl) \
		--bin-path tar=$(type -p tar) \
		--bin-path rsync=$(type -p rsync) \
		--bin-path ping=$(type -p ping) \
		--bin-path df=$(type -p df) \
		--bin-path ssh=$(type -p ssh) \
		--bin-path sendmail=$(type -p sendmail) \
		--bin-path hostname=$(type -p hostname) \
		--bin-path gzip=$(type -p gzip) \
		--bin-path bzip2=$(type -p bzip2) \
		--config-dir "${CONFDIR}" \
		--install-dir /usr \
		--data-dir "${DATADIR}" \
		--hostname 127.0.0.1 \
		--uid-ignore \
		--dest-dir "${D}" \
		--html-dir "${CGIDIR}"/image \
		--html-dir-url /image \
		--cgi-dir "${CGIDIR}" \
		--fhs \
		${myconf} || die "failed the configure.pl script"

	ebegin "Installing documentation"

	pod2man \
		-errors=none \
		--section=8 \
		--center="BackupPC manual" \
		"${S}"/doc/BackupPC.pod backuppc.8 \
		|| die "failed to generate man page"

	doman backuppc.8

	# Place the documentation in the correct location
	dodoc "${D}/usr/doc/BackupPC.html"
	dodoc "${D}/usr/doc/BackupPC.pod"
	rm -rf "${D}/usr/doc" || die

	eend 0

	# Setup directories
	dodir "${CONFDIR}/pc"

	keepdir "${CONFDIR}"
	keepdir "${CONFDIR}/pc"
	keepdir "${DATADIR}"/{trash,pool,pc,cpool}
	keepdir "${LOGDIR}"

	ebegin "Setting up init.d/conf.d/systemd scripts"
	newinitd "${S}"/init.d/gentoo-backuppc backuppc
	newconfd "${S}"/init.d/gentoo-backuppc.conf backuppc
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${FILESDIR}"/99_backuppc.conf

	# Make sure that the ownership is correct
	chown -R backuppc:backuppc "${D}${CONFDIR}" || die
	chown -R backuppc:backuppc "${D}${DATADIR}" || die
	chown -R backuppc:backuppc "${D}${LOGDIR}"  || die
}

pkg_postinst() {
	elog "Installation finished, you may now start using BackupPC."
	elog
	elog "- Read the documentation in /usr/share/doc/${PF}/BackupPC.html"
	elog "  Please pay special attention to the security section."
	elog
	elog "- You can launch backuppc by running:"
	elog
	elog "    # /etc/init.d/backuppc start"
	elog
	elog "- To enable the GUI, first edit ${ROOT}/etc/conf.d/apache2 and add,"
	elog
	elog "    \"-D BACKUPPC -D PERL -D MPM_ITK\""
	elog
	elog "  to the APACHE2_OPTS line."
	elog
	elog "  Then you must edit ${ROOT}/etc/apache2/modules.d/00_mpm_itk.conf"
	elog "  and adjust the values of LimitUIDRange/LimitGIDRange to include"
	elog "  the UID and GID of the backuppc user."
	elog
	elog "  Finally, start apache:"
	elog
	elog "    # /etc/init.d/apache2 start"
	elog
	elog "  The web interface should now be running on,"
	elog
	elog "    http://127.0.0.1:8080/"
	elog

	# Generate a new password if there's no auth file
	if [[ ! -f "${CONFDIR}/users.htpasswd" ]]; then
		adminuser="backuppc"
		adminpass=$( makepasswd --chars=12 )
		htpasswd -bc "${CONFDIR}/users.htpasswd" $adminuser $adminpass

		elog ""
		elog "- Created admin user $adminuser with password $adminpass"
		elog "  To add new users, run: "
		elog ""
		elog "  # htpasswd ${CONFDIR}/users.htpasswd newUser"
	fi
}
