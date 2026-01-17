# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3..4} )
# do not add a ssl USE flag.  ssl is mandatory
SSL_DEPS_SKIP=1
inherit autotools dot-a eapi9-ver flag-o-matic lua-single ssl-cert systemd toolchain-funcs

MY_P="${P/_/.}"
MY_PV="${PV}"
major_minor="$(ver_cut 1-2)"

DESCRIPTION="An IMAP and POP3 server written with security primarily in mind"
HOMEPAGE="https://www.dovecot.org/"
SRC_URI="https://www.dovecot.org/releases/${major_minor}/${MY_P}.tar.gz
	sieve? (
	https://pigeonhole.dovecot.org/releases/${major_minor}/${PN}-pigeonhole-${MY_PV}.tar.gz
	)
	managesieve? (
	https://pigeonhole.dovecot.org/releases/${major_minor}/${PN}-pigeonhole-${MY_PV}.tar.gz
	) "
S="${WORKDIR}/${MY_P}"
PIEGONHOLE_S="../dovecot-pigeonhole-${MY_PV}"
LICENSE="LGPL-2.1 MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE_DOVECOT_AUTH_DICT="cdb kerberos ldap lua mysql pam postgres sqlite"
IUSE_DOVECOT_COMPRESS="lz4 zstd"
IUSE_DOVECOT_FTS="solr stemmer textcat xapian"
IUSE_DOVECOT_OTHER="argon2 managesieve selinux sieve static-libs suid systemd system-icu test unwind"

IUSE="${IUSE_DOVECOT_AUTH_DICT} ${IUSE_DOVECOT_COMPRESS} ${IUSE_DOVECOT_FTS} ${IUSE_DOVECOT_OTHER}"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/bzip2
	dev-libs/openssl:0=
	net-libs/libtirpc:=
	dev-libs/libpcre2:0[pcre32]
	net-libs/rpcsvc-proto
	sys-libs/libcap
	virtual/zlib:=
	virtual/libcrypt:=
	virtual/libiconv
	argon2? ( dev-libs/libsodium:= )
	cdb? ( dev-db/tinycdb )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap:= )
	lua? ( ${LUA_DEPS} )
	xapian? ( dev-libs/xapian:= )
	lz4? ( app-arch/lz4 )
	mysql? ( dev-db/mysql-connector-c:0= )
	pam? ( sys-libs/pam:= )
	postgres? ( dev-db/postgresql:* )
	selinux? ( sec-policy/selinux-dovecot )
	solr? ( net-misc/curl dev-libs/expat )
	sqlite? ( dev-db/sqlite:* )
	stemmer? ( dev-libs/snowball-stemmer:= )
	system-icu? ( dev-libs/icu:= )
	suid? ( acct-group/mail )
	systemd? ( sys-apps/systemd:= )
	textcat? ( app-text/libexttextcat )
	unwind? ( sys-libs/libunwind:= )
	zstd? ( app-arch/zstd:= )
	"

RDEPEND="
	${DEPEND}
	acct-group/dovecot
	acct-group/dovenull
	acct-user/dovecot
	acct-user/dovenull
	net-mail/mailbase[pam?]
	"

BDEPEND="virtual/pkgconfig
	test? (
		lua? (
			$(lua_gen_cond_dep '
				dev-lua/luajson[${LUA_USEDEP}]
			')
		)
	)
	"

PATCHES=(
	"${FILESDIR}/${PN}-autoconf-lua-version-v3.patch"
	"${FILESDIR}/${PN}-2.4.2-tests.patch"
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

	if use sieve || use managesieve; then
		pushd "${PIEGONHOLE_S}" > /dev/null || die
		eapply "${FILESDIR}/${PN}-2.4.2-fix-32bit.patch"
		popd > /dev/null || die
	fi

	# rename default cert files
	sed -i -e "s:ssl-cert.pem:server.pem:" \
		-e "s:ssl-key.pem:server.key:" \
		doc/dovecot.conf.in || die "sed failed"

	# bug 657108, 782631
	#elibtoolize
	eautoreconf

	# Bug #727244
	append-cflags -fasynchronous-unwind-tables
}

src_configure() {
	use static-libs && lto-guarantee-fat

	# --disable-hardening because our toolchain already defaults to
	# these bits on, and it actually regresses the default _FORTIFY_SOURCE
	# level for hardened at least from 3 to 2.
	#
	# turn valgrind tests off. Bug #340791
	VALGRIND=no \
	LUAPC="${ELUA}" \
	systemdsystemunitdir="$(systemd_get_systemunitdir)" \
	econf \
		--with-rundir="${EPREFIX}/run/dovecot" \
		--with-statedir="${EPREFIX}/var/lib/dovecot" \
		--with-moduledir="${EPREFIX}/usr/$(get_libdir)/dovecot" \
		--disable-hardening \
		--with-bzlib \
		--without-libbsd \
		--with-libcap \
		--enable-experimental-mail-utf8 \
		$( use_with argon2 sodium ) \
		$( use_with cdb) \
		$( use_with system-icu icu) \
		$( use_with kerberos gssapi ) \
		$( use_with lua ) \
		$( use_with ldap ) \
		$( use_with xapian flatcurve ) \
		$( use_with lz4 ) \
		$( use_with mysql ) \
		$( use_with pam ) \
		$( use_with postgres pgsql ) \
		$( use_with sqlite ) \
		$( use_with solr ) \
		$( use_with stemmer ) \
		$( use_with systemd ) \
		$( use_with textcat ) \
		$( use_with unwind libunwind ) \
		$( use_with zstd ) \
		$( use_enable static-libs static )

	if use sieve || use managesieve; then
		# The sieve plugin needs this file to be build to determine the plugin
		# directory and the list of libraries to link to
		emake dovecot-config
		pushd "${PIEGONHOLE_S}" > /dev/null || die
		econf \
			$( use_enable static-libs static ) \
			--localstatedir="${EPREFIX}/var" \
			--enable-shared \
			--disable-hardening \
			--with-dovecot="${S}" \
			$( use_with ldap ) \
			$( use_with managesieve )
		popd > /dev/null || die
	fi
}

src_compile() {
	default
	if use sieve || use managesieve; then
		pushd "${PIEGONHOLE_S}" > /dev/null || die
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
		popd > /dev/null || die
	fi
}

src_test() {
	# bug #340791 and bug #807178
	local -x NOVALGRIND=true

	default
	if use sieve || use managesieve; then
		pushd "${PIEGONHOLE_S}" > /dev/null || die
		default
		popd > /dev/null || die
	fi
}

src_install() {
	default

	if use suid; then
		einfo "Changing perms to allow deliver to be suided"
		fowners root:mail "/usr/libexec/dovecot/dovecot-lda"
		fperms 4750 "/usr/libexec/dovecot/dovecot-lda"
	fi

	newinitd "${FILESDIR}"/dovecot.init-r6 dovecot

	use pam && dosym imap /etc/pam.d/dovecot

	insinto /etc/dovecot/conf.d
	doins "${FILESDIR}/50-misc.conf"

	dodoc AUTHORS NEWS README.md TODO

	if use sieve || use managesieve; then
		pushd "${PIEGONHOLE_S}" > /dev/null || die
		emake DESTDIR="${ED}" install

		newdoc README README.pigeonhole
		popd > /dev/null || die
	fi

	if use static-libs; then
		strip-lto-bytecode
	else
		find "${ED}"/usr/lib* -name '*.la' -delete
	fi
}

pkg_postinst() {
	if ver_replacing -lt 2.4 ; then
		# This is an upgrade which requires user review
		ewarn "Dovecot-2.4.x has new settings and WILL NOT work"
		ewarn "unless the configuration files are updated."
		ewarn "Please read the migration guide at:"
		ewarn "  https://doc.dovecot.org/2.4.1/installation/upgrade/2.3-to-2.4.html"
	fi

	# Let's not make a new certificate if we already have one
	if ! [[ -e "${ROOT}"/etc/dovecot/server.pem && \
		-e "${ROOT}"/etc/dovecot/server.key ]];	then
		einfo "Creating SSL	certificate"
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Dovecot IMAP Server}"
		install_cert /etc/dovecot/server
	fi
}
