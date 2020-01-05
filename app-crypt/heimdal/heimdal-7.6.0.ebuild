# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
VIRTUALX_REQUIRED="manual"

inherit autotools db-use multilib multilib-minimal python-any-r1 virtualx flag-o-matic

MY_P="${P}"
DESCRIPTION="Kerberos 5 implementation from KTH"
HOMEPAGE="http://www.h5l.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ~ppc64 s390 ~sh ~sparc x86"
IUSE="afs +berkdb caps gdbm hdb-ldap ipv6 libressl +lmdb otp selinux ssl static-libs test X"
RESTRICT="!test? ( test )"

CDEPEND="
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:=[${MULTILIB_USEDEP}] )
	)
	berkdb? ( >=sys-libs/db-4.8.30-r1:*[${MULTILIB_USEDEP}] )
	gdbm? ( >=sys-libs/gdbm-1.10-r1:=[${MULTILIB_USEDEP}] )
	lmdb? ( dev-db/lmdb )
	caps? ( sys-libs/libcap-ng )
	>=dev-db/sqlite-3.8.2[${MULTILIB_USEDEP}]
	>=sys-libs/e2fsprogs-libs-1.42.9[${MULTILIB_USEDEP}]
	sys-libs/ncurses:0=
	>=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}]
	afs? ( net-fs/openafs )
	hdb-ldap? ( >=net-nds/openldap-2.3.0 )
	X? (
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXt
	)
	!!app-crypt/mit-krb5
	!!app-crypt/mit-krb5-appl"

DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	dev-perl/JSON
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

PATCHES=(
	"${FILESDIR}/heimdal_disable-check-iprop.patch"
	"${FILESDIR}/heimdal_tinfo.patch"
	"${FILESDIR}/heimdal_hcrypto.patch"
	"${FILESDIR}/heimdal_build-headers-before-use.patch"
	"${FILESDIR}/heimdal_fix-db60.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# QA
	append-flags -fno-strict-aliasing

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-kcm
		--disable-osfc2
		--enable-shared
		--with-libintl="${EPREFIX}"/usr
		--with-readline="${EPREFIX}"/usr
		--with-sqlite3="${EPREFIX}"/usr
		--libexecdir="${EPREFIX}"/usr/sbin
		--enable-pthread-support
		--enable-kx509
		--enable-pk-init
		$(use_enable afs afs-support)
		$(use_enable gdbm ndbm-db)
		$(use_enable lmdb mdb-db)
		$(use_enable otp)
		$(use_enable static-libs static)
		$(multilib_native_use_with caps capng)
		$(multilib_native_use_with hdb-ldap openldap "${EPREFIX}"/usr)
		$(use_with ipv6)
		$(use_with ssl openssl "${EPREFIX}"/usr)
		$(multilib_native_use_with X x)
	)
	if use berkdb; then
		myeconfargs+=(
			--with-berkeley-db
			--with-berkeley-db-include="$(db_includedir)"
		)
	else
		myeconfargs+=(
			--without-berkeley-db
		)
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		emake
	else
		emake -C include
		emake -C lib
		emake -C kdc
		emake -C tools
		emake -C tests/plugin
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
	mv "${ED}"/usr/share/man/man1/{,k}su.1
	mv "${ED}"/usr/bin/{,k}su

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

	if ! use static-libs ; then
		find "${ED}" -name "*.la" -delete || die
	fi

	# default database dir
	keepdir /var/heimdal
}
