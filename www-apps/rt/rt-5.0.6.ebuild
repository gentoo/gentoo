# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp depend.apache

DESCRIPTION="RT is an enterprise-grade ticketing system"
HOMEPAGE="https://bestpractical.com/rt/"
SRC_URI="https://download.bestpractical.com/pub/${PN}/release/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="mysql +postgres fastcgi lighttpd nginx +apache"
REQUIRED_USE="^^ ( mysql postgres ) ^^ ( lighttpd nginx apache )"

RESTRICT="test"

DEPEND="
	acct-group/rt
	acct-user/rt
	>=dev-lang/perl-5.10.1
	>=dev-perl/Apache-Session-1.53
	>=dev-perl/CGI-4
	>=dev-perl/CSS-Squish-0.06
	>=dev-perl/DBIx-SearchBuilder-1.800.0
	>=dev-perl/Date-Extract-0.07
	>=dev-perl/DateTime-Format-Natural-0.67
	>=dev-perl/Email-Address-1.912.0
	>=dev-perl/Email-Address-List-0.60.0
	>=dev-perl/Locale-Maketext-Lexicon-0.32
	>=dev-perl/MIME-tools-5.425
	>=dev-perl/Module-Versions-Report-1.05
	>=dev-perl/Role-Basic-0.12
	>=dev-perl/Symbol-Global-Name-0.05
	>=dev-perl/Text-Quoted-2.80.0
	>=dev-perl/Text-WikiFormat-0.76
	>=dev-perl/Tree-Simple-1.04
	>=dev-perl/XML-RSS-1.05
	>=virtual/perl-Locale-Maketext-1.06
	dev-perl/Business-Hours
	dev-perl/CGI-Emulate-PSGI
	dev-perl/CGI-PSGI
	dev-perl/CSS-Minifier-XS
	dev-perl/Class-Accessor
	dev-perl/Convert-Color
	dev-perl/Crypt-Eksblowfish
	dev-perl/Crypt-X509
	dev-perl/Data-GUID
	dev-perl/Data-ICal
	dev-perl/Data-Page
	dev-perl/Date-Manip
	dev-perl/Encode-Detect
	dev-perl/Encode-HanExtra
	dev-perl/File-ShareDir
	dev-perl/GnuPG-Interface
	dev-perl/HTML-FormatExternal
	dev-perl/HTML-FormatText-WithLinks
	dev-perl/HTML-FormatText-WithLinks-AndTables
	dev-perl/HTML-Gumbo
	dev-perl/HTML-Mason
	dev-perl/HTML-Mason-PSGIHandler
	dev-perl/HTML-Parser
	dev-perl/HTML-Quoted
	dev-perl/HTML-RewriteAttributes
	dev-perl/HTML-Scrubber
	dev-perl/HTTP-Message
	dev-perl/IPC-Run3
	dev-perl/JSON
	dev-perl/JavaScript-Minifier-XS
	dev-perl/List-MoreUtils
	dev-perl/Locale-Maketext-Fuzzy
	dev-perl/libwww-perl
	dev-perl/MIME-Types
	dev-perl/Module-Path
	dev-perl/Module-Refresh
	dev-perl/Moose
	dev-perl/MooseX-NonMoose
	dev-perl/MooseX-Role-Parameterized
	dev-perl/Net-CIDR
	dev-perl/Net-IP
	dev-perl/Parallel-ForkManager
	dev-perl/Path-Dispatcher
	dev-perl/PerlIO-eol
	dev-perl/Plack
	dev-perl/Regexp-Common
	dev-perl/Regexp-Common-net-CIDR
	dev-perl/Regexp-IPv6
	dev-perl/Scope-Upper
	dev-perl/Starlet
	dev-perl/String-ShellQuote
	dev-perl/Text-Password-Pronounceable
	dev-perl/Text-Template
	dev-perl/Text-WordDiff
	dev-perl/Text-Wrapper
	dev-perl/Time-ParseDate
	dev-perl/Web-Machine

	fastcgi? (
		dev-perl/FCGI
		dev-perl/FCGI-ProcManager
	)
	apache? (
		dev-perl/Apache-DBI
		!fastcgi? ( >=www-apache/mod_perl-2 )
	)
	lighttpd? ( dev-perl/FCGI )
	nginx? (
		dev-perl/FCGI
	)
	mysql? ( >=dev-perl/DBD-mysql-2.1018 )
	postgres? ( >=dev-perl/DBD-Pg-1.43 )
"

RDEPEND="${DEPEND}
	virtual/mta
	apache? ( ${APACHE2_DEPEND} )
	lighttpd? (
		>=www-servers/lighttpd-1.3.13
		sys-apps/openrc
	)
	nginx? (
		www-servers/nginx
		sys-apps/openrc
		www-servers/spawn-fcgi
	)
"

need_httpd_cgi

pkg_setup() {
	webapp_pkg_setup

	ewarn
	ewarn "If you are upgrading from an existing RT installation"
	ewarn "make sure to read the related upgrade documentation in"
	ewarn "${ROOT}/usr/share/doc/${PF}."
	ewarn
}

src_prepare() {
	# add Gentoo-specific layout
	cat "${FILESDIR}"/config.layout-gentoo >> config.layout
	sed -e "s|PREFIX|${EPREFIX}/${MY_HOSTROOTDIR}/${PF}|g" \
		-e "s|HTMLDIR|${EPREFIX}/${MY_HTDOCSDIR}|g" \
		-e 's|/\+|/|g' \
		-i ./config.layout || die 'config sed failed'

	# don't need to check dev dependencies
	sed -e "s|\$args{'with-DEV'} =1;|#\$args{'with-DEV'} =1;|" \
		-i sbin/rt-test-dependencies.in || die 'dev sed failed'

	eapply "${FILESDIR}/rt-makefile-serialize-install-prereqs.patch"
	eapply_user
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

	if use apache ; then
		web="apache"
		if use fastcgi ; then
			myconf+=" --with-web-handler=fastcgi"
			depsconf+=" --with-FASTCGI"
		else
			myconf+=" --with-web-handler=modperl2"
			depsconf+=" --with-MODPERL2"
		fi
	elif use lighttpd ; then
		web="lighttpd"
		myconf+=" --with-web-handler=fastcgi"
		depsconf+=" --with-FASTCGI"
	elif use nginx ; then
		myconf+=" --with-web-handler=fastcgi"
		depsconf+=" --with-FASTCGI"
		web="nginx"
	else
		die "Pick a webserver"
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
	emake DESTDIR="${D}" install

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
