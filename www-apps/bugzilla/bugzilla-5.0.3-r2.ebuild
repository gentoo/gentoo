# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp depend.apache eutils

DESCRIPTION="Bugzilla is the Bug-Tracking System from the Mozilla project"
SRC_URI="https://ftp.mozilla.org/pub/mozilla.org/webtools/${P}.tar.gz"
HOMEPAGE="https://www.bugzilla.org"

LICENSE="MPL-2.0"
KEYWORDS="amd64 x86"

IUSE="modperl extras graphviz mysql postgres sqlite test"
RESTRICT="!test? ( test )"
REQUIRED_USE=" || ( mysql postgres sqlite )"

# sorting is identical to upstream MYMETA.json, please dont change
COMMON_DEPS="
	dev-lang/perl
	>=dev-perl/CGI-3.510.0
	>=dev-perl/DBI-1.614.0
	>=dev-perl/TimeDate-2.230.0
	>=dev-perl/DateTime-0.750.0
	>=dev-perl/DateTime-TimeZone-1.640.0
	virtual/perl-Digest-SHA
	>=dev-perl/Email-MIME-1.904.0
	>=dev-perl/Email-Sender-1.300.11
	>=dev-perl/File-Slurp-9999.130.0
	>=dev-perl/JSON-XS-2.10.0
	>=dev-perl/List-MoreUtils-0.320.0
	>=dev-perl/Math-Random-ISAAC-1.0.1
	>=dev-perl/Template-Toolkit-2.240.0
	>=dev-perl/URI-1.550.0
"

DEPEND="test? ( dev-perl/Pod-Coverage ${COMMON_DEPS} )"
RDEPEND="
	virtual/httpd-cgi
	${COMMON_DEPS}
	postgres? ( >=dev-perl/DBD-Pg-1.49 )
	mysql? ( >=dev-perl/DBD-mysql-4.0.5 )
	sqlite? ( >=dev-perl/DBD-SQLite-1.290.0 )
	extras? (
		>=dev-perl/GD-2.350.0[png,truetype]
		>=dev-perl/Chart-2.4.1
		dev-perl/Template-GD
		dev-perl/GDTextUtil
		dev-perl/GDGraph
		dev-perl/XML-Twig
		>=dev-perl/MIME-tools-5.427.0
		dev-perl/libwww-perl
		>=dev-perl/PatchReader-0.9.6
		dev-perl/perl-ldap
		dev-perl/Authen-Radius
		dev-perl/Authen-SASL
		>=dev-perl/SOAP-Lite-0.712.0
		dev-perl/JSON-RPC
		>=dev-perl/JSON-XS-2.0.0
		dev-perl/Test-Taint
		>=dev-perl/HTML-Parser-3.670.0
		dev-perl/HTML-Scrubber
		>=virtual/perl-Encode-2.210.0
		dev-perl/Encode-Detect
		dev-perl/Email-MIME-Attachment-Stripper
		dev-perl/Email-Reply
		dev-perl/TheSchwartz
		dev-perl/Daemon-Generic
		dev-perl/File-MimeInfo
		virtual/imagemagick-tools[perl]
		dev-perl/MIME-tools
	)
	modperl? (
		www-apache/mod_perl:1
		>=dev-perl/Apache-SizeLimit-0.960.0
	)
	graphviz? ( media-gfx/graphviz )
"
want_apache modperl
need_httpd_cgi

PATCHES=(
	"${FILESDIR}/${PN}"-5.0.3-leftbrace.patch
)

pkg_setup() {
	depend.apache_pkg_setup modperl
	webapp_pkg_setup
}

src_prepare() {
	# Get a rid of the bzr files
	rm -r .bzr* || die

	# Remove bundled perl modules
	rm -r lib/ || die

	default
}

src_test() {
	perl -I. runtests.pl || die
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
	for f in "${D}${MY_HTDOCSDIR}"/*.cgi ; do
	        fperms +x "${f#${D}}"
	done

	fperms u+x "${MY_HTDOCSDIR}"/jobqueue.pl

	# configuration must be executable
	fperms u+x "${MY_HTDOCSDIR}"/checksetup.pl

	# bug 487476
	mkdir "${D}${MY_HTDOCSDIR}"/lib || die
}
