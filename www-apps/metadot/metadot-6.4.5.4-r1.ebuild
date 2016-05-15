# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit webapp
MY_P="Metadot${PV}"
S=${WORKDIR}/${PN}

IUSE=""

DESCRIPTION="Metadot is a CMS with file, page and link management, and collaboration features"
HOMEPAGE="http://www.metadot.com"
SRC_URI="http://download.metadot.com/${MY_P}.tar.gz"

KEYWORDS="ppc ~x86"

DEPEND=""
RDEPEND="
	>=dev-lang/perl-5.6
	=www-apache/mod_perl-2*
	dev-perl/DBI
	>=dev-perl/DBD-mysql-2.1027
	dev-perl/Apache-DBI
	>=dev-perl/AppConfig-1.55
	>=dev-perl/XML-RSS-1.02
	dev-perl/perl-ldap
	>=dev-perl/Log-Agent-0.304
	dev-perl/Mail-POP3Client
	>=dev-perl/IO-stringy-2.108
	dev-perl/MailTools
	dev-perl/MIME-tools
	>=dev-perl/Unicode-String-2.07
	>=dev-perl/Spreadsheet-WriteExcel-0.41
	>=dev-perl/Date-Calc-5.3
	>=dev-perl/Image-Size-2.991.0
	>=dev-perl/Template-Toolkit-2.09
	>=virtual/perl-Time-HiRes-1.48
	>=virtual/perl-Test-Harness-2.28
	>=dev-perl/Test-Manifest-0.91
	>=virtual/perl-Test-Simple-0.47
	>=dev-perl/Lingua-EN-NameParse-1.18
	>=dev-perl/Number-Format-1.45
	>=dev-perl/XML-Simple-2.08
	dev-perl/XML-Dumper
	dev-perl/Archive-Zip
	dev-perl/Date-Manip
	dev-perl/Text-CSV_XS
	dev-perl/HTML-Tree
	dev-perl/HTML-Format
	dev-perl/Data-ShowTable
"

LICENSE="GPL-2"

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG README
	cp -R [[:lower:]][[:lower:]]* "${D}"/${MY_HTDOCSDIR}

	cp "${FILESDIR}"/${PN}.conf "${D}"/${MY_HOSTROOTDIR}
	sed -i "s|Apache::Registry|Modperl::Registry|" \
		"${D}"/${MY_HOSTROOTDIR}/${PN}.conf

	webapp_serverowned ${MY_HTDOCSDIR}
	webapp_serverowned ${MY_HTDOCSDIR}/sitedata/public

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-6.4_p3.txt
	webapp_hook_script "${FILESDIR}"/reconfig-6.4_p3
	webapp_src_install
}
