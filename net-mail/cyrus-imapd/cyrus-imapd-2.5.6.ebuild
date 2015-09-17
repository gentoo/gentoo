# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils multilib pam ssl-cert user toolchain-funcs

MY_P=${P/_/}

DESCRIPTION="The Cyrus IMAP Server"
HOMEPAGE="http://www.cyrusimap.org/"
SRC_URI="ftp://ftp.cyrusimap.org/cyrus-imapd/${MY_P}.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="afs berkdb clamav http kerberos mysql nntp pam perl postgres \
	replication +server sieve snmp sqlite ssl static-libs tcpd"

# virtual/mysql-5.5 added for the --variable= option below
DEPEND="sys-libs/zlib
	dev-libs/libpcre
	>=dev-libs/cyrus-sasl-2.1.13
	dev-libs/jansson
	afs? ( net-fs/openafs )
	berkdb? ( >=sys-libs/db-3.2:* )
	clamav? ( app-antivirus/clamav )
	http? ( dev-libs/libxml2 dev-libs/libical )
	kerberos? ( virtual/krb5 )
	mysql? ( >=virtual/mysql-5.5 )
	nntp? ( !net-nntp/leafnode )
	pam? (
			virtual/pam
			>=net-mail/mailbase-1
		)
	postgres? ( dev-db/postgresql:* )
	snmp? ( >=net-analyzer/net-snmp-5.2.2-r1 )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( >=dev-libs/openssl-1.0.1e:* )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 snmp? ( net-analyzer/net-snmp[tcpd=] ) )"

# all blockers really needed?
RDEPEND="${DEPEND}
	!mail-mta/courier
	!net-mail/bincimap
	!net-mail/courier-imap
	!net-mail/uw-imap
	!net-mail/cyrus-imap-admin"

REQUIRED_USE="afs? ( kerberos )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewuser cyrus -1 -1 /usr/cyrus mail
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-db.patch"
	# Fix master(8)->cyrusmaster(8) manpage.
	for i in `grep -rl -e 'master\.8' -e 'master(8)' "${S}"` ; do
		sed -i -e 's:master\.8:cyrusmaster.8:g' \
			-e 's:master(8):cyrusmaster(8):g' \
			"${i}" || die "sed failed" || die "sed failed"
	done
	mv man/master.8 man/cyrusmaster.8 || die "mv failed"
	sed -i -e "s:MASTER:CYRUSMASTER:g" \
		-e "s:Master:Cyrusmaster:g" \
		-e "s:master:cyrusmaster:g" \
		man/cyrusmaster.8 || die "sed failed"

	# lock.h to afs/lock.h
	sed -i -e '/lock.h/s:lock.h:afs/lock.h:' \
		ptclient/afskrb.c || die

	eautoreconf
}

src_configure() {
	local myconf
	if use afs ; then
		myconf+=" --with-afs-libdir=/usr/$(get_libdir)"
		myconf+=" --with-afs-incdir=/usr/include/afs"
	fi
	econf \
		--enable-murder \
		--enable-netscapehack \
		--enable-idled \
		--enable-event-notification \
		--enable-autocreate \
		--enable-pcre \
		--with-service-path=/usr/$(get_libdir)/cyrus \
		--with-cyrus-user=cyrus \
		--with-cyrus-group=mail \
		--with-com_err=yes \
		--with-sasl \
		--without-krb \
		--without-krbdes \
		--with-zlib \
		$(use_enable afs) \
		$(use_enable afs krb5afspts) \
		$(use_with berkdb bdb) \
		$(use_with clamav) \
		$(use_enable nntp) \
		$(use_enable http) \
		$(use_enable replication) \
		$(use_enable kerberos gssapi) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with perl) \
		$(use_with sqlite) \
		$(use_with ssl openssl) \
		$(use_enable server) \
		$(use_enable sieve) \
		$(use_with snmp) \
		$(use_enable static-libs static) \
		$(use_with tcpd libwrap) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIRS=vendor install

	dodoc README*
	dohtml doc/*.html
	docinto text
	dodoc doc/text/*
	cp doc/cyrusv2.mc "${D}/usr/share/doc/${PF}/html"
	cp -r contrib tools "${D}/usr/share/doc/${PF}"
	rm -f doc/text/Makefile*

	insinto /etc
	doins "${FILESDIR}/cyrus.conf" "${FILESDIR}/imapd.conf"

	# turn off sieve if not installed
	if ! use sieve; then
		sed -i -e "/sieve/s/^/#/" "${D}/etc/cyrus.conf" || die
	fi

	newinitd "${FILESDIR}/cyrus.rc6" cyrus
	newconfd "${FILESDIR}/cyrus.confd" cyrus
	newpamd "${FILESDIR}/cyrus.pam-include" sieve

	for subdir in imap/{,db,log,msg,proc,socket,sieve} spool/imap/{,stage.} ; do
		keepdir "/var/${subdir}"
		fowners cyrus:mail "/var/${subdir}"
		fperms 0750 "/var/${subdir}"
	done
	for subdir in imap/{user,quota,sieve} spool/imap ; do
		for i in a b c d e f g h i j k l m n o p q r s t v u w x y z ; do
			keepdir "/var/${subdir}/${i}"
			fowners cyrus:mail "/var/${subdir}/${i}"
			fperms 0750 "/var/${subdir}/${i}"
		done
	done
}

pkg_preinst() {
	if ! has_version ${CATEGORY}/${PN} ; then
		elog "For correct logging add the following to /etc/syslog.conf:"
		elog "    local6.*         /var/log/imapd.log"
		elog "    auth.debug       /var/log/auth.log"
		echo

		elog "You have to add user cyrus to the sasldb2. Do this with:"
		elog "    saslpasswd2 cyrus"
	fi
}

pkg_postinst() {
	# do not install server.{key,pem) if they exist.
	if use ssl ; then
		if [ ! -f "${ROOT}"etc/ssl/cyrus/server.key ]; then
			install_cert /etc/ssl/cyrus/server
			chown cyrus:mail "${ROOT}"etc/ssl/cyrus/server.{key,pem}
		fi
	fi
}
