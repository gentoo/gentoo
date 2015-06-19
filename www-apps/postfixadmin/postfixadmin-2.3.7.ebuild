# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/postfixadmin/postfixadmin-2.3.7.ebuild,v 1.5 2015/04/06 19:54:09 dilfridge Exp $

EAPI="4"

inherit user webapp

DESCRIPTION="Web Based Management tool for Postfix style virtual domains and users"
HOMEPAGE="http://postfixadmin.sourceforge.net"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
IUSE="+mysql postgres +vacation xmlrpc"
REQUIRED_USE="|| ( mysql postgres )"

DEPEND="vacation? ( dev-perl/DBI
		virtual/perl-MIME-Base64
		dev-perl/MIME-EncWords
		dev-perl/Email-Valid
		dev-perl/Mail-Sender
		dev-perl/Log-Dispatch
		dev-perl/Log-Log4perl
		dev-perl/MIME-Charset
		mysql? ( dev-perl/DBD-mysql )
		postgres? ( dev-perl/DBD-Pg ) )
	xmlrpc? ( dev-php/ZendFramework[-minimal] )
	dev-lang/php[unicode,imap,postgres?,xmlrpc?]"

RDEPEND="${DEPEND}
	virtual/httpd-php
	mysql? ( || ( dev-lang/php[mysqli] dev-lang/php[mysql] ) )"

need_httpd_cgi

pkg_setup() {
	webapp_pkg_setup

	if use vacation; then
		enewgroup vacation
		enewuser vacation -1 -1 -1 vacation
	fi
}

src_install() {
	webapp_src_preinst

	if use vacation; then
		insinto /var/spool/vacation
		newins VIRTUAL_VACATION/vacation.pl vacation.pl-${SLOT}
		fowners vacation:vacation /var/spool/vacation/vacation.pl-${SLOT}
		fperms 770 /var/spool/vacation/vacation.pl-${SLOT}
		dodoc VIRTUAL_VACATION/FILTER_README
		newdoc VIRTUAL_VACATION/INSTALL.TXT VIRTUAL_VACATION_INSTALL.TXT
		rm -r VIRTUAL_VACATION/{vacation.pl,INSTALL.TXT,tests,FILTER_README}
	fi

	insinto /usr/share/doc/${PF}/
	doins -r ADDITIONS

	local docs="DOCUMENTS/*.txt INSTALL.TXT CHANGELOG.TXT"
	dodoc ${docs}

	rm -rf ${docs} DOCUMENTS/ GPL-LICENSE.TXT LICENSE.TXT debian/ tests/ ADDITIONS/

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/config.inc.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-2.3.txt
	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
	if use vacation; then
		# portage does not update owners of directories (feature :)
		chown vacation:vacation "${ROOT}"/var/spool/vacation/
		einfo "/var/spool/vacation/vacation.pl symlink was updated to:"
		einfo "/var/spool/vacation/vacation.pl-${SLOT}"
		ln -sf "${ROOT}"/var/spool/vacation/vacation.pl{-${SLOT},}
	fi
}

pkg_postrm() {
	# Make sure we don't leave broken vacation.pl symlink
	find -L "${ROOT}"/var/spool/vacation/ -type l -delete
	if [[ ! -e "${ROOT}"/var/spool/vacation/vacation.pl ]] &&
		path_exists "${ROOT}"/var/spool/vacation/vacation.pl-*; then
		ln -s $(LC_ALL=C ls -1 /var/spool/vacation/vacation.pl-* | tail -n1) \
			"${ROOT}"/var/spool/vacation/vacation.pl
		ewarn "/var/spool/vacation/vacation.pl was updated to point on most"
		ewarn "recent verion, but please, do your own checks"
	fi
}
