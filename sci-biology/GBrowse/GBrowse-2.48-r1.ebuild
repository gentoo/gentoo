# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=LDS
inherit perl-module webapp

DESCRIPTION="Generic Model Organism Database Project - The Generic Genome Browser"
HOMEPAGE="http://gmod.org/wiki/GBrowse"
KEYWORDS="~amd64 ~x86"
IUSE="-minimal mysql postgres +sqlite"

SLOT="0"
WEBAPP_MANUAL_SLOT="yes"

CDEPEND="!<sci-biology/GBrowse-2.44-r1
	>=sci-biology/bioperl-1.6.9
	>=dev-perl/Bio-Graphics-2.09
	>=dev-perl/GD-2.07
	>=dev-perl/CGI-Session-4.02
	dev-perl/IO-String
	dev-perl/JSON
	dev-perl/libwww-perl
	dev-perl/Statistics-Descriptive
	!minimal? (
		dev-perl/Bio-Das
		>=dev-perl/Bio-SamTools-1.20
		dev-perl/Crypt-SSLeay
		dev-perl/DB_File-Lock
		dev-perl/DBI
		mysql? ( dev-perl/DBD-mysql )
		postgres? ( dev-perl/DBD-Pg )
		sqlite? ( dev-perl/DBD-SQLite )
		dev-perl/FCGI
		dev-perl/File-NFSLock
		dev-perl/GD-SVG
		dev-perl/Net-OpenID-Consumer
		dev-perl/Net-SMTP-SSL
	)"
#		>=dev-perl/Bio-DB-BigFile-1.00 - requires jklib to compile
DEPEND="dev-perl/Module-Build
	dev-perl/Capture-Tiny
	${CDEPEND}"
RDEPEND="${CDEPEND}"

PATCHES=( "${FILESDIR}"/GBrowseInstall.pm-2.39.patch )

src_configure() {
	webapp_src_preinst

#	myconf="--install_base=${D}/usr" or "--install_base=/opt/gbrowse"
	myconf="--conf=/etc/gbrowse2"
	myconf="${myconf} --htdocs=${MY_HTDOCSDIR}"
	myconf="${myconf} --cgibin=${MY_CGIBINDIR}"
	myconf="${myconf} --tmp=/var/tmp/gbrowse2"
	myconf="${myconf} --persistent=/var/db/gbrowse2"
	myconf="${myconf} --databases=/var/db/gbrowse2/databases"
	myconf="${myconf} --installconf=no"
	myconf="${myconf} --installetc=no"
	perl-module_src_configure
}

src_install() {
	dodir /var/tmp/gbrowse2
	dodir /var/db/gbrowse2/sessions
	dodir /var/db/gbrowse2/userdata
	webapp_serverowned -R /var/tmp/gbrowse2 /var/db/gbrowse2
	perl-module_src_install
	webapp_src_install
}
