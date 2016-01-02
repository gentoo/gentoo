# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit webapp depend.apache eutils

DESCRIPTION="Bugzilla is the Bug-Tracking System from the Mozilla project"
SRC_URI="https://ftp.mozilla.org/pub/mozilla.org/webtools/${P}.tar.gz"
HOMEPAGE="https://www.bugzilla.org"

LICENSE="MPL-2.0"
KEYWORDS="~amd64 ~x86"

IUSE="modperl extras graphviz mysql postgres sqlite test"
REQUIRED_USE=" || ( mysql postgres sqlite )"

COMMON_DEPS="
	>=dev-lang/perl-5.10.1:*
	>=dev-perl/CGI-3.510:*
	virtual/perl-Digest-SHA:*
	>=dev-perl/DateTime-0.50:*
	>=dev-perl/DateTime-TimeZone-0.71:*
	>=dev-perl/DBI-1.601:*
	>=dev-perl/Template-Toolkit-2.22:*
	>=dev-perl/Email-Send-2.190:*
	>=dev-perl/Email-MIME-1.904:*
	dev-perl/URI:*
	>=dev-perl/List-MoreUtils-0.32:*
	dev-perl/Math-Random-ISAAC:*
"

DEPEND="test? ( dev-perl/Pod-Coverage:* ${COMMON_DEPS} )"
RDEPEND="
	virtual/httpd-cgi:*
	${COMMON_DEPS}
	postgres? ( >=dev-perl/DBD-Pg-1.49:* )
	mysql? ( >=dev-perl/DBD-mysql-4.00.5:* )
	sqlite? ( >=dev-perl/DBD-SQLite-1.29:* )
	extras? (
		>=dev-perl/GD-2.35[png,truetype]
		>=dev-perl/Chart-2.4.1:*
		dev-perl/Template-GD:*
		dev-perl/GDTextUtil:*
		dev-perl/GDGraph:*
		dev-perl/XML-Twig:*
		>=dev-perl/MIME-tools-5.427:*
		dev-perl/libwww-perl:*
		>=dev-perl/PatchReader-0.9.6:*
		dev-perl/perl-ldap:*
		dev-perl/RadiusPerl:*
		dev-perl/Authen-SASL:*
		>=dev-perl/SOAP-Lite-0.712:*
		dev-perl/JSON-RPC:*
		>=dev-perl/JSON-XS-2.0:*
		dev-perl/Test-Taint:*
		>=dev-perl/HTML-Parser-3.67:*
		dev-perl/HTML-Scrubber:*
		>=virtual/perl-Encode-2.21:*
		dev-perl/Encode-Detect:*
		dev-perl/Email-MIME-Attachment-Stripper:*
		dev-perl/Email-Reply:*
		dev-perl/TheSchwartz:*
		dev-perl/Daemon-Generic:*
		dev-perl/File-MimeInfo:*
		|| ( media-gfx/imagemagick[perl] media-gfx/graphicsmagick[imagemagick,perl] )
		dev-perl/MIME-tools:*
	)
	modperl? (
		www-apache/mod_perl:1
		>=dev-perl/Apache-SizeLimit-0.96:*
	)
	graphviz? ( media-gfx/graphviz:* )
"
want_apache modperl
need_httpd_cgi

pkg_setup() {
	depend.apache_pkg_setup modperl
	webapp_pkg_setup
}

src_prepare() {
	# Get a rid of the bzr files
	rm -r .bzr* || die

	# Remove bundled perl modules
	rm -r lib/ || die
}

src_test() {
	perl runtests.pl || die
}

src_install () {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	doins "${FILESDIR}"/bugzilla.cron.{daily,tab}

	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install

	if use extras; then
		newconfd "${FILESDIR}"/bugzilla-queue.confd bugzilla-queue
		newinitd "${FILESDIR}"/bugzilla-queue.initd bugzilla-queue
	fi

	# bug #124282
	chmod +x "${D}${MY_HTDOCSDIR}"/*.cgi || die

	chmod u+x "${D}${MY_HTDOCSDIR}"/jobqueue.pl || die

	# configuration must be executable
	chmod u+x "${D}${MY_HTDOCSDIR}"/checksetup.pl || die

	# bug 487476
	mkdir "${D}${MY_HTDOCSDIR}"/lib || die
}
