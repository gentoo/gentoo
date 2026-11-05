# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature webapp

DESCRIPTION="Bugzilla is the Bug-Tracking System from the Mozilla project"
HOMEPAGE="https://www.bugzilla.org"
SRC_URI="https://ftp.mozilla.org/pub/webtools/${PN}/$(ver_cut 1-2)-branch/${P}.tar.gz"

LICENSE="MPL-2.0"
KEYWORDS="~amd64"

IUSE="apache2 doc mysql postgres selinux +sqlite test"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( mysql postgres sqlite )"

# sorting is identical to upstream MYMETA.json, please don't change
# These are mandatory for checksetup.pl to configure bugzilla
BASIC_DEPS="
	dev-lang/perl
	>=dev-perl/CGI-3.510.0
	>=dev-perl/DBI-1.614.0
	>=dev-perl/DBIx-Connector-0.560.0
	>=dev-perl/TimeDate-2.230.0
	>=dev-perl/DateTime-0.750.0
	>=dev-perl/DateTime-TimeZone-1.640.0
	virtual/perl-Digest-SHA
	>=dev-perl/Email-Address-XS-1.50.0
	>=dev-perl/Email-Sender-2.600.0
	>=dev-perl/Email-MIME-1.904.0
	>=dev-perl/JSON-XS-2.10.0
	>=dev-perl/List-MoreUtils-0.320.0
	>=dev-perl/Math-Random-ISAAC-1.0.1
	>=dev-perl/Moo-2.3.4
	>=dev-perl/Template-Toolkit-3.8.0
	>=dev-perl/URI-1.550.0
"

RDEPEND="
	${BASIC_DEPS}
	apache2? ( www-servers/apache[apache2_modules_access_compat] )
	!apache2? ( virtual/httpd-cgi )
	postgres? ( >=dev-perl/DBD-Pg-1.49 )
	mysql? ( >=dev-perl/DBD-mysql-4.32.0 )
	selinux? ( sec-policy/selinux-bugzilla )
	sqlite? ( >=dev-perl/DBD-SQLite-1.290.0 )
"

BDEPEND="
	test? ( ${BASIC_DEPS} )
	doc? (
		dev-python/sphinx
		dev-perl/File-Copy-Recursive
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.2-sqlite-extends.patch"
)

src_prepare() {
	default

	# Get rid of the bzr and miscelaneous files
	rm -r .bzr* || die
	rm -r .git .github docker Dockerfile* docker-compose.yml || die

	# unconditionnally remove pod-coverage tests
	rm t/011pod.t || die
}

src_test() {
	TZ=UTC perl -I. runtests.pl || die
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_postinst_txt en "${FILESDIR}/postinstall-${PV}-en.txt"
	webapp_postupgrade_txt en "${FILESDIR}/postupgrade-${PV}-en.txt"
	webapp_src_install

	if use doc; then
		docs/makedocs.pl
		dodoc -r docs/en/html
		dodoc -r docs/en/txt
	fi

	# openrc service file to enable mail queuing as a service
	newinitd "${FILESDIR}"/bugzilla-queue.initd bugzilla-queue

	# must be executable and stay that way upon upgrading
	fperms u+x "${MY_HTDOCSDIR}"/checksetup.pl
}

pkg_postinst() {
	optfeature "graphical reports, new charts, old charts" \
		"dev-perl/GD dev-perl/Chart dev-perl/Template-GD dev-perl/GDTextUtil dev-perl/GDGraph"
	optfeature "moving bugs between installations, automatic update notifications" \
		"dev-perl/MIME-tools dev-perl/libwww-perl dev-perl/XML-Twig"
	optfeature "patch viewer" "dev-perl/PatchReader"
	optfeature "LDAP authentication" "dev-perl/perl-ldap"
	optfeature "SMTP authentication" "dev-perl/Authen-SASL"
	optfeature "XML-RPC Interface" "dev-perl/SOAP-Lite dev-perl/XMLRPC-Lite dev-perl/Test-Taint"
	optfeature "JSON-RPC interface, REST interface" "dev-perl/JSON-RPC dev-perl/Test-Taint"
	optfeature "more HTML in Product/Group description" "dev-perl/HTML-Scrubber"
	optfeature "automatic charset detection for text attachments" "dev-perl/Encode-Detect"
	optfeature "inbound email" "dev-perl/Email-Reply dev-perl/HTML-FormatText-WithLinks"
	optfeature "mail queueing" "dev-perl/TheSchwartz dev-perl/Daemon-Generic"
	optfeature "MIME type sniffing of attachments" "dev-perl/File-MimeInfo dev-perl/IO-stringy"
	optfeature "Memcached support" "dev-perl/Cache-Memcached"
	optfeature "SSL support for SMTP" "dev-perl/IO-Socket-SSL"

	ewarn "If Apache is the chosen webserver, please consider turning the apache2 use flag on"
	ewarn "Not doing so may result in unexpected runtime errors"

	webapp_pkg_postinst
}
