# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs versionator

DESCRIPTION="A Perl CGI for accessing and sharing files, or calendar/addressbooks via WebDAV"
HOMEPAGE="http://webdavcgi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"

# Provide slotting on minor versions. WebDAV CGI is a web application which
# can be shared by multiple instances and thus major updates shouldn't be
# enforced to all users/instances at the same time.
SLOT="$(get_version_component_range 1-2)"

KEYWORDS="~amd64"
IUSE="afs kerberos mysql postgres rcs samba +sqlite +suid"

DEPEND=""
RDEPEND="!www-apps/webdavcgi:0
	afs? ( net-fs/openafs )
	dev-lang/perl
	dev-perl/Archive-Zip
	dev-perl/File-Copy-Link
	dev-perl/PerlIO-gzip
	dev-perl/Quota
	dev-perl/TimeDate
	dev-perl/URI
	dev-perl/UUID-Tiny
	dev-perl/XML-Simple
	kerberos? ( virtual/krb5 )
	media-gfx/graphicsmagick[perl]
	mysql? ( dev-perl/DBD-mysql )
	virtual/perl-Module-Load
	postgres? ( dev-perl/DBD-Pg )
	rcs? ( dev-perl/Rcs )
	samba? ( dev-perl/Filesys-SmbClient )
	sqlite? ( dev-perl/DBD-SQLite )
	dev-perl/CGI
	virtual/perl-File-Spec
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
	for currentDir in htdocs lib locale; do
		insinto "${installBaseDir}/${currentDir}"
		doins -r "${currentDir}"/*
	done

	if use mysql || use postgres; then
		local sqlDir='sql'
		insinto "${installBaseDir}/${sqlDir}"
		use mysql    && "${sqlDir}/mysql.sql"
		use postgres && "${sqlDir}/postgresql.sql"
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

	# Default thumbnail directory, writable by all users
	export THUMBNAILDIR="/var/cache/${PN}/${SLOT}/default/thumbnails"
	keepdir "${THUMBNAILDIR}"
	fperms 1777 "${THUMBNAILDIR}"

	export APACHEEXAMPLECONFIG="apache-webdavcgi-${SLOT}-example.conf"
	dodoc CHANGELOG TODO
	dodoc "${FILESDIR}/${APACHEEXAMPLECONFIG}"
	dohtml -r doc/*
}

pkg_postinst() {
	ewarn "In order to allow different users to create and share files,"
	ewarn "some directories were installed with world write access by default."
	ewarn "To set restrictive permissions, add all WebDAV CGI users to a"
	ewarn "common group, and allow access to the following directories by this"
	ewarn "group only."
	ewarn "Thumbnail directory: ${THUMBNAILDIR}"
	use sqlite && ewarn "SQLite directory:    ${SQLITEDIR}"

	ewarn
	ewarn "Until bug #456180 is fixed, you probably have to re-emerge"
	ewarn "media-gfx/graphicsmagick"

	elog
	elog "The WebDAV CGI config is located at ${WEBDAVCONFIG}."
	elog
	elog "An example Apache HTTP server configuration snippet is available in"
	elog "/usr/share/doc/${PF} in the file ${APACHEEXAMPLECONFIG}"

	einfo
	einfo "Detailed installation and configuration instructions can be found at"
	einfo "http://webdavcgi.sourceforge.net/"
}
