# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/webdavcgi/webdavcgi-0.8.3.ebuild,v 1.5 2015/06/13 17:22:20 dilfridge Exp $

EAPI=4

inherit eutils toolchain-funcs webapp

DESCRIPTION="A Perl CGI for accessing and sharing files, or calendar/addressbooks via WebDAV"
HOMEPAGE="http://webdavcgi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
WEBAPP_MANUAL_SLOT="yes"
KEYWORDS="~amd64"
IUSE="mysql postgres rcs samba +sqlite +suid"

DEPEND=""
RDEPEND="dev-perl/Archive-Zip
	dev-perl/File-Copy-Link
	dev-perl/PerlIO-gzip
	dev-perl/Quota
	dev-perl/TimeDate
	dev-perl/URI
	dev-perl/UUID-Tiny
	dev-perl/XML-Simple
	media-gfx/graphicsmagick[perl]
	mysql? ( dev-perl/DBD-mysql )
	virtual/perl-Module-Load
	postgres? ( dev-perl/DBD-Pg )
	rcs? ( dev-perl/Rcs )
	samba? ( dev-perl/Filesys-SmbClient )
	sqlite? ( dev-perl/DBD-SQLite )
	dev-perl/CGI
	virtual/perl-File-Spec"

need_httpd_cgi

REQUIRED_USE="|| ( mysql postgres sqlite )"

CGIBINDIR="cgi-bin"

src_prepare() {
	epatch "${FILESDIR}/${PV}-logout-var-expansion.patch"
}

src_compile() {
	if use suid; then
		# There are several webdavwrappers, TODO: make it configureable
		export WEBDAVWRAPPER="webdavwrapper"

		$(tc-getCC) ${LDFLAGS} ${CFLAGS} \
			-o "${CGIBINDIR}/${WEBDAVWRAPPER}" \
			helper/webdavwrapper.c || die "compile ${WEBDAVWRAPPER} failed"
	fi
}

src_install() {
	webapp_src_preinst

	local htdocsDir='htdocs'
	local confDir='etc'

	local installDirs="$confDir lib locale"

	insinto "${MY_HTDOCSDIR}"
	doins -r "${htdocsDir}"/*

	exeinto "${MY_CGIBINDIR}"
	newexe "${CGIBINDIR}/logout-dist" logout

	doexe "${CGIBINDIR}/webdav.pl"
	use suid && doexe "${CGIBINDIR}/${WEBDAVWRAPPER}"

	local currentDir
	for currentDir in ${installDirs}; do
		dodir "${MY_HOSTROOTDIR}/${currentDir}"
		insinto "${MY_HOSTROOTDIR}/${currentDir}"
		doins -r "${currentDir}"/*
	done

	webapp_configfile "${MY_HOSTROOTDIR}/${confDir}"/{webdav.conf-dist,mime.types}

	use mysql && webapp_sqlscript mysql sql/mysql.sql
	use postgres && webapp_sqlscript postgres sql/postgresql.sql

	dodoc CHANGELOG TODO
	dohtml -r doc/*

	webapp_hook_script "${FILESDIR}/reconfig"

	webapp_src_install

	# In order to change the user and group ID at runtime, the webdavwrapper
	# needs to be run as root (set-user-ID and set-group-ID bit)
	if use suid; then
		einfo "Setting SUID and SGID bit for ${WEBDAVWRAPPER}"
		fowners root:root "${MY_CGIBINDIR}/${WEBDAVWRAPPER}"
		fperms 6755 "${MY_CGIBINDIR}/${WEBDAVWRAPPER}"
		webapp_postinst_txt en "${FILESDIR}/postinstall-${WEBDAVWRAPPER}-en.txt"
		webapp_hook_script "${FILESDIR}/reconfig-suid"
	else
		ewarn "You have the 'suid' USE flag disabled"
		ewarn "WebDAV CGI won't be able to switch user ids"
		webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"
	fi
}
