# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Keep an eye on https://www.cyrusimap.org/imap/developer/compiling.html!
inherit autotools eapi9-ver flag-o-matic pam ssl-cert

DESCRIPTION="The Cyrus IMAP Server"
HOMEPAGE="https://www.cyrusimap.org/"
SRC_URI="https://github.com/cyrusimap/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD-with-attribution GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="afs backup calalarm caps clamav http kerberos ldap \
	mysql nntp pam perl postgres replication +server sieve \
	sqlite ssl static-libs tcpd test xapian"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/libpcre:3
	>=dev-libs/cyrus-sasl-2.1.13:2
	dev-libs/jansson:=
	dev-libs/icu:=
	sys-apps/util-linux
	sys-fs/e2fsprogs:=
	sys-libs/zlib:=
	afs? ( net-fs/openafs )
	calalarm? ( dev-libs/libical:= )
	caps? ( sys-libs/libcap )
	clamav? ( app-antivirus/clamav )
	http? (
		app-arch/brotli:=
		app-arch/zstd:=
		dev-libs/libxml2
		dev-libs/libical:=
		net-libs/nghttp2:=
		sci-libs/shapelib:=
	)
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	mysql? ( dev-db/mysql-connector-c:= )
	nntp? ( !net-nntp/leafnode )
	pam? (
		>=net-mail/mailbase-1
		sys-libs/pam
	)
	perl? ( dev-lang/perl:= )
	postgres? ( dev-db/postgresql:* )
	ssl? ( >=dev-libs/openssl-1.0.1e:=[-bindist(-)] )
	sqlite? ( dev-db/sqlite:3 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	xapian? (
		>=dev-libs/xapian-1.4.0:=
		net-misc/rsync
	)"
# all blockers really needed?
# file collision with app-arch/dump - bug 619584
# file collision with dev-python/tables - bug 905765
RDEPEND="${DEPEND}
	acct-group/mail
	acct-user/cyrus
	!mail-mta/courier
	!net-mail/courier-imap
	!app-arch/dump
	!dev-python/tables"
DEPEND+=" test? ( dev-util/cunit )"
BDEPEND="app-alternatives/lex
	virtual/pkgconfig
	app-alternatives/yacc
	http? ( app-editors/vim-core )"
# app-editors/vim-core needed for xxd

REQUIRED_USE="afs? ( kerberos )
	backup? ( sqlite )
	calalarm? ( http )
	http? ( sqlite )"

# https://bugs.gentoo.org/678754
# TODO: check underlinking for other libraries
PATCHES=(
	"${FILESDIR}"/${PN}-3.4.4-0001-Test-for-libm.patch
	"${FILESDIR}"/${PN}-3.4.4-0002-Avoid-underlinking-libcyrus-lm.patch
	"${FILESDIR}"/${P}-003-libcap-perl.patch
)

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

	# bug #604466
	append-ldflags $(no-as-needed)

	# Workaround runtime crash
	# bug #834573
	append-flags -fno-toplevel-reorder

	# Uses a lot of function pointers with undeclared function arguments
	append-cflags -std=gnu17

	# lto-type-mismatch
	filter-lto

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
		--without-wslay \
		--without-chardet \
		--without-cld2 \
		--disable-srs \
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

	cp -r contrib tools "${ED}"/usr/share/doc/${PF} || die
	rm -f doc/text/Makefile* || die

	mv "${ED}"/usr/libexec/{master,cyrusmaster} || die

	insinto /etc
	newins "${ED}"/usr/share/doc/${PF}/doc/examples/cyrus_conf/normal.conf cyrus.conf
	newins "${ED}"/usr/share/doc/${PF}/doc/examples/imapd_conf/normal.conf imapd.conf

	sed -i -e '/^configdirectory/s|/var/.*|/var/imap|' \
		-e '/^partition-default/s|/var/.*|/var/spool/imap|' \
		-e '/^sievedir/s|/var/.*|/var/imap/sieve|' \
		"${ED}"/etc/imapd.conf || die

	sed -i -e 's|/var/imap/socket/lmtp|/run/cyrus/socket/lmtp|' \
		-e 's|/var/imap/socket/notify|/run/cyrus/socket/notify|' \
		"${ED}"/etc/cyrus.conf || die

	# turn off sieve if not installed
	if ! use sieve; then
		sed -i -e "/sieve/s/^/#/" "${ED}"/etc/cyrus.conf || die
	fi

	# same thing for http(s) as well
	if ! use http; then
		sed -i -e "/http/s/^/#/" "${ED}"/etc/cyrus.conf || die
	fi

	newinitd "${FILESDIR}"/cyrus.rc8 cyrus
	newconfd "${FILESDIR}"/cyrus.confd cyrus
	newpamd "${FILESDIR}"/cyrus.pam-include sieve

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

	find "${ED}" -type f -name '*.la' -delete || die
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

	if ver_replacing -lt $(ver_cut 1-2) ; then
		elog "Please see https://www.cyrusimap.org/$(ver_cut 1-2)/imap/download/upgrade.html"
		elog "for upgrade instructions."
	fi

	if use backup ; then
		elog "Be aware that the experimental backup service has been deprecated by"
		elog "upstream in version 3.10.x and removed in 3.12.x."
		elog "You should migrate to other backup solutions"
	fi
}
