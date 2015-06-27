# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mit-krb5/mit-krb5-1.13.2.ebuild,v 1.7 2015/06/27 12:37:14 zlogene Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic multilib-minimal python-any-r1 versionator

MY_P="${P/mit-}"
P_DIR=$(get_version_component_range 1-2)
DESCRIPTION="MIT Kerberos V"
HOMEPAGE="http://web.mit.edu/kerberos/www/"
SRC_URI="http://web.mit.edu/kerberos/dist/krb5/${P_DIR}/${MY_P}-signed.tar"

LICENSE="openafs-krb5-a BSD MIT OPENLDAP BSD-2 HPND BSD-4 ISC RSA CC-BY-SA-3.0 || ( BSD-2 GPL-2+ )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE="doc +keyutils openldap +pkinit selinux +threads test xinetd"

CDEPEND="
	!!app-crypt/heimdal
	>=sys-libs/e2fsprogs-libs-1.42.9[${MULTILIB_USEDEP}]
	|| (
		>=dev-libs/libverto-0.2.5[libev,${MULTILIB_USEDEP}]
		>=dev-libs/libverto-0.2.5[libevent,${MULTILIB_USEDEP}]
		>=dev-libs/libverto-0.2.5[tevent,${MULTILIB_USEDEP}]
	)
	keyutils? ( >=sys-apps/keyutils-1.5.8[${MULTILIB_USEDEP}] )
	openldap? ( >=net-nds/openldap-2.4.38-r1[${MULTILIB_USEDEP}] )
	pkinit? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
	xinetd? ( sys-apps/xinetd )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r1
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	virtual/yacc
	doc? ( virtual/latex-base )
	test? (
		${PYTHON_DEPS}
		dev-lang/tcl:0
		dev-util/dejagnu
	)"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-kerberos )"

S=${WORKDIR}/${MY_P}/src

MULTILIB_CHOST_TOOLS=(
	/usr/bin/krb5-config
)

src_unpack() {
	unpack ${A}
	unpack ./"${MY_P}".tar.gz
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.12_warn_cflags.patch"
	epatch "${FILESDIR}/${PN}-config_LDFLAGS.patch"

	eautoreconf
}

src_configure() {
	append-cppflags "-I${EPREFIX}/usr/include/et"
	# QA
	append-flags -fno-strict-aliasing
	append-flags -fno-strict-overflow

	multilib-minimal_src_configure
}

multilib_src_configure() {
	use keyutils || export ac_cv_header_keyutils_h=no
	ECONF_SOURCE=${S} \
	WARN_CFLAGS="set" \
	econf \
		$(use_with openldap ldap) \
		"$(multilib_native_use_with test tcl "${EPREFIX}/usr")" \
		$(use_enable pkinit) \
		$(use_enable threads thread-support) \
		--without-hesiod \
		--enable-shared \
		--with-system-et \
		--with-system-ss \
		--enable-dns-for-realm \
		--enable-kdc-lookaside-cache \
		--with-system-verto \
		--disable-rpath
}

multilib_src_compile() {
	emake -j1
}

multilib_src_test() {
	multilib_is_native_abi && emake -j1 check
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		EXAMPLEDIR="${EPREFIX}/usr/share/doc/${PF}/examples" \
		install
}

multilib_src_install_all() {
	# default database dir
	keepdir /var/lib/krb5kdc

	cd ..
	dodoc README

	if use doc; then
		dohtml -r doc/html/*
		docinto pdf
		dodoc doc/pdf/*.pdf
	fi

	newinitd "${FILESDIR}"/mit-krb5kadmind.initd-r1 mit-krb5kadmind
	newinitd "${FILESDIR}"/mit-krb5kdc.initd-r1 mit-krb5kdc
	newinitd "${FILESDIR}"/mit-krb5kpropd.initd-r1 mit-krb5kpropd

	insinto /etc
	newins "${ED}/usr/share/doc/${PF}/examples/krb5.conf" krb5.conf.example
	insinto /var/lib/krb5kdc
	newins "${ED}/usr/share/doc/${PF}/examples/kdc.conf" kdc.conf.example

	if use openldap ; then
		insinto /etc/openldap/schema
		doins "${S}/plugins/kdb/ldap/libkdb_ldap/kerberos.schema"
	fi

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/kpropd.xinetd" kpropd
	fi
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-1.8.0" ; then
		elog "MIT split the Kerberos applications from the base Kerberos"
		elog "distribution.  Kerberized versions of telnet, rlogin, rsh, rcp,"
		elog "ftp clients and telnet, ftp deamons now live in"
		elog "\"app-crypt/mit-krb5-appl\" package."
	fi
}
