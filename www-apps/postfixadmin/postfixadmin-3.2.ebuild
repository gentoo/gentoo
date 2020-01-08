# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit user webapp

DESCRIPTION="Web Based Management tool for Postfix style virtual domains and users"
HOMEPAGE="http://postfixadmin.sourceforge.net"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
IUSE="+mysql postgres +vacation"
REQUIRED_USE="|| ( mysql postgres )"

DEPEND="
	dev-lang/php:*[unicode,imap,postgres?]
	vacation? (
		dev-perl/DBI
		dev-perl/Email-Sender
		dev-perl/Email-Valid
		dev-perl/Log-Dispatch
		dev-perl/Log-Log4perl
		dev-perl/MIME-Charset
		dev-perl/MIME-EncWords
		mysql? ( dev-perl/DBD-mysql )
		postgres? ( dev-perl/DBD-Pg )
	)
"

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
		newdoc VIRTUAL_VACATION/INSTALL.md VIRTUAL_VACATION_INSTALL.md
		rm -r VIRTUAL_VACATION/{vacation.pl,INSTALL.md,tests,FILTER_README} || die
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
		ln -sf "${ROOT}"/var/spool/vacation/vacation.pl{-${SLOT},} || die
	fi
}

pkg_postrm() {
	# Make sure we don't leave broken vacation.pl symlink
	find -L "${ROOT}"/var/spool/vacation/ -type l -delete
	local shopt_save=$(shopt -p nullglob)
	shopt -s nullglob
	local vacation=( "${ROOT}"/var/spool/vacation/vacation.pl-* )
	${shopt_save}
	if [[ ! -e "${ROOT}"/var/spool/vacation/vacation.pl && -n ${vacation[@]} ]]; then
		ln -s "${vacation[-1]}" "${ROOT}"/var/spool/vacation/vacation.pl || die
		ewarn "/var/spool/vacation/vacation.pl was updated to point on most"
		ewarn "recent verion, but please, do your own checks"
	fi
}
