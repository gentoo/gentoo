# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/cyrus-imapd/cyrus-imapd-2.4.17.ebuild,v 1.13 2014/12/28 16:31:47 titanofold Exp $

EAPI=4

inherit autotools db-use eutils multilib pam ssl-cert user toolchain-funcs

MY_P=${P/_/}

DESCRIPTION="The Cyrus IMAP Server"
HOMEPAGE="http://www.cyrusimap.org/"
SRC_URI="ftp://ftp.cyrusimap.org/cyrus-imapd/${MY_P}.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86"
IUSE="afs berkdb kerberos mysql nntp pam postgres replication sieve snmp sqlite ssl tcpd"

RDEPEND="sys-libs/zlib
	>=dev-libs/cyrus-sasl-2.1.13
	afs? ( net-fs/openafs )
	berkdb? ( >=sys-libs/db-3.2 )
	kerberos? ( virtual/krb5 )
	mysql? ( virtual/mysql )
	nntp? ( !net-nntp/leafnode )
	pam? (
			virtual/pam
			>=net-mail/mailbase-1
		)
	postgres? ( dev-db/postgresql )
	snmp? ( >=net-analyzer/net-snmp-5.2.2-r1 )
	sqlite? ( dev-db/sqlite )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 snmp? ( net-analyzer/net-snmp[tcpd=] ) )"

DEPEND="$RDEPEND"

# get rid of old style virtual - bug 350792
# all blockers really needed?
RDEPEND="${RDEPEND}
	!mail-mta/courier
	!net-mail/bincimap
	!net-mail/courier-imap
	!net-mail/uw-imap"

REQUIRED_USE="afs? ( kerberos )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewuser cyrus -1 -1 /usr/cyrus mail
}

src_prepare() {
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

	# do not strip
	sed -i -e '/(INSTALL/s/-s //' "${S}"/imtest/Makefile.in

	# correct afs include and liblwp.a directory
	sed -i -e '/I${with_afs_incdir/s/\/include//' \
		-e '/liblwp/s/liblwp/afs\/liblwp/' \
		"${S}"/configure{,.in} || die
	# same with lock.h
	sed -i -e '/lock.h/s:lock.h:afs/lock.h:' \
		ptclient/afskrb.c || die
	# libcom_err.a to libafscom_err.a
	sed -i -e '/afs\/libcom_err.a/s:libcom_err.a:libafscom_err.a:' \
		configure{,.in} || die

	sed -i -e "s/ar cr/$(tc-getAR) cr/" \
		perl/sieve/lib/Makefile.in \
		imap/Makefile.in \
		lib/Makefile.in \
		installsieve/Makefile.in \
		com_err/et/Makefile.in \
		sieve/Makefile.in \
		syslog/Makefile.in || die

	AT_M4DIR="cmulocal" eautoreconf
}

src_configure() {
	local myconf
	if use mysql ; then
		myconf=$(mysql_config --include)
		myconf="--with-mysql-incdir=${myconf#-I}"
	fi
	if use afs ; then
		myconf+=" --with-afs-libdir=/usr/$(get_libdir)"
		myconf+=" --with-afs-incdir=/usr/include/afs"
	fi
	if use berkdb ; then
		myconf+=" --with-bdb-incdir=$(db_includedir)"
	fi
	econf \
		--enable-murder \
		--enable-netscapehack \
		--enable-idled \
		--with-service-path=/usr/$(get_libdir)/cyrus \
		--with-cyrus-user=cyrus \
		--with-cyrus-group=mail \
		--with-com_err=yes \
		--with-sasl \
		--without-perl \
		--without-krb \
		--without-krbdes \
		--with-zlib \
		$(use_enable afs) \
		$(use_enable afs krb5afspts) \
		$(use_with berkdb bdb) \
		$(use_enable nntp) \
		$(use_enable replication) \
		$(use_enable kerberos gssapi) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with sqlite) \
		$(use_with ssl openssl) \
		$(use_enable sieve) \
		$(use_with snmp) \
		$(use_with tcpd libwrap) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	# file collision - bug #368245
	if ! use nntp ; then
		rm "${D}"/usr/share/man/man8/fetchnews.8*
	fi

	dodoc README*
	dohtml doc/*.html doc/murder.png
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
