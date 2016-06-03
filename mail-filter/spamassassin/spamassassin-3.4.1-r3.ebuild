# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module toolchain-funcs eutils systemd readme.gentoo

MY_P=Mail-SpamAssassin-${PV//_/-}
S=${WORKDIR}/${MY_P}
DESCRIPTION="An extensible mail filter which can identify and tag spam"
HOMEPAGE="http://spamassassin.apache.org/"
SRC_URI="mirror://apache/spamassassin/source/${MY_P}.tar.bz2"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="+bayes berkdb libressl qmail ssl doc ldap mysql postgres sqlite ipv6"

# You can do without a database unless you need the Bayes features.
REQUIRED_USE="bayes? ( || ( berkdb mysql postgres sqlite ) )"

DEPEND=">=dev-lang/perl-5.8.8-r8
	virtual/perl-MIME-Base64
	>=virtual/perl-Pod-Parser-1.510.0-r2
	virtual/perl-Storable
	virtual/perl-Time-HiRes
	>=dev-perl/HTML-Parser-3.43
	>=dev-perl/Mail-DKIM-0.37
	>=dev-perl/Net-DNS-0.53
	dev-perl/Digest-SHA1
	dev-perl/libwww-perl
	>=virtual/perl-Archive-Tar-1.23
	app-crypt/gnupg
	>=virtual/perl-IO-Zlib-1.04
	>=dev-util/re2c-0.12.0
	dev-perl/Mail-SPF
	>=dev-perl/NetAddr-IP-4.0.1
	dev-perl/Geo-IP
	dev-perl/Encode-Detect
	dev-perl/Net-Patricia
	ssl? (
		dev-perl/IO-Socket-SSL
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	berkdb? (
		virtual/perl-DB_File
	)
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
	ipv6? (
		|| ( dev-perl/IO-Socket-INET6
			virtual/perl-IO-Socket-IP )
	)"
RDEPEND="${DEPEND}"

SRC_TEST="do"

src_prepare() {
	epatch "${FILESDIR}/spamassassin-3.4.1-bug_7223.patch"
	epatch "${FILESDIR}/spamassassin-3.4.1-bug_7231.patch"
	epatch "${FILESDIR}/spamassassin-3.4.1-bug_7265.patch"
	perl-module_src_prepare
}

src_configure() {
	# - Set SYSCONFDIR explicitly so we can't get bitten by bug 48205 again
	#	(just to be sure, nobody knows how it could happen in the first place).
	myconf="SYSCONFDIR=${EPREFIX}/etc"
	myconf+=" DATADIR=${EPREFIX}/usr/share/spamassassin"

	# If ssl is enabled, spamc can be built with ssl support.
	if use ssl; then
		myconf+=" ENABLE_SSL=yes"
	else
		myconf+=" ENABLE_SSL=no"
	fi

	# Set the path to the Perl executable explictly.  This will be used to
	# create the initial sharpbang line in the scripts and might cause
	# a versioned app name end in there, see
	# <https://bugs.gentoo.org/show_bug.cgi?id=62276>
	myconf+=" PERL_BIN=${EPREFIX}/usr/bin/perl"

	# Setting the following env var ensures that no questions are asked.
	perl-module_src_configure
	# Configure spamc
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" spamc/Makefile
}

src_compile() {
	export PERL_MM_USE_DEFAULT=1

	# Now compile all the stuff selected.
	perl-module_src_compile

	if use qmail; then
		emake spamc/qmail-spamc
	fi
}

src_install () {
	perl-module_src_install

	# Create the stub dir used by sa-update and friends
	keepdir /var/lib/spamassassin

	# Move spamd to sbin where it belongs.
	dodir /usr/sbin
	mv "${ED}"/usr/bin/spamd "${ED}"/usr/sbin/spamd  || die "move spamd failed"

	if use qmail; then
		dobin spamc/qmail-spamc
	fi

	ln -s mail/spamassassin "${ED}"/etc/spamassassin || die

	# Disable plugin by default
	sed -i -e 's/^loadplugin/\#loadplugin/g' \
		"${ED}"/etc/mail/spamassassin/init.pre \
		|| die "failed to disable plugins by default"

	# Add the init and config scripts.
	newinitd "${FILESDIR}"/3.3.1-spamd.init spamd
	newconfd "${FILESDIR}"/3.0.0-spamd.conf spamd

	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf

	if use postgres; then
		sed -i -e 's:@USEPOSTGRES@::' "${ED}/etc/init.d/spamd" || die

		dodoc sql/*_pg.sql
	else
		sed -i -e '/@USEPOSTGRES@/d' "${ED}/etc/init.d/spamd" || die
	fi

	if use mysql; then
		sed -i -e 's:@USEMYSQL@::' "${ED}/etc/init.d/spamd" || die

		dodoc sql/*_mysql.sql
	else
		sed -i -e '/@USEMYSQL@/d' "${ED}/etc/init.d/spamd" || die
	fi

	dodoc NOTICE TRADEMARK CREDITS INSTALL.VMS UPGRADE USAGE \
		sql/README.bayes sql/README.awl procmailrc.example sample-nonspam.txt \
		sample-spam.txt spamd/PROTOCOL spamd/README.vpopmail \
		spamd-apache2/README.apache

	# Rename some docu files so they don't clash with others
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

	cat <<-EOF > "${T}/local.cf.example"
		# Sensitive data, such as database connection info, should be stored in
		# /etc/mail/spamassassin/secrets.cf with appropriate permissions
EOF

	insopts -m0644
	doins "${T}/local.cf.example"
}

pkg_postinst() {
	elog "If you plan on using the -u flag to spamd, please read the notes"
	elog "in /etc/conf.d/spamd regarding the location of the pid file."
	elog
	elog "If you build ${PN} with optional dependancy support,"
	elog "you can enable them in /etc/mail/spamassassin/init.pre"
	elog
	elog "You need to configure your database to be able to use Bayes filter"
	elog "with database backend, otherwise it will still use (and need) the"
	elog "Berkeley DB support."
	elog "Look at the sql/README.bayes file in the documentation directory"
	elog "for how to configure it."
	elog
	elog "If you plan to use Vipul's Razor, note that versions up to and"
	elog "including version 2.82 include a bug that will slow down the entire"
	elog "perl interpreter.  Version 2.83 or later fixes this."
	elog "If you do not plan to use this plugin, be sure to comment out"
	elog "its loadplugin line in /etc/mail/spamassassin/v310.pre."
	elog
	elog "The DKIM plugin is now enabled by default for new installs,"
	elog "if the perl module Mail::DKIM is installed."
	elog "However, installation of SpamAssassin will not overwrite existing"
	elog ".pre configuration files, so to use DKIM when upgrading from a"
	elog "previous release that did not use DKIM, a directive:"
	elog
	elog "loadplugin Mail::SpamAssassin::Plugin::DKIM"
	elog "will need to be uncommented in file 'v312.pre', or added"
	elog "to some other .pre file, such as local.pre."
	elog
	ewarn "Rules are no longer included with SpamAssassin out of the box".
	ewarn "You will need to immediately run sa-update, or download"
	ewarn "the additional rules .tgz package and run sa-update --install"
	ewarn "with it, to get a ruleset."
	elog
	elog "If you run sa-update and receive a GPG validation error."
	elog "Then you need to import an updated sa-update key."
	elog "sa-update --import /usr/share/spamassassin/sa-update-pubkey.txt"
	elog
}
