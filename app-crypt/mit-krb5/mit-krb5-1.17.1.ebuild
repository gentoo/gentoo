# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit autotools flag-o-matic multilib-minimal python-any-r1 systemd

MY_P="${P/mit-}"
P_DIR=$(ver_cut 1-2)
DESCRIPTION="MIT Kerberos V"
HOMEPAGE="https://web.mit.edu/kerberos/www/"
SRC_URI="https://web.mit.edu/kerberos/dist/krb5/${P_DIR}/${MY_P}.tar.gz"

LICENSE="openafs-krb5-a BSD MIT OPENLDAP BSD-2 HPND BSD-4 ISC RSA CC-BY-SA-3.0 || ( BSD-2 GPL-2+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="cpu_flags_x86_aes doc +keyutils libressl lmdb nls openldap +pkinit selinux +threads test xinetd"
RESTRICT="!test? ( test )"

# Test suite requires network access
RESTRICT="test"

DEPEND="
	!!app-crypt/heimdal
	>=sys-libs/e2fsprogs-libs-1.42.9[${MULTILIB_USEDEP}]
	|| (
		>=dev-libs/libverto-0.2.5[libev,${MULTILIB_USEDEP}]
		>=dev-libs/libverto-0.2.5[libevent,${MULTILIB_USEDEP}]
		>=dev-libs/libverto-0.2.5[tevent,${MULTILIB_USEDEP}]
	)
	keyutils? ( >=sys-apps/keyutils-1.5.8:=[${MULTILIB_USEDEP}] )
	lmdb? ( dev-db/lmdb )
	nls? ( sys-devel/gettext[${MULTILIB_USEDEP}] )
	openldap? ( >=net-nds/openldap-2.4.38-r1[${MULTILIB_USEDEP}] )
	pkinit? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)
	xinetd? ( sys-apps/xinetd )
	"
BDEPEND="
	${PYTHON_DEPS}
	virtual/yacc
	cpu_flags_x86_aes? (
		amd64? ( dev-lang/yasm )
		x86? ( dev-lang/yasm )
	)
	doc? ( virtual/latex-base )
	test? (
		${PYTHON_DEPS}
		dev-lang/tcl:0
		dev-util/dejagnu
		dev-util/cmocka
	)"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-kerberos )"

S=${WORKDIR}/${MY_P}/src

PATCHES=(
	"${FILESDIR}/${PN}-1.12_warn_cflags.patch"
	"${FILESDIR}/${PN}-config_LDFLAGS-r1.patch"
	"${FILESDIR}/${PN}-1.16.3-libressl-r1.patch"
	"${FILESDIR}/${PN}_dont_create_run.patch"
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/krb5-config
)

src_prepare() {
	default
	# Make sure we always use the system copies.
	rm -rf util/{et,ss,verto}
	sed -i 's:^[[:space:]]*util/verto$::' configure.in || die

	eautoreconf
}

src_configure() {
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
		$(use_enable nls) \
		$(use_enable pkinit) \
		$(use_enable threads thread-support) \
		$(use_with lmdb) \
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
		dodoc -r doc/html
		docinto pdf
		dodoc doc/pdf/*.pdf
	fi

	newinitd "${FILESDIR}"/mit-krb5kadmind.initd-r2 mit-krb5kadmind
	newinitd "${FILESDIR}"/mit-krb5kdc.initd-r2 mit-krb5kdc
	newinitd "${FILESDIR}"/mit-krb5kpropd.initd-r2 mit-krb5kpropd
	newconfd "${FILESDIR}"/mit-krb5kadmind.confd mit-krb5kadmind
	newconfd "${FILESDIR}"/mit-krb5kdc.confd mit-krb5kdc
	newconfd "${FILESDIR}"/mit-krb5kpropd.confd mit-krb5kpropd

	systemd_newunit "${FILESDIR}"/mit-krb5kadmind.service mit-krb5kadmind.service
	systemd_newunit "${FILESDIR}"/mit-krb5kdc.service mit-krb5kdc.service
	systemd_newunit "${FILESDIR}"/mit-krb5kpropd.service mit-krb5kpropd.service
	systemd_newunit "${FILESDIR}"/mit-krb5kpropd_at.service "mit-krb5kpropd@.service"
	systemd_newunit "${FILESDIR}"/mit-krb5kpropd.socket mit-krb5kpropd.socket

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
