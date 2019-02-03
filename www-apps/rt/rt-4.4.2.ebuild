# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit webapp eutils depend.apache user

DESCRIPTION="RT is an enterprise-grade ticketing system"
HOMEPAGE="http://www.bestpractical.com/rt/"
SRC_URI="http://download.bestpractical.com/pub/${PN}/release/${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2"
IUSE="mysql +postgres fastcgi lighttpd"
REQUIRED_USE="^^ ( mysql postgres )"

RESTRICT="test"

DEPEND="
	>=dev-lang/perl-5.10.1

	>=dev-perl/Apache-Session-1.53
	>=dev-perl/CGI-4
	>=dev-perl/CSS-Squish-0.06
	>=dev-perl/Class-Accessor-0.34
	>=dev-perl/Class-ReturnValue-0.550.0-r1
	>=dev-perl/DBI-1.37
	>=dev-perl/Date-Extract-0.02
	>=dev-perl/DateTime-Format-Natural-0.67
	>=dev-perl/Devel-StackTrace-1.19
	>=dev-perl/Email-Address-1.908.0
	>=dev-perl/HTML-FormatText-WithLinks-0.14
	>=dev-perl/HTML-Mason-1.43
	>=dev-perl/HTML-Scrubber-0.08
	>=dev-perl/HTTP-Server-Simple-0.34
	>=dev-perl/HTTP-Server-Simple-Mason-0.14
	>=dev-perl/Locale-Maketext-Lexicon-0.32
	>=dev-perl/Log-Dispatch-2.410.0
	>=dev-perl/MIME-tools-5.425
	>=dev-perl/MailTools-1.60
	>=dev-perl/Module-Versions-Report-1.05
	>=dev-perl/Role-Basic-0.12
	>=dev-perl/Symbol-Global-Name-0.04
	>=dev-perl/Text-Quoted-2.80.0
	>=dev-perl/Text-WikiFormat-0.76
	>=dev-perl/Tree-Simple-1.04
	>=dev-perl/XML-RSS-1.05
	>=dev-perl/DBIx-SearchBuilder-1.660.0
	>=virtual/perl-Digest-MD5-2.27
	>=virtual/perl-Encode-2.730.0
	>=virtual/perl-File-Spec-0.8
	>=virtual/perl-Getopt-Long-2.24
	>=virtual/perl-Locale-Maketext-1.06
	>=virtual/perl-Storable-2.08
	dev-perl/Business-Hours
	dev-perl/CGI-Emulate-PSGI
	dev-perl/CGI-PSGI
	dev-perl/Cache-Simple-TimedExpiry
	dev-perl/Calendar-Simple
	dev-perl/Convert-Color
	dev-perl/Crypt-Eksblowfish
	dev-perl/Crypt-SSLeay
	dev-perl/Crypt-X509
	dev-perl/CSS-Minifier-XS
	dev-perl/Data-Page-Pageset
	dev-perl/DBD-SQLite
	dev-perl/Data-GUID
	dev-perl/Data-ICal
	dev-perl/Date-Manip
	dev-perl/Devel-GlobalDestruction
	dev-perl/Email-Address-List
	dev-perl/File-ShareDir
	dev-perl/File-Which
	dev-perl/GDGraph
	dev-perl/GDTextUtil
	dev-perl/GD[png,gif]
	dev-perl/GnuPG-Interface
	dev-perl/GraphViz
	dev-perl/HTML-Formatter
	dev-perl/HTML-FormatText-WithLinks-AndTables
	dev-perl/HTML-Mason-PSGIHandler
	dev-perl/HTML-Parser
	dev-perl/HTML-Quoted
	dev-perl/HTML-RewriteAttributes
	dev-perl/HTML-Tree
	dev-perl/IPC-Run3
	dev-perl/JSON
	dev-perl/JavaScript-Minifier-XS
	dev-perl/MIME-Types
	dev-perl/Module-Refresh
	dev-perl/Mozilla-CA
	dev-perl/Net-CIDR
	dev-perl/PerlIO-eol
	dev-perl/Plack
	dev-perl/Regexp-Common-net-CIDR
	dev-perl/Regexp-IPv6
	dev-perl/Scope-Upper
	dev-perl/Starlet
	dev-perl/String-ShellQuote
	dev-perl/TermReadKey
	dev-perl/Text-Autoformat
	dev-perl/Text-Password-Pronounceable
	dev-perl/Time-ParseDate
	dev-perl/TimeDate
	dev-perl/UNIVERSAL-require
	dev-perl/libwww-perl
	dev-perl/Locale-Maketext-Fuzzy
	dev-perl/Net-IP
	dev-perl/Net-Server
	dev-perl/Regexp-Common
	dev-perl/Text-Template
	dev-perl/Text-Wrapper
	virtual/perl-Digest
	virtual/perl-File-Temp
	virtual/perl-Scalar-List-Utils
	virtual/perl-Time-HiRes
	virtual/perl-libnet

	fastcgi? (
		dev-perl/FCGI
		dev-perl/FCGI-ProcManager
	)
	!lighttpd? (
		dev-perl/Apache-DBI
		!fastcgi? ( >=www-apache/mod_perl-2 )
	)
	lighttpd? ( dev-perl/FCGI )
	mysql? ( >=dev-perl/DBD-mysql-2.1018 )
	postgres? ( >=dev-perl/DBD-Pg-1.43 )
"

RDEPEND="${DEPEND}
	virtual/mta
	!lighttpd? ( ${APACHE2_DEPEND} )
	lighttpd? (
		>=www-servers/lighttpd-1.3.13
		sys-apps/openrc
	)
"

need_httpd_cgi

add_user_rt() {
	# add new user
	# suexec2 requires uid >= 1000; enewuser is of no help here
	# From: Mike Frysinger <vapier@gentoo.org>
	# Date: Fri, 17 Jun 2005 08:41:44 -0400
	# i'd pick a 5 digit # if i were you

	local euser="rt"

	# first check if username rt exists
	if [[ ${euser} == $(egetent passwd "${euser}" | cut -d: -f1) ]] ; then
		# check uid
		rt_uid=$(egetent passwd "${euser}" | cut -d: -f3)
		if $(expr ${rt_uid} '<' 1000 > /dev/null); then
			ewarn "uid of user rt is less than 1000. suexec2 will not work."
			ewarn "If you want to use FastCGI, please delete the user 'rt'"
			ewarn "from your system and re-emerge www-apps/rt"
		fi
		return 0 # all is well
	fi

	# add user
	# stolen from enewuser
	local pwrange euid

	pwrange=$(seq 10001 11001)
	for euid in ${pwrange} ; do
		[[ -z $(egetent passwd ${euid}) ]] && break
	done
	if [[ ${euid} == "11001" ]]; then
		# she gets around, doesn't she?
		die "No available uid's found"
	fi

	elog " - Userid: ${euid}"

	enewuser rt ${euid} -1 /dev/null rt
	return 0
}

pkg_setup() {
	webapp_pkg_setup

	ewarn
	ewarn "If you are upgrading from an existing RT installation"
	ewarn "make sure to read the related upgrade documentation in"
	ewarn "${ROOT}usr/share/doc/${PF}."
	ewarn

	enewgroup rt
	add_user_rt || die "Could not add user"
}

src_prepare() {
	# add Gentoo-specific layout
	cat "${FILESDIR}"/config.layout-gentoo >> config.layout
	sed -e "s|PREFIX|${ED}/${MY_HOSTROOTDIR}/${PF}|g" \
		-e "s|HTMLDIR|${ED}/${MY_HTDOCSDIR}|g" \
		-e 's|/\+|/|g' \
		-i ./config.layout || die 'config sed failed'

	# don't need to check dev dependencies
	sed -e "s|\$args{'with-DEV'} =1;|#\$args{'with-DEV'} =1;|" \
		-i sbin/rt-test-dependencies.in || die 'dev sed failed'

	epatch "${FILESDIR}/rt-makefile-serialize-install-prereqs.patch"
}

src_configure() {
	local web
	local myconf
	local depsconf

	if use mysql ; then
		myconf="--with-db-type=mysql --with-db-dba=root"
		depsconf="--with-MYSQL"
	elif use postgres ; then
		myconf="--with-db-type=Pg --with-db-dba=postgres"
		depsconf="--with-PG"
	else
		die "Pick a database backend"
	fi

	if use fastcgi ; then
		myconf+=" --with-web-handler=fastcgi"
		web="apache"
		depsconf+=" --with-FASTCGI"
	elif use lighttpd ; then
		myconf+=" --with-web-handler=fastcgi"
		web="lighttpd"
		depsconf+=" --with-FASTCGI"
	else
		myconf+=" --with-web-handler=modperl2"
		web="apache"
		depsconf+=" --with-MODPERL2"
	fi
	# Any loading Date::Manip from here on
	# may fail if TZ=Factory as it is on gentoo install
	# media ( affects install as well )
	export TZ=UTC

	./configure --enable-layout=Gentoo \
		--with-bin-owner=rt \
		--with-libs-owner=rt \
		--with-libs-group=rt \
		--with-rt-group=rt \
		--with-web-user=${web} \
		--with-web-group=${web} \
		${myconf}

	# check for missing deps and ask to report if something is broken
	/usr/bin/perl ./sbin/rt-test-dependencies ${depsconf} > "${T}"/t
	if grep -q "MISSING" "${T}"/t; then
		ewarn "Missing Perl dependency!"
		ewarn
		cat "${T}"/t | grep MISSING
		ewarn
		ewarn "Please run perl-cleaner. If the problem persists,"
		ewarn "please file a bug in the Gentoo Bugzilla with the information above"
		die "Missing dependencies."
	fi
}

src_compile() { :; }

src_install() {
	webapp_src_preinst
	emake install

	dodoc -r docs/*
	# Disable compression because `perldoc` doesn't decompress transparently
	docompress -x /usr/share/doc

	# make sure we don't clobber existing site configuration
	rm -f "${ED}"/${MY_HOSTROOTDIR}/${PF}/etc/RT_SiteConfig.pm

	# fix paths
	find "${ED}" -type f -print0 | xargs -0 sed -i -e "s:${ED}::g"

	# copy upgrade files
	insinto "${MY_HOSTROOTDIR}/${PF}"
	doins -r etc/upgrade

	# require the web server's permissions
	webapp_serverowned "${MY_HOSTROOTDIR}"/${PF}/var
	webapp_serverowned "${MY_HOSTROOTDIR}"/${PF}/var/mason_data/obj

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_hook_script "${FILESDIR}"/reconfig

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	if use lighttpd ; then
		elog "We no longer install initscripts as Best Practical's recommended"
		elog "implementation is to let Lighttpd manage the FastCGI instance."
		elog
		elog "You may find the following helpful:"
		elog "   perldoc /usr/share/doc/${P}/web_deployment.pod"
	fi
}
