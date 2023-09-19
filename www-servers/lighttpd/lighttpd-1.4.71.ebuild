# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )

inherit lua-single meson readme.gentoo-r1 systemd tmpfiles

DESCRIPTION="Lightweight high-performance web server"
HOMEPAGE="https://www.lighttpd.net https://github.com/lighttpd"
SRC_URI="https://download.lighttpd.net/lighttpd/releases-$(ver_cut 1-2).x/${P}.tar.xz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+brotli dbi gnutls kerberos ldap +lua maxminddb mbedtls mmap mysql +nettle nss +pcre php postgres rrdtool sasl selinux ssl sqlite +system-xxhash test unwind webdav xattr +zlib zstd"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	mysql? ( dbi )
	postgres? ( dbi )
	sqlite? ( dbi )
	webdav? ( sqlite )
"

COMMON_DEPEND="
	acct-group/lighttpd
	acct-user/lighttpd
	virtual/libcrypt:=
	brotli? ( app-arch/brotli:= )
	dbi? (
		dev-db/libdbi
		mysql? ( dev-db/libdbi-drivers[mysql] )
		postgres? ( dev-db/libdbi-drivers[postgres] )
		sqlite? ( dev-db/libdbi-drivers[sqlite] )
	)
	gnutls? ( net-libs/gnutls )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-2.1.26:= )
	lua? ( ${LUA_DEPS} )
	maxminddb? ( dev-libs/libmaxminddb )
	mbedtls? ( net-libs/mbedtls )
	nettle? ( dev-libs/nettle:= )
	nss? ( dev-libs/nss )
	pcre? ( dev-libs/libpcre2 )
	php? ( dev-lang/php:*[cgi] )
	rrdtool? ( net-analyzer/rrdtool )
	sasl? ( dev-libs/cyrus-sasl )
	ssl? ( >=dev-libs/openssl-0.9.7:= )
	system-xxhash? ( dev-libs/xxhash )
	unwind? ( sys-libs/libunwind:= )
	webdav? (
		dev-libs/libxml2
		sys-fs/e2fsprogs
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
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.69-fix-meson-typo.patch
)

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
		http://redmine.lighttpd.net/projects/lighttpd/wiki/IPv6-Config"
}

src_configure() {
	local emesonargs=(
		-Dmoduledir="$(get_libdir)"/${PN}

		$(meson_feature brotli with_brotli)

		# TODO: revisit (was off in autotools ebuild)
		-Dwith_bzip=disabled

		$(meson_feature dbi with_dbi)

		# Unpackaged in Gentoo
		-Dwith_libdeflate=disabled
		# Obsolete
		-Dwith_fam=disabled

		$(meson_use gnutls with_gnutls)
		$(meson_feature kerberos with_krb5)
		$(meson_feature ldap with_ldap)

		# TODO: revisit (was off in autotools ebuild)
		-Dwith_libev=disabled

		$(meson_feature unwind with_libunwind)

		$(meson_use lua with_lua)
		-Dlua_version=${ELUA}

		$(meson_feature maxminddb with_maxminddb)
		$(meson_use mbedtls with_mbedtls)

		# TODO: revisit (was off in autotools ebuild)
		-Dwith_mysql=disabled

		$(meson_use nettle with_nettle)
		$(meson_use nss with_nss)

		# Obsolete
		-Dwith_pcre=disabled

		$(meson_use pcre with_pcre2)

		# TODO: revisit (was off in autotools ebuild)
		-Dwith_pgsql=disabled

		$(meson_feature sasl with_sasl)
		$(meson_use ssl with_openssl)
		$(meson_feature system-xxhash with_xxhash)
		$(meson_feature webdav with_webdav_props)
		$(meson_feature webdav with_webdav_locks)

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
	newinitd "${FILESDIR}"/lighttpd.initd-r1 lighttpd
	newconfd "${FILESDIR}"/lighttpd.confd lighttpd

	# Configs
	insinto /etc/lighttpd
	newins "${FILESDIR}"/conf/lighttpd.conf-r1 lighttpd.conf
	doins "${FILESDIR}"/conf/mime-types.conf
	doins "${FILESDIR}"/conf/mod_cgi.conf
	doins "${FILESDIR}"/conf/mod_fastcgi.conf

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

	systemd_dounit "${FILESDIR}"/${PN}.service
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

	if use mysql ; then
		elog
		elog "Note that upstream has moved away from using mysql directly"
		elog "via mod_mysql and is now accessing it through mod_dbi. You"
		elog "may need to update your configuration"
	fi

	elog
	elog "Upstream has deprecated a number of features. They are not missing"
	elog "but have been migrated to other mechanisms. Please see upstream"
	elog "changelog for details."
	elog "https://www.lighttpd.net/2022/1/19/1.4.64/"
}
