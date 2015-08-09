# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit webapp depend.apache versionator eutils

#MY_PB=$(get_version_component_range 1-2)
MY_PB="4.0"

DESCRIPTION="Bugzilla is the Bug-Tracking System from the Mozilla project"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/webtools/${P}.tar.gz"
HOMEPAGE="http://www.bugzilla.org"

LICENSE="MPL-1.1"
KEYWORDS="~amd64 ~x86"

IUSE="modperl extras graphviz mysql postgres sqlite test"

COMMON_DEPS="
	>=dev-lang/perl-5.8.8

	>=dev-perl/CGI-3.510
	virtual/perl-Digest-SHA
	>=dev-perl/TimeDate-1.16
	>=dev-perl/DateTime-0.50
	>=dev-perl/DateTime-TimeZone-0.71
	>=dev-perl/DBI-1.601
	>=dev-perl/Template-Toolkit-2.22
	>=dev-perl/Email-Send-2.190
	>=dev-perl/Email-MIME-1.904
	dev-perl/URI
	>=dev-perl/List-MoreUtils-0.22

	virtual/perl-File-Path
	virtual/perl-Scalar-List-Utils

	>=virtual/perl-File-Spec-3.27.01
	>=virtual/perl-MIME-Base64-3.07

	dev-perl/Math-Random-Secure
"

DEPEND="test? ( ${COMMON_DEPS} )"
RDEPEND="
	virtual/httpd-cgi

	${COMMON_DEPS}

	postgres? ( >=dev-perl/DBD-Pg-1.49 )
	mysql? ( >=dev-perl/DBD-mysql-4.00.5 )
	sqlite? ( >=dev-perl/DBD-SQLite-1.29 )

	extras? (
		>=dev-perl/GD-2.35[png,truetype]
		>=dev-perl/Chart-2.4.1
		dev-perl/Template-GD
		dev-perl/GDTextUtil
		dev-perl/GDGraph
		dev-perl/XML-Twig
		>=dev-perl/MIME-tools-5.427
		dev-perl/libwww-perl
		>=dev-perl/PatchReader-0.9.6
		dev-perl/perl-ldap
		dev-perl/RadiusPerl
		dev-perl/Authen-SASL
		>=dev-perl/SOAP-Lite-0.712
		dev-perl/JSON-RPC
		>=dev-perl/JSON-XS-2.0
		dev-perl/Test-Taint
		>=dev-perl/HTML-Parser-3.67
		dev-perl/HTML-Scrubber
		>=virtual/perl-Encode-2.21
		dev-perl/Encode-Detect
		dev-perl/Email-MIME-Attachment-Stripper
		dev-perl/Email-Reply
		dev-perl/TheSchwartz
		dev-perl/Daemon-Generic
		dev-perl/File-MimeInfo

		|| ( media-gfx/imagemagick[perl] media-gfx/graphicsmagick[imagemagick,perl] )
		dev-perl/MIME-tools
	)

	modperl? (
		www-apache/mod_perl:1
		>=dev-perl/Apache-SizeLimit-0.96
	)

	graphviz? ( media-gfx/graphviz )
"

# RadiusPerl for extras? bug 252128

want_apache modperl

pkg_setup() {
	depend.apache_pkg_setup modperl
	webapp_pkg_setup
}

src_prepare() {
	# Get a rid of the bzr files
	rm -rf .bzr*

	# Remove bundled perl modules
	rm -rf lib/
}

src_test() {
	# Shall we remove runtests.pl and t/,xt/ on install?
	perl runtests.pl || die
}

src_install () {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r . || die
	doins "${FILESDIR}"/${MY_PB}/bugzilla.cron.{daily,tab} || die

	webapp_hook_script "${FILESDIR}"/${MY_PB}/reconfig
	webapp_postinst_txt en "${FILESDIR}"/${MY_PB}/postinstall-en.txt
	webapp_src_install

	if use extras; then
		newconfd "${FILESDIR}"/${MY_PB}/bugzilla-queue.confd bugzilla-queue || die
		newinitd "${FILESDIR}"/${MY_PB}/bugzilla-queue.initd bugzilla-queue || die
	fi

	# bug #124282
	chmod +x "${D}${MY_HTDOCSDIR}"/*.cgi

	chmod u+x "${D}${MY_HTDOCSDIR}"/jobqueue.pl

	# configuration must be executable
	chmod u+x "${D}${MY_HTDOCSDIR}"/checksetup.pl

	# bug 487476
	mkdir "${D}${MY_HTDOCSDIR}"/lib
}
