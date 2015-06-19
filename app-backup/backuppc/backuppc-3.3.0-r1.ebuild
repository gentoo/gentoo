# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/backuppc/backuppc-3.3.0-r1.ebuild,v 1.1 2014/12/02 10:35:09 pacho Exp $

EAPI="5"

inherit eutils systemd webapp user

MY_P="BackupPC-${PV}"

DESCRIPTION="A high-performance system for backing up computers to a server's disk"
HOMEPAGE="http://backuppc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

IUSE="rss samba"

DEPEND="dev-lang/perl
	app-admin/apache-tools
	app-admin/makepasswd"
RDEPEND="${DEPEND}
	virtual/perl-IO-Compress
	dev-perl/Archive-Zip
	dev-perl/libwww-perl
	>=app-arch/tar-1.13.20
	app-arch/par2cmdline
	app-arch/gzip
	app-arch/bzip2
	virtual/mta
	www-apache/mod_perl
	www-servers/apache
	net-misc/rsync
	>=dev-perl/File-RsyncP-0.68
	rss? ( dev-perl/XML-RSS )
	samba? ( net-fs/samba )"

WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

S=${WORKDIR}/${MY_P}

CONFDIR="/etc/BackupPC"
DATADIR="/var/lib/backuppc"
LOGDIR="/var/log/BackupPC"

pkg_setup() {
	webapp_pkg_setup
	enewgroup backuppc
	enewuser backuppc -1 /bin/bash /var/lib/backuppc backuppc
}

src_prepare() {
	epatch "${FILESDIR}/3.3.0/01-fix-configure.pl.patch"
	epatch "${FILESDIR}/3.3.0/02-fix-config.pl-formatting.patch"
	epatch "${FILESDIR}/3.3.0/03-reasonable-config.pl-defaults.patch"

	# Fix the documentation location in the CGI interface
	epatch "${FILESDIR}/3.2.0/04-add-docdir-marker.patch"
	sed -i "s+__DOCDIR__+/usr/share/doc/${PF}+" "lib/BackupPC/CGI/View.pm"

	epatch "${FILESDIR}/3.2.0/05-nicelevel.patch"
	sed -i -e 's/--chuid ${USER}//' "${S}"/init.d/src/gentoo-backuppc || die "Failed to fix the init script"
}

src_test() {
	true
}

src_install() {
	webapp_src_preinst

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
		--config-dir ${CONFDIR} \
		--install-dir /usr \
		--data-dir ${DATADIR} \
		--hostname $(hostname) \
		--uid-ignore \
		--dest-dir "${D%/}" \
		--html-dir ${MY_HTDOCSDIR}/image \
		--html-dir-url /image \
		--cgi-dir ${MY_HTDOCSDIR} \
		--fhs \
		${myconf} || die "failed the configure.pl script"

	ebegin "Installing documentation"

	pod2man \
		-errors=none \
		--section=8 \
		--center="BackupPC manual" \
		"${S}"/doc/BackupPC.pod backuppc.8 || die "failed to generate man page"

	doman backuppc.8

	# Place the documentation in the correct location
	dodoc "${D}/usr/doc/BackupPC.html"
	dodoc "${D}/usr/doc/BackupPC.pod"
	rm -rf "${D}/usr/doc"

	eend 0

	# Setup directories
	dodir ${CONFDIR}/pc

	keepdir ${CONFDIR}
	keepdir ${CONFDIR}/pc
	keepdir ${DATADIR}/{trash,pool,pc,cpool}
	keepdir ${LOGDIR}

	ebegin "Setting up init.d/conf.d/systemd scripts"
	newinitd "${S}"/init.d/gentoo-backuppc backuppc
	newconfd "${S}"/init.d/gentoo-backuppc.conf backuppc
	systemd_dounit "${FILESDIR}/${PN}.service"
	eend 0

	ebegin "Setting up an apache instance for backuppc"

	cp "${FILESDIR}/apache2-backuppc."{conf,init} "${WORKDIR}/"
	cp "${FILESDIR}/httpd.conf" "${WORKDIR}/httpd.conf"
	sed -i -e "s+HTDOCSDIR+${MY_HTDOCSDIR}+g" "${WORKDIR}/httpd.conf"
	sed -i -e "s+AUTHFILE+${CONFDIR}/users.htpasswd+g" "${WORKDIR}/httpd.conf"

	moduledir="/usr/lib/apache2/modules"

	# Check if the Apache ServerRoot is real.
	# This is sometimes broken on older amd64 systems.
	# In this case we just patch our config file appropriately.
	if [[ ! -d "/usr/lib/apache2" ]]; then
		if [[ -d "/usr/lib64/apache2" ]]; then
			sed -i -e "s+/usr/lib/apache2+/usr/lib64/apache2+g" "${WORKDIR}/httpd.conf"
			sed -i -e "s+/usr/lib/apache2+/usr/lib64/apache2+g" "${WORKDIR}/apache2-backuppc.conf"
			moduledir="/usr/lib64/apache2/modules"
		fi
	fi

	# Check if we're using mod_cgid instead of mod_cgi
	# This happens if you install apache with USE="threads"
	if [[ -f "${moduledir}/mod_cgid.so" ]]; then
		sed -i -e "s+mod_cgi+mod_cgid+g" "${WORKDIR}/httpd.conf"
		sed -i -e "s+cgi_module+cgid_module+g" "${WORKDIR}/httpd.conf"
	fi

	# Install conf.d/init.d files for apache2-backuppc
	if [ -e /etc/init.d/apache2 ]; then
		newconfd "${WORKDIR}/apache2-backuppc.conf" apache2-backuppc
		newinitd /etc/init.d/apache2 apache2-backuppc
	else
		newconfd "${WORKDIR}/apache2-backuppc.conf" apache2-backuppc
		newinitd "${WORKDIR}/apache2-backuppc.init" apache2-backuppc
	fi

	insopts -m 0644
	insinto ${CONFDIR}
	doins "${WORKDIR}/httpd.conf"

	eend $?

	webapp_src_install || die "webapp_src_install"

	# Make sure that the ownership is correct
	chown -R backuppc:backuppc "${D}${CONFDIR}"
	chown -R backuppc:backuppc "${D}${DATADIR}"
	chown -R backuppc:backuppc "${D}${LOGDIR}"
}

pkg_postinst() {
	# This is disabled since BackupPC doesn't need it
	# webapp_pkg_postinst

	elog "Installation finished, now may now start using BackupPC."
	elog ""
	elog "- Read the documentation in /usr/share/doc/${PF}/BackupPC.html"
	elog "  Please pay special attention to the security section."
	elog ""
	elog "- You can launch backuppc and it's apache web interface by running:"
	elog "  # /etc/init.d/backuppc start"
	elog "  # /etc/init.d/apache2-backuppc start"

	if [[ ! -e /etc/runlevels/default/backuppc ]]; then
		elog ""
		elog "- You also might want to add these scripts to your default runlevel:"
		elog "  # rc-update add backuppc default"
		elog "  # rc-update add apache2-backuppc default"
	fi

	# Generate a new password if there's no auth file
	if [[ ! -f "${CONFDIR}/users.htpasswd" ]]; then
		adminuser="backuppc"
		adminpass=$( makepasswd --chars=12 )
		htpasswd -bc "${CONFDIR}/users.htpasswd" $adminuser $adminpass

		elog ""
		elog "- Created admin user $adminuser with password $adminpass"
		elog "  To add new users, run: "
		elog "  # htpasswd ${CONFDIR}/users.htpasswd newUser"
	fi

	if [[ -d "/etc/backuppc" ]]; then
		ewarn ""
		ewarn "Detected old config directory in /etc/backuppc"
		ewarn "Please migrate relevant config files to ${CONFDIR} before starting backuppc"
	fi
}
