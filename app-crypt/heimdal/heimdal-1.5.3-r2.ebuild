# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
VIRTUALX_REQUIRED="manual"

inherit autotools db-use eutils multilib multilib-minimal python-any-r1 toolchain-funcs virtualx flag-o-matic

MY_P="${P}"
DESCRIPTION="Kerberos 5 implementation from KTH"
HOMEPAGE="http://www.h5l.org/"
SRC_URI="http://www.h5l.org/dist/src/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd"
IUSE="afs +berkdb caps hdb-ldap ipv6 otp +pkinit selinux ssl static-libs threads test X"

CDEPEND="ssl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
	berkdb? ( >=sys-libs/db-4.8.30-r1[${MULTILIB_USEDEP}] )
	!berkdb? ( >=sys-libs/gdbm-1.10-r1[${MULTILIB_USEDEP}] )
	caps? ( sys-libs/libcap-ng )
	>=dev-db/sqlite-3.8.2[${MULTILIB_USEDEP}]
	>=sys-libs/e2fsprogs-libs-1.42.9[${MULTILIB_USEDEP}]
	sys-libs/ncurses:5=
	>=sys-libs/readline-6.2_p5-r1[${MULTILIB_USEDEP}]
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
	epatch "${FILESDIR}/heimdal_missing-include.patch"
	epatch "${FILESDIR}/heimdal_db6.patch"
	epatch "${FILESDIR}/heimdal_disable-check-iprop.patch"
	epatch "${FILESDIR}/heimdal_link_order.patch"
	epatch "${FILESDIR}/heimdal_missing_symbols.patch"
	epatch "${FILESDIR}/heimdal_texinfo-5.patch"
	epatch "${FILESDIR}/heimdal_tinfo.patch"
	eautoreconf
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
		$(use_enable afs afs-support) \
		$(use_enable otp) \
		$(use_enable pkinit kx509) \
		$(use_enable pkinit pk-init) \
		$(use_enable static-libs static) \
		$(use_enable threads pthread-support) \
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
		emake -C base -j1
		emake -C lib -j1
		emake -C kdc -j1
		emake -C tools -j1
		emake -C tests/plugin -j1
	fi
}

multilib_src_test() {
	multilib_is_native_abi && emake check
}

multilib_src_install() {
	if multilib_is_native_abi; then
		INSTALL_CATPAGES="no" emake DESTDIR="${D}" install
	else
		emake -C include DESTDIR="${D}" install
		emake -C base DESTDIR="${D}" install
		emake -C lib DESTDIR="${D}" install
		emake -C kdc DESTDIR="${D}" install
		emake -C tools DESTDIR="${D}" install
		emake -C tests/plugin DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	dodoc ChangeLog README NEWS TODO

	# Begin client rename and install
	for i in {telnetd,ftpd,rshd,popper}
	do
		mv "${D}"/usr/share/man/man8/{,k}${i}.8
		mv "${D}"/usr/sbin/{,k}${i}
	done

	for i in {rcp,rsh,telnet,ftp,su,login,pagsh,kf}
	do
		mv "${D}"/usr/share/man/man1/{,k}${i}.1
		mv "${D}"/usr/bin/{,k}${i}
	done

	mv "${D}"/usr/share/man/man5/{,k}ftpusers.5
	mv "${D}"/usr/share/man/man5/{,k}login.access.5

	newinitd "${FILESDIR}"/heimdal-kdc.initd-r2 heimdal-kdc
	newinitd "${FILESDIR}"/heimdal-kadmind.initd-r2 heimdal-kadmind
	newinitd "${FILESDIR}"/heimdal-kpasswdd.initd-r2 heimdal-kpasswdd
	newinitd "${FILESDIR}"/heimdal-kcm.initd-r1 heimdal-kcm

	newconfd "${FILESDIR}"/heimdal-kdc.confd heimdal-kdc
	newconfd "${FILESDIR}"/heimdal-kadmind.confd heimdal-kadmind
	newconfd "${FILESDIR}"/heimdal-kpasswdd.confd heimdal-kpasswdd
	newconfd "${FILESDIR}"/heimdal-kcm.confd heimdal-kcm

	insinto /etc
	newins "${FILESDIR}"/krb5.conf krb5.conf.example

	if use hdb-ldap; then
		insinto /etc/openldap/schema
		doins "${S}/lib/hdb/hdb.schema"
	fi

	prune_libtool_files

	# default database dir
	keepdir /var/heimdal

	# Ugly hack for broken symlink - bug #417081
	rm "${D}"/usr/share/man/man5/qop.5 || die
	dosym mech.5 /usr/share/man/man5/qop.5
}
