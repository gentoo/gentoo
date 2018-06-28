# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic pam ssl-cert user

MY_P=${P/_/}

DESCRIPTION="The Cyrus IMAP Server"
HOMEPAGE="http://www.cyrusimap.org/"
SRC_URI="ftp://ftp.cyrusimap.org/cyrus-imapd/${MY_P}.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="afs backup calalarm caps clamav http kerberos ldap lmdb \
	mysql nntp pam perl postgres replication +server sieve snmp \
	sphinx sqlite ssl static-libs tcpd test xapian"

# virtual/mysql-5.5 added for the --variable= option below
CDEPEND="sys-libs/zlib
	dev-libs/libpcre
	>=dev-libs/cyrus-sasl-2.1.13
	dev-libs/jansson
	dev-libs/icu:=
	sys-libs/e2fsprogs-libs
	afs? ( net-fs/openafs )
	calalarm? ( dev-libs/libical )
	caps? ( sys-libs/libcap )
	clamav? ( app-antivirus/clamav )
	http? ( dev-libs/libxml2 dev-libs/libical )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	lmdb? ( dev-db/lmdb )
	mysql? ( >=virtual/mysql-5.5 )
	nntp? ( !net-nntp/leafnode )
	pam? (
			virtual/pam
			>=net-mail/mailbase-1
		)
	perl? ( dev-lang/perl:= )
	postgres? ( dev-db/postgresql:* )
	snmp? ( >=net-analyzer/net-snmp-5.2.2-r1 )
	ssl? ( >=dev-libs/openssl-1.0.1e:0[-bindist] )
	sqlite? ( dev-db/sqlite:3 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 snmp? ( net-analyzer/net-snmp[tcpd=] ) )
	xapian? ( >=dev-libs/xapian-1.4.0 )"

DEPEND="${CDEPEND}
	test? ( dev-util/cunit )"

# all blockers really needed?
# file collision with app-arch/dump - bug 619584
RDEPEND="${CDEPEND}
	!mail-mta/courier
	!net-mail/bincimap
	!net-mail/courier-imap
	!net-mail/uw-imap
	!net-mail/cyrus-imap-admin
	!app-arch/dump"

REQUIRED_USE="afs? ( kerberos )
	backup? ( sqlite )
	calalarm? ( http )
	http? ( sqlite )
	sphinx? ( mysql )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewuser cyrus -1 -1 /usr/cyrus mail
	append-ldflags $(no-as-needed)
}

src_prepare() {
	# bug 604470
	eapply -p1 "${FILESDIR}/${PN}-sieve-libs-v4.patch"
	eapply -p1 "${FILESDIR}/${PN}-libcap-libs.patch"
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

	eapply_user
	eautoreconf
}

src_configure() {
	local myconf
	if use afs ; then
		myconf+=" --with-afs-libdir=/usr/$(get_libdir)"
		myconf+=" --with-afs-incdir=/usr/include/afs"
	fi
	econf \
		--enable-unit-tests \
		--enable-murder \
		--enable-idled \
		--enable-event-notification \
		--enable-autocreate \
		--enable-pcre \
		--with-cyrus-user=cyrus \
		--with-cyrus-group=mail \
		--with-sasl \
		--without-krb \
		--without-krbdes \
		--enable-squat \
		--with-zlib \
		$(use_enable afs) \
		$(use_enable afs krb5afspts) \
		$(use_enable backup) \
		$(use_enable calalarm calalarmd) \
		$(use_with caps libcap) \
		$(use_with clamav) \
		$(use_enable nntp) \
		$(use_enable http) \
		$(use_enable replication) \
		$(use_enable kerberos gssapi) \
		$(use_with ldap) \
		$(use_with lmdb) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with perl) \
		$(use_with sqlite) \
		$(use_with ssl openssl) \
		$(use_enable server) \
		$(use_enable sieve) \
		$(use_with snmp) \
		$(use_enable sphinx) \
		$(use_enable static-libs static) \
		$(use_with tcpd libwrap) \
		$(use_enable xapian) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIRS=vendor install

	dodoc README*
	dodoc -r doc
	cp -r contrib tools "${D}/usr/share/doc/${PF}"
	rm -f doc/text/Makefile*

	mv "${D}"usr/libexec/{master,cyrusmaster} || die

	insinto /etc
	newins "${D}usr/share/doc/${PF}/doc/examples/cyrus_conf/normal.conf" cyrus.conf
	newins "${D}usr/share/doc/${PF}/doc/examples/imapd_conf/normal.conf" imapd.conf

	sed -i -e '/^configdirectory/s|/var/.*|/var/imap|' \
		-e '/^partition-default/s|/var/.*|/var/spool/imap|' \
		-e '/^sievedir/s|/var/.*|/var/imap/sieve|' \
		"${D}"etc/imapd.conf

	sed -i -e 's|/var/imap/socket/lmtp|/run/cyrus/socket/lmtp|' \
		-e 's|/var/imap/socket/notify|/run/cyrus/socket/notify|' \
		"${D}"etc/cyrus.conf

	# turn off sieve if not installed
	if ! use sieve; then
		sed -i -e "/sieve/s/^/#/" "${D}/etc/cyrus.conf" || die
	fi
	# same thing for http(s) as well
	if ! use http; then
		sed -i -e "/http/s/^/#/" "${D}/etc/cyrus.conf" || die
	fi

	newinitd "${FILESDIR}/cyrus.rc8" cyrus
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
	# do not install server.{key,pem) if they exist
	if use ssl ; then
		if [ ! -f "${ROOT}"etc/ssl/cyrus/server.key ]; then
			install_cert /etc/ssl/cyrus/server
			chown cyrus:mail "${ROOT}"etc/ssl/cyrus/server.{key,pem}
		fi
	fi

	echo
	einfo "Please see http://www.cyrusimap.org/imap/download/upgrade.html"
	einfo "for upgrade instructions."
	echo
}
