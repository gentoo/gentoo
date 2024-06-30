# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/lighttpd.asc
inherit lua-single meson readme.gentoo-r1 systemd tmpfiles verify-sig

DESCRIPTION="Lightweight high-performance web server"
HOMEPAGE="https://www.lighttpd.net https://github.com/lighttpd"
if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://git.lighttpd.net/lighttpd/lighttpd1.4.git"
	inherit git-r3
else
	SRC_URI="
		https://download.lighttpd.net/lighttpd/releases-1.4.x/${P}.tar.xz
		verify-sig? ( https://download.lighttpd.net/lighttpd/releases-$(ver_cut 1-2).x/${P}.tar.xz.asc )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="BSD GPL-2"
SLOT="0"
IUSE="+brotli dbi gnutls kerberos ldap libdeflate +lua maxminddb mbedtls +nettle nss +pcre php sasl selinux ssl test unwind webdav xattr +zlib zstd"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
"

# Match the bundled xxhash version for the minimum version
COMMON_DEPEND="
	acct-group/lighttpd
	acct-user/lighttpd
	>=dev-libs/xxhash-0.8.2
	virtual/libcrypt:=
	brotli? ( app-arch/brotli:= )
	dbi? (
		dev-db/libdbi
	)
	gnutls? ( net-libs/gnutls )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-2.1.26:= )
	libdeflate? ( app-arch/libdeflate )
	lua? ( ${LUA_DEPS} )
	maxminddb? ( dev-libs/libmaxminddb )
	mbedtls? ( net-libs/mbedtls )
	nettle? ( dev-libs/nettle:= )
	nss? ( dev-libs/nss )
	pcre? ( dev-libs/libpcre2 )
	php? ( dev-lang/php:*[cgi] )
	sasl? ( dev-libs/cyrus-sasl )
	ssl? ( >=dev-libs/openssl-0.9.7:= )
	unwind? ( sys-libs/libunwind:= )
	webdav? (
		dev-libs/libxml2
		dev-db/sqlite
	)
	xattr? ( kernel_linux? ( sys-apps/attr ) )
	zlib? ( >=sys-libs/zlib-1.1 )
	zstd? ( app-arch/zstd:= )
"
DEPEND="
	${COMMON_DEPEND}
	elibc_musl? ( sys-libs/queue-standalone )
"
RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-apache )
"
BDEPEND="
	virtual/pkgconfig
	test? ( virtual/perl-Test-Harness )
	verify-sig? ( sec-keys/openpgp-keys-lighttpd )
"

# update certain parts of lighttpd.conf based on conditionals
update_config() {
	local config="${ED}/etc/lighttpd/lighttpd.conf"

	# Enable php/mod_fastcgi settings
	if use php; then
		sed -i -e 's|#.*\(include.*fastcgi.*$\)|\1|' ${config} || die
	fi

	# Automatically listen on IPv6 if built with USE=ipv6 (which we now always do)
	# bug #234987
	sed -i -e 's|# server.use-ipv6|server.use-ipv6|' ${config} || die
}

pkg_setup() {
	if use lua; then
		lua-single_pkg_setup
	fi

	if ! use pcre ; then
		ewarn "It is highly recommended that you build ${PN}"
		ewarn "with perl regular expressions support via USE=pcre."
		ewarn "Otherwise you lose support for some core options such"
		ewarn "as conditionals and modules such as mod_re{write,direct}."
	fi

	DOC_CONTENTS="IPv6 migration guide:\n
		https://wiki.lighttpd.net/IPv6-Config
	"
}

src_configure() {
	# (One specific library might be preferred on embedded systems via
	#  MYMESONARGS with e.g. -DFORCE_blah_CRYPTO)
	local emesonargs=(
		-Dmoduledir="$(get_libdir)"/${PN}

		${c_args}

		$(meson_feature brotli with_brotli)

		# TODO: revisit (was off in autotools ebuild)
		-Dwith_bzip=disabled

		$(meson_feature dbi with_dbi)

		# Obsolete
		-Dwith_fam=disabled

		$(meson_use gnutls with_gnutls)
		$(meson_feature kerberos with_krb5)
		$(meson_feature ldap with_ldap)

		$(meson_feature libdeflate with_libdeflate)

		$(meson_feature unwind with_libunwind)

		$(meson_use lua with_lua)
		-Dlua_version=${ELUA}

		$(meson_feature maxminddb with_maxminddb)
		$(meson_use mbedtls with_mbedtls)

		$(meson_use nettle with_nettle)
		$(meson_use nss with_nss)

		# Obsolete
		-Dwith_pcre=disabled

		$(meson_use pcre with_pcre2)

		$(meson_feature sasl with_sasl)
		$(meson_use ssl with_openssl)

		-Dwith_xxhash=enabled
		$(meson_feature webdav with_webdav_props)

		# Unpackaged in Gentoo
		-Dwith_wolfssl=false

		$(meson_use xattr with_xattr)
		$(meson_feature zlib with_zlib)
		$(meson_feature zstd with_zstd)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# Init script stuff
	newinitd "${FILESDIR}"/lighttpd.initd-r2 lighttpd
	newconfd "${FILESDIR}"/lighttpd.confd lighttpd

	# Configs
	insinto /etc/lighttpd
	newins "${FILESDIR}"/conf/lighttpd.conf-r3 lighttpd.conf
	doins "${FILESDIR}"/conf/mod_cgi.conf
	doins "${FILESDIR}"/conf/mod_fastcgi.conf
	doins doc/config/conf.d/mime.conf

	# Update lighttpd.conf directives based on conditionals
	update_config

	# Docs
	dodoc AUTHORS README NEWS doc/scripts/*.sh
	newdoc doc/config/lighttpd.conf lighttpd.conf.distrib
	readme.gentoo_create_doc

	docinto txt
	dodoc doc/outdated/*.txt

	doman doc/*.8

	# Logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/lighttpd.logrotate-r1 lighttpd

	keepdir /var/l{ib,og}/lighttpd /var/www/localhost/htdocs
	fowners lighttpd:lighttpd /var/l{ib,og}/lighttpd
	fperms 0750 /var/l{ib,og}/lighttpd

	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles.conf ${PN}.conf
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	readme.gentoo_print_elog

	if [[ -f ${EROOT}/etc/lighttpd.conf ]] ; then
		elog
		elog "Gentoo has a customized configuration,"
		elog "which is now located in ${EROOT}/etc/lighttpd. Please migrate your"
		elog "existing configuration."
	fi

	if use brotli || use zstd || use zlib ; then
		elog
		elog "Remember to clean your cache directory when using"
		elog "output compression!"
		elog "https://wiki.lighttpd.net/Docs_ModDeflate"
	fi
}
