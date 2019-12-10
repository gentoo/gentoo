# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-functions systemd toolchain-funcs user

MY_P="Mail-SpamAssassin-${PV//_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="An extensible mail filter which can identify and tag spam"
HOMEPAGE="https://spamassassin.apache.org/"
SRC_URI="mirror://apache/spamassassin/source/${MY_P}.tar.bz2"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="berkdb cron ipv6 ldap libressl mysql postgres qmail sqlite ssl test"
RESTRICT="!test? ( test )"

# The Makefile.PL script checks for dependencies, but only fails if a
# required (i.e. not optional) dependency is missing. We therefore
# require most of the optional modules only at runtime.
REQDEPEND="dev-lang/perl:=
	dev-perl/HTML-Parser
	dev-perl/Net-DNS
	dev-perl/NetAddr-IP
	virtual/perl-Archive-Tar
	virtual/perl-Digest-SHA
	virtual/perl-IO-Zlib
	virtual/perl-Time-HiRes
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl )
	)"

# SpamAssassin doesn't use libwww-perl except as a fallback for when
# curl/wget are missing, so we depend on one of those instead. Some
# mirrors use https, so we need those utilities to support SSL.
#
# re2c is needed to compile the rules (sa-compile).
#
# We still need the old Digest-SHA1 because razor2 has not been ported
# to Digest-SHA.
OPTDEPEND="app-crypt/gnupg
	dev-perl/Digest-SHA1
	dev-perl/Encode-Detect
	dev-perl/Geo-IP
	dev-perl/HTTP-Date
	dev-perl/Mail-DKIM
	dev-perl/Mail-SPF
	dev-perl/Net-Patricia
	dev-perl/Net-CIDR-Lite
	dev-util/re2c
	|| ( net-misc/wget[ssl] net-misc/curl[ssl] )
	virtual/perl-MIME-Base64
	virtual/perl-Pod-Parser
	berkdb? ( virtual/perl-DB_File )
	ipv6? ( dev-perl/IO-Socket-INET6 )
	ldap? ( dev-perl/perl-ldap )
	mysql? (
		dev-perl/DBI
		dev-perl/DBD-mysql
	)
	postgres? (
		dev-perl/DBI
		dev-perl/DBD-Pg
	)
	sqlite? (
		dev-perl/DBI
		dev-perl/DBD-SQLite
	)
	ssl? ( dev-perl/IO-Socket-SSL )"

DEPEND="${REQDEPEND}
	test? (
		${OPTDEPEND}
		virtual/perl-Test-Harness
	)"
RDEPEND="${REQDEPEND} ${OPTDEPEND}"

PATCHES=( "${FILESDIR}/spamassassin-3.4.2-bug_7632.patch" )

src_prepare() {
	default

	# The sa_compile test does some weird stuff like hopping around in
	# the directory tree and calling "make" to create a dist tarball
	# from ${S}. It fails, and is more trouble than it's worth...
	perl_rm_files t/sa_compile.t || die 'failed to remove sa_compile test'

	# The spamc tests (which need the networked spamd daemon) fail for
	# irrelevant reasons. It's too hard to disable them (unlike the
	# spamd tests themselves -- see src_test), so use a crude
	# workaround.
	perl_rm_files t/spamc_*.t || die 'failed to remove spamc tests'

	# Upstream bug 7622: this thing needs network access but doesn't
	# respect the 'run_net_tests' setting.
	perl_rm_files t/urilocalbl_geoip.t \
		|| die 'failed to remove urilocalbl_geoip tests'
}

src_configure() {
	# This is how and where the perl-module eclass disables the
	# MakeMaker interactive prompt.
	export PERL_MM_USE_DEFAULT=1

	# Set SYSCONFDIR explicitly so we can't get bitten by bug 48205 again
	# (just to be sure, nobody knows how it could happen in the first place).
	#
	# We also set the path to the perl executable explictly. This will be
	# used to create the initial shebang line in the scripts (bug 62276).
	perl Makefile.PL \
		PREFIX="${EPREFIX}/usr" \
		INSTALLDIRS=vendor \
		SYSCONFDIR="${EPREFIX}/etc" \
		DATADIR="${EPREFIX}/usr/share/spamassassin" \
		PERL_BIN="${EPREFIX}/usr/bin/perl" \
		ENABLE_SSL="$(usex ssl)" \
		DESTDIR="${D}" \
		|| die 'failed to create a Makefile using Makefile.PL'

	# Now configure spamc.
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" spamc/Makefile
}

src_compile() {
	emake
	use qmail && emake spamc/qmail-spamc
}

src_install () {
	emake install
	einstalldocs

	# Create the stub dir used by sa-update and friends
	keepdir /var/lib/spamassassin

	# Move spamd to sbin where it belongs.
	dodir /usr/sbin
	mv "${ED}"/usr/bin/spamd "${ED}"/usr/sbin/spamd  || die "move spamd failed"

	if use qmail; then
		dobin spamc/qmail-spamc
	fi

	dosym mail/spamassassin /etc/spamassassin

	# Disable plugin by default
	sed -i -e 's/^loadplugin/\#loadplugin/g' \
		"${ED}/etc/mail/spamassassin/init.pre" \
		|| die "failed to disable plugins by default"

	# Add the init and config scripts.
	newinitd "${FILESDIR}/3.4.1-spamd.init-r3" spamd
	newconfd "${FILESDIR}/3.4.1-spamd.conf-r1" spamd

	systemd_newunit "${FILESDIR}/${PN}.service-r4" "${PN}.service"
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf-r2" \
							 "${PN}.service"

	use postgres && dodoc sql/*_pg.sql
	use mysql && dodoc sql/*_mysql.sql

	dodoc NOTICE TRADEMARK CREDITS UPGRADE USAGE sql/README.bayes \
		sql/README.awl procmailrc.example sample-nonspam.txt \
		sample-spam.txt spamd/PROTOCOL spamd/README.vpopmail \
		spamd-apache2/README.apache

	# Rename some files so that they don't clash with others.
	newdoc spamd/README README.spamd
	newdoc sql/README README.sql
	newdoc ldap/README README.ldap

	if use qmail; then
		dodoc spamc/README.qmail
	fi

	insinto /etc/mail/spamassassin/
	insopts -m0400
	newins "${FILESDIR}"/secrets.cf secrets.cf.example

	# Create the directory where sa-update stores its GPG key (if you
	# choose to import one). If this directory does not exist, the
	# import will fail. This is bug 396307. We expect that the import
	# will be performed as root, and making the directory accessible
	# only to root prevents a warning on the command-line.
	diropts -m0700
	dodir /etc/mail/spamassassin/sa-update-keys

	if use cron; then
		# Install the cron job if they want it.
		exeinto /etc/cron.daily
		newexe "${FILESDIR}/update-spamassassin-rules.cron" \
			   update-spamassassin-rules
	fi

	# Remove perllocal.pod to avoid file collisions (bug #603338).
	perl_delete_localpod || die "failed to remove perllocal.pod"

	# The perl-module eclass calls three other functions to clean
	# up in src_install. The first fixes references to ${D} in the
	# packlist, and is useful to us, too. The other two functions,
	# perl_delete_emptybsdir and perl_remove_temppath, don't seem
	# to be needed: there are no empty directories, *.bs files, or
	# ${D} paths remaining in our installed image.
	perl_fix_packlist || die "failed to fix paths in packlist"
}

src_test() {
	# Trick the test suite into skipping the spamd tests. Setting
	# SPAMD_HOST to a non-localhost value causes SKIP_SPAMD_TESTS to be
	# set in SATest.pm.
	export SPAMD_HOST=disabled
	default
}

pkg_preinst() {
	# The spamd daemon runs as this user. Use a real home directory so
	# that it can hold SA configuration.
	enewuser spamd -1 -1 /home/spamd
}

pkg_postinst() {
	elog
	elog 'No rules are installed by default. You will need to run sa-update'
	elog 'at least once, and most likely configure SpamAssassin before it'
	elog 'will work.'

	if ! use cron; then
		elog
		elog 'You should consider a cron job for sa-update. One is provided'
		elog 'for daily updates if you enable the "cron" USE flag.'
	fi
	elog
	elog 'Configuration and update help can be found on the wiki:'
	elog
	elog '  https://wiki.gentoo.org/wiki/SpamAssassin'
	elog

	ewarn 'If this version of SpamAssassin causes permissions issues'
	ewarn 'with your user configurations or bayes databases, then you'
	ewarn 'may need to set SPAMD_RUN_AS_ROOT=true in your OpenRC service'
	ewarn 'configuration file, or remove the --username and --groupname'
	ewarn 'flags from the SPAMD_OPTS variable in your systemd service'
	ewarn 'configuration file.'
}
