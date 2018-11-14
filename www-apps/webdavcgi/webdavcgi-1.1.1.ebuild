# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs versionator

DESCRIPTION="A Perl CGI for accessing and sharing files, or calendar/addressbooks via WebDAV."
HOMEPAGE="http://webdavcgi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3+"

# Provide slotting on minor versions. WebDAV CGI is a web application which
# can be shared by multiple instances and thus major updates shouldn't be
# enforced to all users/instances at the same time.
SLOT="$(get_version_component_range 1-2)"

KEYWORDS="~amd64"
IUSE="afs git kerberos ldap mysql pdf postgres rcs samba +sqlite +suid"

DEPEND=""
RDEPEND="afs? ( net-fs/openafs )
	dev-lang/perl
	dev-perl/Archive-Zip
	dev-perl/CGI
	dev-perl/DateTime
	dev-perl/DateTime-Format-Human-Duration
	dev-perl/File-Copy-Link
	dev-perl/JSON
	dev-perl/List-MoreUtils
	dev-perl/MIME-tools
	dev-perl/PerlIO-gzip
	dev-perl/Quota
	dev-perl/TimeDate
	dev-perl/URI
	dev-perl/UUID-Tiny
	dev-perl/XML-Simple
	git? ( dev-vcs/git )
	kerberos? ( virtual/krb5 )
	ldap? ( dev-perl/perl-ldap )
	media-gfx/graphicsmagick[perl]
	media-libs/exiftool
	mysql? ( dev-perl/DBD-mysql )
	pdf? ( app-text/ghostscript-gpl )
	postgres? ( dev-perl/DBD-Pg )
	rcs? ( dev-perl/Rcs )
	samba? ( net-fs/cifs-utils dev-perl/Filesys-SmbClient )
	sqlite? ( dev-perl/DBD-SQLite )
	virtual/perl-File-Spec
	virtual/perl-Module-Load
	|| ( virtual/httpd-cgi virtual/httpd-fastcgi )"

REQUIRED_USE="|| ( mysql postgres sqlite )"

CGIBINDIR="cgi-bin"

src_compile() {
	if use suid; then
		WEBDAVWRAPPERS="webdavwrapper" # Standard UID/GID wrapper

		use afs      && WEBDAVWRAPPERS+=" webdavwrapper-afs"
		use kerberos && WEBDAVWRAPPERS+=" webdavwrapper-krb"

		export WEBDAVWRAPPERS

		local wrapper
		for wrapper in ${WEBDAVWRAPPERS}; do
			$(tc-getCC) ${LDFLAGS} ${CFLAGS} \
				-o "${CGIBINDIR}/${wrapper}" \
				"helper/${wrapper}.c" || die "compile ${wrapper} failed"
		done
	fi
}

src_install() {
	exeinto "/usr/libexec/${PN}-${SLOT}/${CGIBINDIR}"
	newexe "${CGIBINDIR}/logout-dist" "logout"
	doexe "${CGIBINDIR}/webdav.pl"

	use afs   && doexe "${CGIBINDIR}/afswrapper"
	use samba && doexe "${CGIBINDIR}/smbwrapper"

	if use suid; then
		# In order to change the user and group ID at runtime, the webdavwrapper
		# needs to be run as root (set-user-ID and set-group-ID bit)
		exeopts -o root -g root -m 6755

		local wrapper
		for wrapper in ${WEBDAVWRAPPERS}; do
			einfo "Installing UID/GID wrapper ${wrapper}"
			doexe "${CGIBINDIR}/${wrapper}"
		done

		# reset install opts
		exeopts
	else
		ewarn "You have the 'suid' USE flag disabled"
		ewarn "WebDAV CGI won't be able to switch user ids"
	fi

	local confDir='etc'
	local webdavConfDir="/etc/${PN}-${SLOT}/default"

	export WEBDAVCONFIG="${webdavConfDir}/webdav.conf"

	insinto "${webdavConfDir}"
	doins "${confDir}/mime.types"
	newins "${FILESDIR}/webdav-${SLOT}.conf" "webdav.conf"

	local installBaseDir="/usr/share/${PN}-${SLOT}"
	local currentDir
	for currentDir in htdocs lib locale templates; do
		insinto "${installBaseDir}/${currentDir}"
		doins -r "${currentDir}"/*
	done

	if use mysql || use postgres; then
		local sqlDir='sql'
		insinto "${installBaseDir}/${sqlDir}"
		use mysql    && doins "${sqlDir}/mysql.sql"
		use postgres && doins "${sqlDir}/postgresql.sql"
	fi

	if use sqlite; then
		# Directory where the SQLite database resides
		local sqliteRootDir="/var/lib/${PN}/${SLOT}"
		keepdir "${sqliteRootDir}"

		# Default database directory where all users are able to create and
		# share the databases, this can be changed within the config file and
		# restricted to user/group only access if required.
		export SQLITEDIR="${sqliteRootDir}/default"
		keepdir "${SQLITEDIR}"
		fperms 1777 "${SQLITEDIR}"
	fi

	# Create default temporary directories, writable by all users
	export TMPDIRS="trash thumbnails optimized"
	for tmpDir in ${TMPDIRS}; do
		keepdir "/var/tmp/${PN}/${SLOT}/default/${tmpDir}"
		fperms 1777 "/var/tmp/${PN}/${SLOT}/default/${tmpDir}"
	done

	export APACHEEXAMPLECONFIG="apache-webdavcgi-${SLOT}-example.conf"
	dodoc CHANGELOG
	dodoc etc/webdav.conf.complete
	dodoc "${FILESDIR}/${APACHEEXAMPLECONFIG}"
	dodoc -r "doc/"
}

pkg_postinst() {
	ewarn "In order to allow different users to create and share files,"
	ewarn "some directories were installed with world write access by default."
	ewarn "To set restrictive permissions, add all WebDAV CGI users to a"
	ewarn "common group, and allow access to the following directories by this"
	ewarn "group only."
	ewarn "Temp directories:    /var/tmp/${PN}/${SLOT}/default/*"
	use sqlite && ewarn "SQLite directory:    ${SQLITEDIR}"

	elog
	elog "The WebDAV CGI config is located at ${WEBDAVCONFIG}."
	elog
	elog "An example Apache HTTP server configuration snippet is available in"
	elog "${ROOT%/}/usr/share/doc/${PF} in the file ${APACHEEXAMPLECONFIG}"
	elog
	elog "An important note to systemd user's running the Apache HTTP server:"
	elog "The default apache2.service will be started with private file system"
	elog "namespaces for /var/tmp and /tmp enabled (PrivateTmp=true)."
	elog "This means that you either need to disable PrivateTmp, relocate the"
	elog "directories starting with /var/tmp within ${WEBDAVCONFIG}"
	elog "or pre-create the directory structure with a user defined systemd"
	elog "companion unit using the JoinsNamespaceOf directive."
	elog
	elog "To disable the private file system namespace, override the existing"
	elog "service:"
	elog "systemctl edit apache2.service"
	elog "[Service]"
	elog "PrivateTmp=false"

	einfo
	einfo "Detailed installation and configuration instructions can be found at"
	einfo "http://webdavcgi.sourceforge.net/"
}
