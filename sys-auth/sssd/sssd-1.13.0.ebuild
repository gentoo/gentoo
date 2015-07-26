# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/sssd/sssd-1.13.0.ebuild,v 1.3 2015/07/23 11:48:12 hwoarang Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils multilib pam linux-info autotools multilib-minimal python-r1 systemd toolchain-funcs

DESCRIPTION="System Security Services Daemon provides access to identity and authentication"
HOMEPAGE="http://fedorahosted.org/sssd/"
SRC_URI="http://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="acl augeas autofs +locator netlink nfsv4 nls +manpages python samba selinux sudo ssh test"

COMMON_DEP="
	>=virtual/pam-0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/popt-1.16
	dev-libs/glib:2
	>=dev-libs/ding-libs-0.2
	>=sys-libs/talloc-2.0.7
	>=sys-libs/tdb-1.2.9
	>=sys-libs/tevent-0.9.16
	>=sys-libs/ldb-1.1.17-r1:=
	>=net-nds/openldap-2.4.30[sasl]
	>=dev-libs/libpcre-8.30
	>=app-crypt/mit-krb5-1.10.3
	locator? (
		>=app-crypt/mit-krb5-1.12.2[${MULTILIB_USEDEP}]
		>=net-dns/c-ares-1.10.0-r1[${MULTILIB_USEDEP}]
	)
	>=sys-apps/keyutils-1.5
	>=net-dns/c-ares-1.7.4
	>=dev-libs/nss-3.12.9
	selinux? (
		>=sys-libs/libselinux-2.1.9
		>=sys-libs/libsemanage-2.1
	)
	>=net-dns/bind-tools-9.9[gssapi]
	>=dev-libs/cyrus-sasl-2.1.25-r3[kerberos]
	>=sys-apps/dbus-1.6
	acl? ( net-fs/cifs-utils[acl] )
	augeas? ( app-admin/augeas )
	nfsv4? ( net-libs/libnfsidmap )
	nls? ( >=sys-devel/gettext-0.18 )
	virtual/libintl
	netlink? ( dev-libs/libnl:3 )
	samba? ( >=net-fs/samba-4.0 )
	"

RDEPEND="${COMMON_DEP}
	>=sys-libs/glibc-2.17[nscd]
	selinux? ( >=sec-policy/selinux-sssd-2.20120725-r9 )
	"
DEPEND="${COMMON_DEP}
	test? ( dev-libs/check )
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
)

pkg_setup(){
	linux-info_pkg_setup
}

src_prepare() {
	# bug #553678
	epatch "${FILESDIR}"/${P}-fix-init.patch

	eautoreconf

	multilib_copy_sources

	# Maybe run it before eautoreconf?
	epatch_user
}

src_configure() {
	local native_dbus_cflags=$($(tc-getPKG_CONFIG) --cflags dbus-1)

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# set initscript to sysv because the systemd option needs systemd to
	# be installed. We provide our own systemd file anyway.
	local myconf=()
	if [[ "${PYTHON_TARGETS}" == *python2* ]]; then
		myconf+=($(multilib_native_use_with python python2-bindings))
	fi
	if [[ "${PYTHON_TARGETS}" == *python3* ]]; then
		myconf+=($(multilib_native_use_with python python3-bindings))
	fi

	myconf+=(
		--localstatedir="${EPREFIX}"/var
		--enable-nsslibdir="${EPREFIX}"/$(get_libdir)
		--with-plugin-path="${EPREFIX}"/usr/$(get_libdir)/sssd
		--enable-pammoddir="${EPREFIX}"/$(getpam_mod_dir)
		--with-ldb-lib-dir="${EPREFIX}"/usr/$(get_libdir)/samba/ldb
		--without-nscd
		--with-unicode-lib="glib2"
		--disable-rpath
		--enable-silent-rules
		--sbindir=/usr/sbin
		$(multilib_native_use_with samba)
		$(multilib_native_use_enable acl cifs-idmap-plugin)
		$(multilib_native_use_enable augeas config-lib)
		$(multilib_native_use_with selinux)
		$(multilib_native_use_with selinux semanage)
		$(use_enable locator krb5-locator-plugin)
		$(multilib_native_use_with nfsv4 nfsv4-idmapd-plugin)
		$(use_enable nls )
		$(multilib_native_use_with netlink libnl)
		$(multilib_native_use_with manpages)
		$(multilib_native_use_with sudo)
		$(multilib_native_use_with autofs)
		$(multilib_native_use_with ssh)
		--with-crypto="libcrypto"
		--with-initscript="sysv"

		KRB5_CONFIG=/usr/bin/${CHOST}-krb5-config
		)

	if ! multilib_is_native_abi; then
		# work-around all the libraries that are used for CLI and server
		myconf+=(
			{POPT,TALLOC,TDB,TEVENT,LDB}_{CFLAGS,LIBS}=' '
			# ldb headers are fine since native needs it
			# ldb lib fails... but it does not seem to bother
			{DHASH,COLLECTION,INI_CONFIG_V{0,1,1_1}}_{CFLAGS,LIBS}=' '
			{PCRE,CARES,SYSTEMD_LOGIN,SASL,GLIB2,DBUS,CRYPTO}_{CFLAGS,LIBS}=' '

			# use native include path for dbus (needed for build)
			DBUS_CFLAGS="${native_dbus_cflags}"

			# non-pkgconfig checks
			ac_cv_lib_ldap_ldap_search=yes
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
		dolib .libs/libnss_sss.so*

		if use locator; then
			exeinto /usr/$(get_libdir)/krb5/plugins/libkrb5
			doexe .libs/sssd_krb5_locator_plugin.so
		fi
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	insinto /etc/sssd
	insopts -m600
	doins "${S}"/src/examples/sssd-example.conf

	insinto /etc/logrotate.d
	insopts -m644
	newins "${S}"/src/examples/logrotate sssd

	newconfd "${FILESDIR}"/sssd.conf sssd

	systemd_dounit "${FILESDIR}/${PN}.service"
}

multilib_src_test() {
	default
}

pkg_postinst(){
	elog "You must set up sssd.conf (default installed into /etc/sssd)"
	elog "and (optionally) configuration in /etc/pam.d in order to use SSSD"
	elog "features. Please see howto in	http://fedorahosted.org/sssd/wiki/HOWTO_Configure_1_0_2"
}
