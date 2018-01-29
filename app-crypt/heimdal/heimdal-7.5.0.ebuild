# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
VIRTUALX_REQUIRED="manual"

inherit autotools db-use eutils multilib multilib-minimal python-any-r1 virtualx flag-o-matic

MY_P="${P}"
DESCRIPTION="Kerberos 5 implementation from KTH"
HOMEPAGE="http://www.h5l.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd"
IUSE="afs +berkdb caps hdb-ldap ipv6 libressl otp +pkinit selinux ssl static-libs test X"

CDEPEND="
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
	)
	berkdb? ( >=sys-libs/db-4.8.30-r1:*[${MULTILIB_USEDEP}] )
	!berkdb? ( >=sys-libs/gdbm-1.10-r1[${MULTILIB_USEDEP}] )
	caps? ( sys-libs/libcap-ng )
	>=dev-db/sqlite-3.8.2[${MULTILIB_USEDEP}]
	>=sys-libs/e2fsprogs-libs-1.42.9[${MULTILIB_USEDEP}]
	sys-libs/ncurses:0=
	>=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}]
	afs? ( net-fs/openafs )
	hdb-ldap? ( >=net-nds/openldap-2.3.0 )
	X? ( x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXt )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r1
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
	!!app-crypt/mit-krb5
	!!app-crypt/mit-krb5-appl"

DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	>=sys-devel/autoconf-2.62
	test? ( X? ( ${VIRTUALX_DEPEND} ) )"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-kerberos )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/krb5-types.h
	/usr/include/cms_asn1.h
	/usr/include/digest_asn1.h
	/usr/include/hdb_asn1.h
	/usr/include/krb5_asn1.h
	/usr/include/pkcs12_asn1.h
	/usr/include/pkinit_asn1.h
	/usr/include/rfc2459_asn1.h
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/krb5-config
)

src_prepare() {
	eapply "${FILESDIR}/heimdal_disable-check-iprop.patch"
	eapply "${FILESDIR}/heimdal_tinfo.patch"
	eautoreconf
	eapply_user
}

src_configure() {
	# QA
	append-flags -fno-strict-aliasing

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=()
	if use berkdb; then
		myconf+=(
			--with-berkeley-db
			--with-berkeley-db-include="$(db_includedir)"
		)
	else
		myconf+=(
			--without-berkeley-db
		)
	fi

	ECONF_SOURCE=${S} \
	econf \
		--enable-kcm \
		--disable-osfc2 \
		--enable-shared \
		--with-libintl=/usr \
		--with-readline=/usr \
		--with-sqlite3=/usr \
		--libexecdir=/usr/sbin \
		--enable-pthread-support \
		$(use_enable afs afs-support) \
		$(use_enable otp) \
		$(use_enable pkinit kx509) \
		$(use_enable pkinit pk-init) \
		$(use_enable static-libs static) \
		$(multilib_native_use_with caps capng) \
		$(multilib_native_use_with hdb-ldap openldap /usr) \
		$(use_with ipv6) \
		$(use_with ssl openssl /usr) \
		$(multilib_native_use_with X x) \
		"${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		emake -j1
	else
		emake -C include -j1
		emake -C lib -j1
		emake -C kdc -j1
		emake -C tools -j1
		emake -C tests/plugin -j1
	fi
}

multilib_src_test() {
	multilib_is_native_abi && emake -j1 check
}

multilib_src_install() {
	if multilib_is_native_abi; then
		INSTALL_CATPAGES="no" emake DESTDIR="${D}" install
	else
		emake -C include DESTDIR="${D}" install
		emake -C lib DESTDIR="${D}" install
		emake -C kdc DESTDIR="${D}" install
		emake -C tools DESTDIR="${D}" install
		emake -C tests/plugin DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	dodoc ChangeLog* README NEWS TODO

	# client rename
	mv "${D}"/usr/share/man/man1/{,k}su.1
	mv "${D}"/usr/bin/{,k}su

	newinitd "${FILESDIR}"/heimdal-kdc.initd-r2 heimdal-kdc
	newinitd "${FILESDIR}"/heimdal-kadmind.initd-r2 heimdal-kadmind
	newinitd "${FILESDIR}"/heimdal-kpasswdd.initd-r2 heimdal-kpasswdd
	newinitd "${FILESDIR}"/heimdal-kcm.initd-r1 heimdal-kcm

	newconfd "${FILESDIR}"/heimdal-kdc.confd heimdal-kdc
	newconfd "${FILESDIR}"/heimdal-kadmind.confd heimdal-kadmind
	newconfd "${FILESDIR}"/heimdal-kpasswdd.confd heimdal-kpasswdd
	newconfd "${FILESDIR}"/heimdal-kcm.confd heimdal-kcm

	insinto /etc
	newins "${S}"/krb5.conf krb5.conf.example

	if use hdb-ldap; then
		insinto /etc/openldap/schema
		doins "${S}/lib/hdb/hdb.schema"
	fi

	prune_libtool_files

	# default database dir
	keepdir /var/heimdal
}
