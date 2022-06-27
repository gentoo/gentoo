# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 lua5-3 )
# do not add a ssl USE flag.  ssl is mandatory
SSL_DEPS_SKIP=1
inherit autotools flag-o-matic lua-single ssl-cert systemd toolchain-funcs

MY_P="${P/_/.}"
#MY_S="${PN}-ce-${PV}"
major_minor="$(ver_cut 1-2)"
sieve_version="0.5.18"
if [[ ${PV} == *_rc* ]]; then
	rc_dir="rc/"
else
	rc_dir=""
fi
SRC_URI="https://dovecot.org/releases/${major_minor}/${rc_dir}${MY_P}.tar.gz
	sieve? (
	https://pigeonhole.dovecot.org/releases/${major_minor}/${rc_dir}${PN}-${major_minor}-pigeonhole-${sieve_version}.tar.gz
	)
	managesieve? (
	https://pigeonhole.dovecot.org/releases/${major_minor}/${rc_dir}${PN}-${major_minor}-pigeonhole-${sieve_version}.tar.gz
	) "
DESCRIPTION="An IMAP and POP3 server written with security primarily in mind"
HOMEPAGE="https://www.dovecot.org/"

SLOT="0"
LICENSE="LGPL-2.1 MIT"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

IUSE_DOVECOT_AUTH="kerberos ldap lua mysql pam postgres sqlite"
IUSE_DOVECOT_COMPRESS="lz4 zstd"
IUSE_DOVECOT_OTHER="argon2 caps doc ipv6 lucene managesieve rpc
	selinux sieve solr static-libs stemmer suid systemd tcpd textcat unwind"

IUSE="${IUSE_DOVECOT_AUTH} ${IUSE_DOVECOT_COMPRESS} ${IUSE_DOVECOT_OTHER}"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	dev-libs/icu:=
	dev-libs/openssl:0=
	sys-libs/zlib:=
	virtual/libiconv
	argon2? ( dev-libs/libsodium:= )
	caps? ( sys-libs/libcap )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	lua? ( ${LUA_DEPS} )
	lucene? ( >=dev-cpp/clucene-2.3 )
	lz4? ( app-arch/lz4 )
	mysql? ( dev-db/mysql-connector-c:0= )
	pam? ( sys-libs/pam:= )
	postgres? ( dev-db/postgresql:* !dev-db/postgresql[ldap,threads] )
	rpc? ( net-libs/libtirpc:= net-libs/rpcsvc-proto )
	selinux? ( sec-policy/selinux-dovecot )
	solr? ( net-misc/curl dev-libs/expat )
	sqlite? ( dev-db/sqlite:* )
	stemmer? ( dev-libs/snowball-stemmer:= )
	suid? ( acct-group/mail )
	systemd? ( sys-apps/systemd:= )
	tcpd? ( sys-apps/tcp-wrappers )
	textcat? ( app-text/libexttextcat )
	unwind? ( sys-libs/libunwind:= )
	zstd? ( app-arch/zstd:= )
	virtual/libcrypt:=
	"

RDEPEND="
	${DEPEND}
	acct-group/dovecot
	acct-group/dovenull
	acct-user/dovecot
	acct-user/dovenull
	net-mail/mailbase
	"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}"-autoconf-lua-version-v2.patch
	"${FILESDIR}/${PN}"-socket-name-too-long.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
	if use managesieve && ! use sieve; then
		ewarn "managesieve USE flag selected but sieve USE flag unselected"
		ewarn "sieve USE flag will be turned on"
	fi
}

src_prepare() {
	default
	# bug 657108
	#elibtoolize
	eautoreconf

	# Bug #727244
	append-cflags -fasynchronous-unwind-tables
}

src_configure() {
	local conf=""

	if use postgres || use mysql || use sqlite; then
		conf="${conf} --with-sql"
	fi

	# turn valgrind tests off. Bug #340791
	VALGRIND=no \
	LUAPC="${ELUA}" \
	systemdsystemunitdir="$(systemd_get_systemunitdir)" \
	econf \
		--with-rundir="${EPREFIX}/run/dovecot" \
		--with-statedir="${EPREFIX}/var/lib/dovecot" \
		--with-moduledir="${EPREFIX}/usr/$(get_libdir)/dovecot" \
		--disable-rpath \
		--with-bzlib \
		--without-libbsd \
		--with-lzma \
		--with-icu \
		--with-ssl \
		--with-zlib \
		$( use_with argon2 sodium ) \
		$( use_with caps libcap ) \
		$( use_with kerberos gssapi ) \
		$( use_with lua ) \
		$( use_with ldap ) \
		$( use_with lucene ) \
		$( use_with lz4 ) \
		$( use_with mysql ) \
		$( use_with pam ) \
		$( use_with postgres pgsql ) \
		$( use_with sqlite ) \
		$( use_with solr ) \
		$( use_with stemmer ) \
		$( use_with systemd ) \
		$( use_with tcpd libwrap ) \
		$( use_with textcat ) \
		$( use_with unwind libunwind ) \
		$( use_with zstd ) \
		$( use_enable static-libs static ) \
		${conf}

	if use sieve || use managesieve; then
		# The sieve plugin needs this file to be build to determine the plugin
		# directory and the list of libraries to link to.
		emake dovecot-config
		cd "../dovecot-${major_minor}-pigeonhole-${sieve_version}" || die "cd failed"
		econf \
			$( use_enable static-libs static ) \
			--localstatedir="${EPREFIX}/var" \
			--enable-shared \
			--with-dovecot="${S}" \
			$( use_with ldap ) \
			$( use_with managesieve )
	fi
}

src_compile() {
	default
	if use sieve || use managesieve; then
		cd "../dovecot-${major_minor}-pigeonhole-${sieve_version}" || die "cd failed"
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
	fi
}

src_test() {
	default
	if use sieve || use managesieve; then
		cd "../dovecot-${major_minor}-pigeonhole-${sieve_version}" || die "cd failed"
		default
	fi
}

src_install() {
	default

	# insecure:
	# use suid && fperms u+s /usr/libexec/dovecot/deliver
	# better:
	if use suid; then
		einfo "Changing perms to allow deliver to be suided"
		fowners root:mail "/usr/libexec/dovecot/dovecot-lda"
		fperms 4750 "/usr/libexec/dovecot/dovecot-lda"
	fi

	newinitd "${FILESDIR}"/dovecot.init-r6 dovecot

	rm -rf "${ED}"/usr/share/doc/dovecot

	dodoc AUTHORS NEWS README TODO
	dodoc doc/*.{txt,cnf,xml,sh}
	docinto example-config
	dodoc doc/example-config/*.{conf,ext}
	docinto example-config/conf.d
	dodoc doc/example-config/conf.d/*.{conf,ext}
	docinto wiki
	dodoc doc/wiki/*
	doman doc/man/*.{1,7}

	# Create the dovecot.conf file from the dovecot-example.conf file that
	# the dovecot folks nicely left for us....
	local conf="${ED}/etc/dovecot/dovecot.conf"
	local confd="${ED}/etc/dovecot/conf.d"

	insinto /etc/dovecot
	doins doc/example-config/*.{conf,ext}
	insinto /etc/dovecot/conf.d
	doins doc/example-config/conf.d/*.{conf,ext}
	fperms 0600 /etc/dovecot/dovecot-{ldap,sql}.conf.ext
	rm -f "${confd}/../README"

	# .maildir is the Gentoo default
	local mail_location="maildir:~/.maildir"
	sed -i -e \
		"s|#mail_location =|mail_location = ${mail_location}|" \
		"${confd}/10-mail.conf" \
		|| die "failed to update mail location settings in 10-mail.conf"

	# We're using pam files (imap and pop3) provided by mailbase
	if use pam; then
		sed -i -e '/driver = pam/,/^[ \t]*}/ s|#args = dovecot|args = "\*"|' \
			"${confd}/auth-system.conf.ext" \
			|| die "failed to update PAM settings in auth-system.conf.ext"
		# mailbase does not provide a sieve pam file
		use managesieve && dosym imap /etc/pam.d/sieve
		sed -i -e \
			's/#!include auth-system.conf.ext/!include auth-system.conf.ext/' \
			"${confd}/10-auth.conf" \
			|| die "failed to update PAM settings in 10-auth.conf"
	fi

	# Disable ipv6 if necessary
	if ! use ipv6; then
		sed -i -e 's/^#listen = \*, ::/listen = \*/g' "${conf}" \
			|| die "failed to update listen settings in dovecot.conf"
	fi

	# Update ssl cert locations
	sed -i -e 's:^#ssl = yes:ssl = yes:' "${confd}/10-ssl.conf" \
		|| die "ssl conf failed"
	sed -i -e 's:^ssl_cert =.*:ssl_cert = </etc/ssl/dovecot/server.pem:' \
		-e 's:^ssl_key =.*:ssl_key = </etc/ssl/dovecot/server.key:' \
		"${confd}/10-ssl.conf" || die "failed to update SSL settings in 10-ssl.conf"

	# Install SQL configuration
	if use mysql || use postgres; then
		sed -i -e \
			's/#!include auth-sql.conf.ext/!include auth-sql.conf.ext/' \
			"${confd}/10-auth.conf" || die "failed to update SQL settings in \
			10-auth.conf"
	fi

	# Install LDAP configuration
	if use ldap; then
		sed -i -e \
			's/#!include auth-ldap.conf.ext/!include auth-ldap.conf.ext/' \
			"${confd}/10-auth.conf" \
			|| die "failed to update ldap settings in 10-auth.conf"
	fi

	if use sieve || use managesieve; then
		cd "../dovecot-${major_minor}-pigeonhole-${sieve_version}" || die "cd failed"
		emake DESTDIR="${ED}" install
		sed -i -e \
			's/^[[:space:]]*#mail_plugins = $mail_plugins/mail_plugins = sieve/' "${confd}/15-lda.conf" \
			|| die "failed to update sieve settings in 15-lda.conf"
		rm -rf "${ED}"/usr/share/doc/dovecot
		docinto example-config/conf.d
		dodoc doc/example-config/conf.d/*.conf
		insinto /etc/dovecot/conf.d
		doins doc/example-config/conf.d/90-sieve{,-extprograms}.conf
		use managesieve && doins doc/example-config/conf.d/20-managesieve.conf
		docinto sieve/rfc
		dodoc doc/rfc/*.txt
		docinto sieve/devel
		dodoc doc/devel/DESIGN
		docinto plugins
		dodoc doc/plugins/*.txt
		docinto extensions
		dodoc doc/extensions/*.txt
		docinto locations
		dodoc doc/locations/*.txt
		doman doc/man/*.{1,7}
	fi

	use static-libs || find "${ED}"/usr/lib* -name '*.la' -delete
}

pkg_postinst() {
	# Let's not make a new certificate if we already have one
	if ! [[ -e "${ROOT}"/etc/ssl/dovecot/server.pem && \
		-e "${ROOT}"/etc/ssl/dovecot/server.key ]];	then
		einfo "Creating SSL	certificate"
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Dovecot IMAP Server}"
		install_cert /etc/ssl/dovecot/server
	fi

	elog "Please read https://doc.dovecot.org/installation_guide/upgrading/ for upgrade notes."
}
