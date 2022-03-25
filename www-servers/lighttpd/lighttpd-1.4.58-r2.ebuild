# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} )

inherit autotools flag-o-matic lua-single readme.gentoo-r1 systemd tmpfiles toolchain-funcs

DESCRIPTION="Lightweight high-performance web server"
HOMEPAGE="https://www.lighttpd.net https://github.com/lighttpd"
SRC_URI="https://download.lighttpd.net/lighttpd/releases-1.4.x/${P}.tar.xz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 sparc x86"
IUSE="brotli bzip2 dbi doc gdbm gnutls ipv6 kerberos ldap libev lua maxminddb minimal mbedtls mmap memcached mysql nss pcre php postgres rrdtool sasl selinux ssl sqlite test webdav xattr zlib"
RESTRICT="!test? ( test )"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	mysql? ( dbi )
	postgres? ( dbi )
	sqlite? ( dbi )
	webdav? ( sqlite )
"

BDEPEND="virtual/pkgconfig"

COMMON_DEPEND="
	virtual/libcrypt:=
	brotli? ( app-arch/brotli )
	bzip2? ( app-arch/bzip2 )
	dbi? (
		dev-db/libdbi
		mysql? ( dev-db/libdbi-drivers[mysql] )
		postgres? ( dev-db/libdbi-drivers[postgres] )
		sqlite? ( dev-db/libdbi-drivers[sqlite] )
	)
	gdbm? ( sys-libs/gdbm:= )
	gnutls? ( net-libs/gnutls:= )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-2.1.26:= )
	libev? ( >=dev-libs/libev-4.01 )
	lua? ( ${LUA_DEPS} )
	maxminddb? ( dev-libs/libmaxminddb:= )
	mbedtls? ( net-libs/mbedtls:= )
	memcached? ( dev-libs/libmemcached )
	nss? ( dev-libs/nss )
	pcre? ( >=dev-libs/libpcre-3.1:= )
	php? ( dev-lang/php:*[cgi] )
	rrdtool? ( net-analyzer/rrdtool )
	sasl? ( dev-libs/cyrus-sasl )
	ssl? ( >=dev-libs/openssl-0.9.7:0= )
	webdav? (
		dev-libs/libxml2
		sys-fs/e2fsprogs
	)
	xattr? ( kernel_linux? ( sys-apps/attr ) )
	zlib? ( >=sys-libs/zlib-1.1 )
	acct-group/lighttpd
	acct-user/lighttpd"

DEPEND="${COMMON_DEPEND}
	doc?  ( dev-python/docutils )
	test? (
		virtual/perl-Test-Harness
		dev-libs/fcgi
	)"

RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-apache )
"

# update certain parts of lighttpd.conf based on conditionals
update_config() {
	local config="${D}/etc/lighttpd/lighttpd.conf"

	# enable php/mod_fastcgi settings
	use php && { sed -i -e 's|#.*\(include.*fastcgi.*$\)|\1|' ${config} || die; }

	# automatically listen on IPv6 if built with USE=ipv6. Bug #234987
	use ipv6 && { sed -i -e 's|# server.use-ipv6|server.use-ipv6|' ${config} || die; }
}

# remove non-essential stuff (for USE=minimal)
remove_non_essential() {
	local libdir="${D}/usr/$(get_libdir)/${PN}"

	# text docs
	use doc || rm -fr "${D}"/usr/share/doc/${PF}/txt

	# non-essential modules
	rm -f \
		${libdir}/mod_{evhost,expire,proxy,scgi,secdownload,simple_vhost,status,setenv,trigger*,usertrack}.* || die

	# allow users to keep some based on USE flags
	use pcre    || rm -f ${libdir}/mod_{ssi,re{direct,write}}.*
	use webdav  || rm -f ${libdir}/mod_webdav.*
	use lua     || rm -f ${libdir}/mod_{cml,magnet}.*
	use rrdtool || rm -f ${libdir}/mod_rrdtool.*
	use zlib || use bzip2 || use brotli || rm -f ${libdir}/mod_deflate.*
}

pkg_setup() {
	if use lua; then
		lua-single_pkg_setup
	fi

	if ! use pcre ; then
		ewarn "It is highly recommended that you build ${PN}"
		ewarn "with perl regular expressions support via USE=pcre."
		ewarn "Otherwise you lose support for some core options such"
		ewarn "as conditionals and modules such as mod_re{write,direct}"
		ewarn "and mod_ssi."
	fi

	DOC_CONTENTS="IPv6 migration guide:\n
		http://redmine.lighttpd.net/projects/lighttpd/wiki/IPv6-Config"
}

src_prepare() {
	default
	use memcached && append-ldflags -pthread
	# dev-python/docutils installs rst2html.py not rst2html
	sed -i -e 's|\(rst2html\)|\1.py|g' doc/outdated/Makefile.am || \
		die "sed doc/Makefile.am failed"
	eautoreconf
}

src_configure() {
	# The lua bit requires a bit of explanation. The lighttpd autoconf script
	# handles the value passed to --with-lua as follows:
	#  - "no" - do nothing
	#  - "yes" - query pkgconfig for VERSIONED lua packages, starting with 5.3
	#    and going down; only if lua5.1 cannot be found plain "lua" is tried
	#  - any other value is passed to pkgconfig as the exact package name to use.
	# We want a specific implementation to be used even if a newer one is present
	# in the system so we use the latter mode.
	econf \
		CC_FOR_BUILD=$(tc-getBUILD_CC) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--enable-lfs \
		$(use_enable ipv6) \
		$(use_enable mmap) \
		$(use_with brotli) \
		$(use_with bzip2) \
		$(use_with dbi) \
		$(use_with gdbm) \
		$(use_with gnutls ) \
		$(use_with kerberos krb5) \
		$(use_with ldap) \
		$(use_with libev) \
		$(use_with lua lua ${ELUA}) \
		$(use_with maxminddb) \
		$(use_with mbedtls) \
		$(use_with memcached) \
		$(use_with nss) \
		$(use_with pcre) \
		$(use_with sasl) \
		$(use_with ssl openssl) \
		$(use_with webdav webdav-props) \
		$(use_with webdav webdav-locks) \
		$(use_with xattr attr) \
		$(use_with zlib)
}

src_compile() {
	emake

	if use doc ; then
		einfo "Building HTML documentation"
		cd doc || die
		emake html
	fi
}

src_test() {
	if [[ ${EUID} -eq 0 ]]; then
		default_src_test
	else
		ewarn "test skipped, please re-run as root if you wish to test ${PN}"
	fi
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die

	# init script stuff
	newinitd "${FILESDIR}"/lighttpd.initd lighttpd
	newconfd "${FILESDIR}"/lighttpd.confd lighttpd

	# configs
	insinto /etc/lighttpd
	doins "${FILESDIR}"/conf/lighttpd.conf
	doins "${FILESDIR}"/conf/mime-types.conf
	doins "${FILESDIR}"/conf/mod_cgi.conf
	doins "${FILESDIR}"/conf/mod_fastcgi.conf

	# update lighttpd.conf directives based on conditionals
	update_config

	# docs
	dodoc AUTHORS README NEWS doc/scripts/*.sh
	newdoc doc/config//lighttpd.conf lighttpd.conf.distrib
	use ipv6 && readme.gentoo_create_doc

	use doc && dodoc -r doc

	docinto txt
	dodoc doc/outdated/*.txt

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/lighttpd.logrotate-r1 lighttpd

	keepdir /var/l{ib,og}/lighttpd /var/www/localhost/htdocs
	fowners lighttpd:lighttpd /var/l{ib,og}/lighttpd
	fperms 0750 /var/l{ib,og}/lighttpd

	# spawn-fcgi may optionally be installed via www-servers/spawn-fcgi
	rm -f "${D}"/usr/bin/spawn-fcgi "${D}"/usr/share/man/man1/spawn-fcgi.* || die

	use minimal && remove_non_essential

	systemd_dounit "${FILESDIR}/${PN}.service"
	newtmpfiles "${FILESDIR}/${PN}.tmpfiles.conf" "${PN}.conf"
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	use ipv6 && readme.gentoo_print_elog

	if [[ -f ${ROOT}/etc/conf.d/spawn-fcgi.conf ]] ; then
		einfo "spawn-fcgi is now provided by www-servers/spawn-fcgi."
		einfo "spawn-fcgi's init script configuration is now located"
		einfo "at /etc/conf.d/spawn-fcgi."
	fi

	if [[ -f ${ROOT}/etc/lighttpd.conf ]] ; then
		elog
		elog "Gentoo has a customized configuration,"
		elog "which is now located in /etc/lighttpd. Please migrate your"
		elog "existing configuration."
	fi

	if use brotli || use bzip2 || use zlib; then
		elog
		elog "Remember to clean your cache directory when using"
		elog "output compression!"
		elog "https://redmine.lighttpd.net/projects/lighttpd/wiki/Docs_ModDeflate"
	fi

	if use mysql; then
		elog
		elog "Note that upstream has moved away from using mysql directly"
		elog "via mod_mysql and is now accessing it through mod_dbi. You"
		elog "may need to update your configuration"
	fi

	elog
	elog "Upstream has deprecated a number of features. They are not missing"
	elog "but have been migrated to other mechanisms. Please see upstream"
	elog "changelog for details."
	elog "https://www.lighttpd.net/2020/12/17/1.4.57/"
}
