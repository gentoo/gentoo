# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic pam ssl-cert

DESCRIPTION="The Cyrus IMAP Server"
HOMEPAGE="https://www.cyrusimap.org/"
SRC_URI="https://github.com/cyrusimap/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD-with-attribution GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="afs backup calalarm caps clamav http kerberos ldap \
	mysql nntp pam perl postgres replication +server sieve \
	sqlite ssl static-libs tcpd test xapian"
RESTRICT="!test? ( test )"

CDEPEND="
	sys-libs/zlib:0=
	dev-libs/libpcre:3
	>=dev-libs/cyrus-sasl-2.1.13:2
	dev-libs/jansson:=
	dev-libs/icu:0=
	sys-fs/e2fsprogs
	afs? ( net-fs/openafs )
	calalarm? ( dev-libs/libical:0= )
	caps? ( sys-libs/libcap )
	clamav? ( app-antivirus/clamav )
	http? (
		dev-libs/libxml2:2
		dev-libs/libical:=
		net-libs/nghttp2:=
	)
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	mysql? ( dev-db/mysql-connector-c:0= )
	nntp? ( !net-nntp/leafnode )
	pam? (
		>=net-mail/mailbase-1
		sys-libs/pam
	)
	perl? ( dev-lang/perl:= )
	postgres? ( dev-db/postgresql:* )
	ssl? ( >=dev-libs/openssl-1.0.1e:0=[-bindist(-)] )
	sqlite? ( dev-db/sqlite:3 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	xapian? ( >=dev-libs/xapian-1.4.0:0= )
"
DEPEND="${CDEPEND}
	test? ( dev-util/cunit )
"

# all blockers really needed?
# file collision with app-arch/dump - bug 619584
RDEPEND="${CDEPEND}
	acct-group/mail
	acct-user/cyrus
	!mail-mta/courier
	!net-mail/bincimap
	!net-mail/courier-imap
	!net-mail/uw-imap
	!app-arch/dump
"

REQUIRED_USE="
	afs? ( kerberos )
	backup? ( sqlite )
	calalarm? ( http )
	http? ( sqlite )
"

# https://bugs.gentoo.org/678754
# TODO: check underlinking for other libraries
#PATCHES=(
#	"${FILESDIR}/cyrus-imapd-libcap-libs-r1.patch"
#)

src_prepare() {
	default

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

	# https://bugs.gentoo.org/604466
	append-ldflags $(no-as-needed)

	if use afs ; then
		myconf+=" --with-afs-libdir=/usr/$(get_libdir)"
		myconf+=" --with-afs-incdir=/usr/include/afs"
	fi

	# TODO:
	# - revisit --with-sphinx-build=no? (it's docs this time, not the search engine)
	# - post-emerge message re lmdb removal?
	econf \
		--enable-murder \
		--enable-idled \
		--enable-autocreate \
		--enable-pcre \
		--with-com_err \
		--with-cyrus-user=cyrus \
		--with-sasl \
		--with-sphinx-build=no \
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
		$(use_with http nghttp2) \
		$(use_enable replication) \
		$(use_enable kerberos gssapi) \
		$(use_with ldap) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with perl) \
		$(use_with sqlite) \
		$(use_with ssl openssl) \
		$(use_enable server) \
		$(use_enable sieve) \
		$(use_enable static-libs static) \
		$(use_with tcpd libwrap) \
		$(use_enable xapian) \
		$(use_enable test unit-tests) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIRS=vendor install

	dodoc README*
	dodoc -r doc

	cp -r contrib tools "${ED}/usr/share/doc/${PF}" || die
	rm -f doc/text/Makefile* || die

	mv "${ED}"/usr/libexec/{master,cyrusmaster} || die

	insinto /etc
	newins "${ED}/usr/share/doc/${PF}/doc/examples/cyrus_conf/normal.conf" cyrus.conf
	newins "${ED}/usr/share/doc/${PF}/doc/examples/imapd_conf/normal.conf" imapd.conf

	sed -i -e '/^configdirectory/s|/var/.*|/var/imap|' \
		-e '/^partition-default/s|/var/.*|/var/spool/imap|' \
		-e '/^sievedir/s|/var/.*|/var/imap/sieve|' \
		"${ED}"/etc/imapd.conf || die

	sed -i -e 's|/var/imap/socket/lmtp|/run/cyrus/socket/lmtp|' \
		-e 's|/var/imap/socket/notify|/run/cyrus/socket/notify|' \
		"${ED}"/etc/cyrus.conf || die

	# turn off sieve if not installed
	if ! use sieve; then
		sed -i -e "/sieve/s/^/#/" "${ED}/etc/cyrus.conf" || die
	fi

	# same thing for http(s) as well
	if ! use http; then
		sed -i -e "/http/s/^/#/" "${ED}/etc/cyrus.conf" || die
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
		if [[ ! -f "${ROOT}"/etc/ssl/cyrus/server.key ]]; then
			install_cert /etc/ssl/cyrus/server
			chown cyrus:mail "${ROOT}"/etc/ssl/cyrus/server.{key,pem}
		fi
	fi

	echo
	einfo "Please see https://www.cyrusimap.org/imap/download/upgrade.html"
	einfo "for upgrade instructions."
	echo
}
