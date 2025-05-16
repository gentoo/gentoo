# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Keep an eye on https://www.cyrusimap.org/imap/developer/compiling.html!
inherit autotools eapi9-ver flag-o-matic pam ssl-cert

DESCRIPTION="The Cyrus IMAP Server"
HOMEPAGE="https://www.cyrusimap.org/"
SRC_URI="https://github.com/cyrusimap/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD-with-attribution GPL-2"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"

IUSE="
	afs calalarm caps clamav http kerberos ldap
	mysql nntp pam perl postgres replication
	ssl static-libs tcpd test xapian
"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	afs? ( kerberos )
	calalarm? ( http )
	http? ( xapian )
"

COMMON_DEPEND="
	dev-libs/libpcre2:=
	>=dev-libs/cyrus-sasl-2.1.13:2
	>=dev-libs/jansson-2.10:=
	>=dev-libs/icu-55:=
	dev-libs/libical:=
	sys-apps/util-linux
	sys-fs/e2fsprogs
	sys-libs/zlib:=
	afs? ( net-fs/openafs )
	caps? ( sys-libs/libcap )
	clamav? ( app-antivirus/clamav:= )
	http? (
		app-arch/brotli:=
		app-arch/zstd:=
		dev-libs/libxml2
		>=net-libs/nghttp2-1.34.0:=
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
	dev-db/sqlite:3
	tcpd? (
		net-libs/libnsl:=
		>=sys-apps/tcp-wrappers-7.6
	)
	xapian? (
		>=dev-libs/xapian-1.4.0:=
		net-misc/rsync
	)
"
RDEPEND="${COMMON_DEPEND}
	acct-group/mail
	acct-user/cyrus
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-util/cunit )
"
# app-editors/vim-core needed for xxd
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	virtual/pkgconfig
	http? ( app-editors/vim-core )
"

# https://bugs.gentoo.org/678754
# TODO: check underlinking for other libraries
#PATCHES=(
#	"${FILESDIR}/cyrus-imapd-libcap-libs-r1.patch"
#)

PATCHES=(
	"${FILESDIR}"/cyrus-imapd-3.6.7-O3-perl.patch
	"${FILESDIR}"/cyrus-imapd-3.12.0-c21.patch
)

# Follow upstream recommendations with binary naming
# https://www.cyrusimap.org/imap/download/packagers.html
declare -A RENAME_BINARY=(
	[ptdump]="usr/sbin;8" # bug #905765
	[master]="usr/libexec;8"
)

src_prepare() {
	default

	local bindir mansection
	for binary in "${!RENAME_BINARY[@]}"; do
		IFS=';' read -r bindir mansection <<< "${RENAME_BINARY[${binary}]}"
		for ${file} in $(grep -rl -e "${binary}(${mansection})" man); do
			sed -e "s/${binary}(${mansection})/cyr_${binary}(${manpage})/" \
				-i ${file} || die
		done
		sed -e "s/${binary}.${mansection}/cyr_${binary}.${mansection}/" \
			-i Makefile.am || die
		sed -e "/.SH NAME/,/.sp/ s/^${binary}/cyr_${binary}/" \
			-e "s/\\\fB${binary}\\\fP/\\\fBcyr_${binary}\\\fP/" \
			-e "s/${binary^^}/CYR_${binary^^}/" \
			-i man/${binary}.${mansection} || die
		mv man/${binary}.${mansection} man/cyr_${binary}.${mansection} || die
	done

	# lock.h to afs/lock.h
	sed -i -e '/lock.h/s:lock.h:afs/lock.h:' \
		ptclient/afskrb.c || die

	eautoreconf
}

src_configure() {
	# bug #604466
	append-ldflags $(no-as-needed)

	# Workaround runtime crash
	# bug #834573
	append-flags -fno-toplevel-reorder

	# lto-type-mismatch
	filter-lto

	# TODO:
	# - revisit --with-sphinx-build=no? (it's docs this time, not the search engine)
	# - post-emerge message re lmdb removal?
	local myconf=(
		--enable-murder
		--disable-release-checks
		--enable-idled
		--enable-autocreate
		--enable-pcre
		--enable-pcre2
		--with-com_err
		--with-cyrus-user=cyrus
		--with-sasl
		--with-sphinx-build=no
		--enable-squat
		--with-zlib
		--without-wslay
		--without-chardet
		--without-cld2
		--disable-srs
		$(use_enable afs)
		$(use_enable calalarm calalarmd)
		$(use_with caps libcap)
		$(use_with clamav)
		$(use_enable nntp)
		$(use_enable http)
		$(use_with http nghttp2)
		$(use_enable replication)
		$(use_enable kerberos gssapi)
		$(use_with ldap)
		$(use_with mysql)
		$(use_with postgres pgsql)
		$(use_with perl)
		# TODO: optional again? idled etc require it
		--with-sqlite
		--enable-sieve
		$(use_with ssl openssl)
		--enable-server # bug #924652
		$(use_enable static-libs static)
		$(use_with tcpd libwrap)
		$(use_enable xapian)
		$(use_enable test unit-tests)
	)

	if use afs ; then
		myconf+=(
			--with-afs-libdir=/usr/$(get_libdir)
			--with-afs-incdir=/usr/include/afs
		)
	fi

	# http implicitly requires jmap, jmap explicitly requires http and xapian
	use http && myconf+=( --enable-jmap )

	econf ${myconf[@]}
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIRS=vendor install

	local bindir mansection
	for binary in "${!RENAME_BINARY[@]}"; do
		IFS=';' read -r bindir mansection <<< "${RENAME_BINARY[${binary}]}"
		mv "${ED}/${bindir}/${binary}" "${ED}/${bindir}/cyr_${binary}" || die
	done

	dodoc README*
	dodoc -r doc

	cp -r contrib tools "${ED}"/usr/share/doc/${PF} || die
	rm -f doc/text/Makefile* || die

	insinto /etc
	newins "${ED}"/usr/share/doc/${PF}/doc/examples/cyrus_conf/normal.conf cyrus.conf
	newins "${ED}"/usr/share/doc/${PF}/doc/examples/imapd_conf/normal.conf imapd.conf

	sed -i -e '/^configdirectory/s|/var/.*|/var/imap|' \
		-e '/^partition-default/s|/var/.*|/var/spool/imap|' \
		-e '/^sievedir/s|/var/.*|/var/imap/sieve|' \
		"${ED}"/etc/imapd.conf || die

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
}
