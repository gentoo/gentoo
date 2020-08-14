# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info multilib-minimal pam systemd toolchain-funcs

DESCRIPTION="System Security Services Daemon provides access to identity and authentication"
HOMEPAGE="https://github.com/SSSD/sssd"
SRC_URI="https://github.com/SSSD/sssd/releases/download/${PN}-${PV//./_}/${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE="acl autofs +locator +netlink nfsv4 nls +manpages samba selinux sudo ssh systemd test valgrind"
RESTRICT="!test? ( test )"

COMMON_DEP="
	>=sys-libs/pam-0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/popt-1.16
	dev-libs/glib:2
	>=dev-libs/ding-libs-0.2
	>=dev-libs/openssl-1.0.2
	>=sys-libs/talloc-2.0.7
	>=sys-libs/tdb-1.2.9
	>=sys-libs/tevent-0.9.16
	>=sys-libs/ldb-1.1.17-r1:=
	>=net-nds/openldap-2.4.30[sasl]
	net-libs/http-parser
	>=dev-libs/libpcre-8.30
	>=app-crypt/mit-krb5-1.10.3
	dev-libs/jansson
	net-misc/curl
	locator? (
		>=app-crypt/mit-krb5-1.12.2[${MULTILIB_USEDEP}]
		>=net-dns/c-ares-1.10.0-r1[${MULTILIB_USEDEP}]
	)
	>=sys-apps/keyutils-1.5:=
	>=net-dns/c-ares-1.7.4
	selinux? (
		>=sys-libs/libselinux-2.1.9
		>=sys-libs/libsemanage-2.1
	)
	>=net-dns/bind-tools-9.9[gssapi]
	>=dev-libs/cyrus-sasl-2.1.25-r3[kerberos]
	>=sys-apps/dbus-1.6
	acl? ( net-fs/cifs-utils[acl] )
	nfsv4? ( || ( >=net-fs/nfs-utils-2.3.1-r2 net-libs/libnfsidmap ) )
	nls? ( >=sys-devel/gettext-0.18 )
	virtual/libintl
	netlink? ( dev-libs/libnl:3 )
	samba? ( >=net-fs/samba-4.10.2[winbind] )
	"

RDEPEND="${COMMON_DEP}
	>=sys-libs/glibc-2.17[nscd]
	selinux? ( >=sec-policy/selinux-sssd-2.20120725-r9 )
	"
# FIXME: Add pam_wrapper when it enters the tree. Bug #730974
DEPEND="${COMMON_DEP}
	test? (
		app-crypt/p11-kit
		dev-libs/check
		dev-libs/softhsm:2
		dev-util/cmocka
		net-libs/gnutls[pkcs11,tools]
		sys-libs/libfaketime
		sys-libs/nss_wrapper
		sys-libs/uid_wrapper
		valgrind? ( dev-util/valgrind )
	)
	manpages? (
		>=dev-libs/libxslt-1.1.26
		app-text/docbook-xml-dtd:4.4
	)"

CONFIG_CHECK="~KEYS"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ipa_hbac.h
	/usr/include/sss_idmap.h
	/usr/include/sss_nss_idmap.h
	/usr/include/wbclient_sssd.h
	# --with-ifp
	/usr/include/sss_sifp.h
	/usr/include/sss_sifp_dbus.h
	# from 1.15.3
	/usr/include/sss_certmap.h
)

pkg_setup() {
	linux-info_pkg_setup
}

src_prepare() {
	sed -i 's:#!/sbin/runscript:#!/sbin/openrc-run:' \
		"${S}"/src/sysv/gentoo/sssd.in || die "sed sssd.in"

	default
	eautoreconf
	multilib_copy_sources
}

src_configure() {
	local native_dbus_cflags=$($(tc-getPKG_CONFIG) --cflags dbus-1)

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=()

	myconf+=(
		--localstatedir="${EPREFIX}"/var
		--enable-nsslibdir="${EPREFIX}"/$(get_libdir)
		--with-plugin-path="${EPREFIX}"/usr/$(get_libdir)/sssd
		--enable-pammoddir="${EPREFIX}"/$(getpam_mod_dir)
		--with-ldb-lib-dir="${EPREFIX}"/usr/$(get_libdir)/samba/ldb
		--with-os=gentoo
		--with-nscd
		--with-unicode-lib="glib2"
		--disable-rpath
		--sbindir=/usr/sbin
		--without-kcm
		$(use_with samba libwbclient)
		--with-secrets
		$(multilib_native_use_with samba)
		$(multilib_native_use_enable acl cifs-idmap-plugin)
		$(multilib_native_use_with selinux)
		$(multilib_native_use_with selinux semanage)
		$(use_enable locator krb5-locator-plugin)
		$(multilib_native_use_with nfsv4 nfsv4-idmapd-plugin)
		$(use_enable nls)
		$(multilib_native_use_with netlink libnl)
		$(multilib_native_use_with manpages)
		$(multilib_native_use_with sudo)
		$(multilib_native_use_with autofs)
		$(multilib_native_use_with ssh)
		$(use_enable valgrind)
		--with-crypto="libcrypto"
		--without-python2-bindings
		--without-python3-bindings

		KRB5_CONFIG=/usr/bin/${CHOST}-krb5-config
	)

	# Annoyingly configure requires that you pick systemd XOR sysv
	if use systemd; then
		myconf+=(
			--with-initscript="systemd"
			--with-systemdunitdir=$(systemd_get_systemunitdir)
		)
	else
		myconf+=(--with-initscript="sysv")
	fi

	if ! multilib_is_native_abi; then
		# work-around all the libraries that are used for CLI and server
		myconf+=(
			{POPT,TALLOC,TDB,TEVENT,LDB}_{CFLAGS,LIBS}=' '
			# ldb headers are fine since native needs it
			# ldb lib fails... but it does not seem to bother
			{DHASH,COLLECTION,INI_CONFIG_V{0,1,1_1}}_{CFLAGS,LIBS}=' '
			{PCRE,CARES,SYSTEMD_LOGIN,SASL,GLIB2,DBUS,CRYPTO,P11_KIT}_{CFLAGS,LIBS}=' '

			# use native include path for dbus (needed for build)
			DBUS_CFLAGS="${native_dbus_cflags}"

			# non-pkgconfig checks
			ac_cv_lib_ldap_ldap_search=yes
			--without-secrets
			--without-libwbclient
			--without-kcm
		)

		use locator || myconf+=(
				KRB5_CONFIG=/bin/true
		)
	fi

	econf "${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake libnss_sss.la pam_sss.la
		use locator && emake sssd_krb5_locator_plugin.la
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake -j1 DESTDIR="${D}" "${_at_args[@]}" install
	else
		# easier than playing with automake...
		dopammod .libs/pam_sss.so

		into /
		dolib.so .libs/libnss_sss.so*

		if use locator; then
			exeinto /usr/$(get_libdir)/krb5/plugins/libkrb5
			doexe .libs/sssd_krb5_locator_plugin.so
		fi
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die

	insinto /etc/sssd
	insopts -m600
	doins "${S}"/src/examples/sssd-example.conf

	insinto /etc/logrotate.d
	insopts -m644
	newins "${S}"/src/examples/logrotate sssd

	newconfd "${FILESDIR}"/sssd.conf sssd
	newinitd "${FILESDIR}"/sssd sssd

	keepdir /var/lib/sss/db
	keepdir /var/lib/sss/deskprofile
	keepdir /var/lib/sss/gpo_cache
	keepdir /var/lib/sss/keytabs
	keepdir /var/lib/sss/mc
	keepdir /var/lib/sss/pipes/private
	keepdir /var/lib/sss/pubconf/krb5.include.d
	keepdir /var/lib/sss/secrets
	keepdir /var/log/sssd
}

multilib_src_test() {
	default
}

pkg_postinst() {
	elog "You must set up sssd.conf (default installed into /etc/sssd)"
	elog "and (optionally) configuration in /etc/pam.d in order to use SSSD"
	elog "features. Please see howto in	https://sssd.io/docs/design_pages/smartcard_authentication_require.html"
}
