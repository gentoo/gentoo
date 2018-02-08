# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+),xml(+)'

inherit python-single-r1 waf-utils multilib-minimal linux-info systemd eutils

MY_PV="${PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

SRC_PATH="stable"
[[ ${PV} = *_rc* ]] && SRC_PATH="rc"

SRC_URI="mirror://samba/${SRC_PATH}/${MY_P}.tar.gz
	https://dev.gentoo.org/~polynomial-c/samba-4.5.11-disable-python-patches.tar.xz"
[[ ${PV} = *_rc* ]] || \
KEYWORDS="~alpha amd64 ~arm ~arm64 ia64 ~ppc ~ppc64 ~sparc x86"

DESCRIPTION="Samba Suite Version 4"
HOMEPAGE="http://www.samba.org/"
LICENSE="GPL-3"

SLOT="0"

IUSE="acl addc addns ads client cluster cups dmapi fam gnutls gpg iprint ldap pam
quota selinux syslog system-heimdal +system-mitkrb5 systemd test winbind zeroconf"

# the test suite is messed, it uses system-installed samba
# bits instead of what was built, tests things disabled via use
# flags, and generally just fails to work in a way ebuilds could
# rely on in its current state
RESTRICT="test"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/samba-4.0/policy.h
	/usr/include/samba-4.0/dcerpc_server.h
	/usr/include/samba-4.0/ctdb.h
	/usr/include/samba-4.0/ctdb_client.h
	/usr/include/samba-4.0/ctdb_protocol.h
	/usr/include/samba-4.0/ctdb_private.h
	/usr/include/samba-4.0/ctdb_typesafe_cb.h
	/usr/include/samba-4.0/ctdb_version.h
)

# sys-apps/attr is an automagic dependency (see bug #489748)
CDEPEND="${PYTHON_DEPS}
	>=app-arch/libarchive-3.1.2[${MULTILIB_USEDEP}]
	dev-lang/perl:=
	dev-libs/libaio[${MULTILIB_USEDEP}]
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	dev-libs/iniparser:0
	dev-libs/popt[${MULTILIB_USEDEP}]
	dev-python/subunit[${PYTHON_USEDEP},${MULTILIB_USEDEP}]
	sys-apps/attr[${MULTILIB_USEDEP}]
	>=sys-libs/ldb-1.1.27[ldap(+)?,python(+),${MULTILIB_USEDEP}]
	<sys-libs/ldb-1.1.30[ldap(+)?,python(+),${MULTILIB_USEDEP}]
	sys-libs/libcap
	sys-libs/ncurses:0=[${MULTILIB_USEDEP}]
	sys-libs/readline:0=
	>=sys-libs/talloc-2.1.8[python,${PYTHON_USEDEP},${MULTILIB_USEDEP}]
	>=sys-libs/tdb-1.3.10[python,${PYTHON_USEDEP},${MULTILIB_USEDEP}]
	>=sys-libs/tevent-0.9.31-r1[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/libiconv
	pam? ( virtual/pam )
	acl? ( virtual/acl )
	addns? ( net-dns/bind-tools[gssapi] )
	cluster? ( !dev-db/ctdb )
	cups? ( net-print/cups )
	dmapi? ( sys-apps/dmapi )
	fam? ( virtual/fam )
	gnutls? (
		dev-libs/libgcrypt:0
		>=net-libs/gnutls-1.4.0
	)
	gpg? ( app-crypt/gpgme )
	ldap? ( net-nds/openldap[${MULTILIB_USEDEP}] )
	system-heimdal? ( >=app-crypt/heimdal-1.5[-ssl,${MULTILIB_USEDEP}] )
	system-mitkrb5? ( app-crypt/mit-krb5[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:0= )"
DEPEND="${CDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	test? (
		>=sys-libs/nss_wrapper-1.1.3
		>=net-dns/resolv_wrapper-1.1.4
		>=net-libs/socket_wrapper-1.1.7
		>=sys-libs/uid_wrapper-1.2.1
	)"
RDEPEND="${CDEPEND}
	client? ( net-fs/cifs-utils[ads?] )
	selinux? ( sec-policy/selinux-samba )
	!dev-perl/Parse-Yapp
"

REQUIRED_USE="addc? ( gnutls !system-mitkrb5 )
	ads? ( acl gnutls ldap )
	gpg? ( addc )
	?? ( system-heimdal system-mitkrb5 )
	${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.0-pam.patch"
	"${FILESDIR}/${PN}-4.5.1-compile_et_fix.patch"
	"${FILESDIR}/${PN}-glibc-2.26-no_rpc.patch" #637320
)

#CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"
CONFDIR="${FILESDIR}/4.4"

WAF_BINARY="${S}/buildtools/bin/waf"

SHAREDMODS=""

pkg_setup() {
	python-single-r1_pkg_setup
	if use cluster ; then
		SHAREDMODS="idmap_rid,idmap_tdb2,idmap_ad"
	elif use ads ; then
		SHAREDMODS="idmap_ad"
	fi
}

src_prepare() {
	default

	# install the patches from tarball(s)
	eapply "${WORKDIR}/patches"

	# ugly hackaround for bug #592502
	cp /usr/include/tevent_internal.h "${S}"/lib/tevent/ || die

	sed -e 's:<gpgme\.h>:<gpgme/gpgme.h>:' \
		-i source4/dsdb/samdb/ldb_modules/password_hash.c \
		|| die

	# Friggin' WAF shit
	multilib_copy_sources
}

multilib_src_configure() {
	# when specifying libs for samba build you must append NONE to the end to 
	# stop it automatically including things
	local bundled_libs="NONE"
	if ! use system-heimdal && ! use system-mitkrb5 ; then
		bundled_libs="heimbase,heimntlm,hdb,kdc,krb5,wind,gssapi,hcrypto,hx509,roken,asn1,com_err,NONE"
	fi

	local myconf=()
	myconf=(
		--enable-fhs
		--sysconfdir="${EPREFIX}/etc"
		--localstatedir="${EPREFIX}/var"
		--with-modulesdir="${EPREFIX}/usr/$(get_libdir)/samba"
		--with-piddir="${EPREFIX}/run/${PN}"
		--without-lttng
		--bundled-libraries="${bundled_libs}"
		--builtin-libraries=NONE
		--disable-rpath
		--disable-rpath-install
		--nopyc
		--nopyo
		--disable-cephfs
	)
	if multilib_is_native_abi ; then
		myconf+=(
			$(use_with acl acl-support)
			$(usex addc '' '--without-ad-dc')
			$(use_with addns dnsupdate)
			$(use_with ads)
			$(use_with cluster cluster-support)
			$(use_enable cups)
			$(use_with dmapi)
			$(use_with fam)
			$(use_enable gnutls)
			$(use_with gpg gpgme)
			$(use_enable iprint)
			$(use_with ldap)
			$(use_with pam)
			$(usex pam "--with-pammodulesdir=${EPREFIX}/$(get_libdir)/security" '')
			$(use_with quota quotas)
			$(use_with syslog)
			$(use_with systemd)
			$(usex system-mitkrb5 '--with-system-mitkrb5' '')
			$(use_with winbind)
			$(usex test '--enable-selftest' '')
			$(use_enable zeroconf avahi)
			--with-shared-modules=${SHAREDMODS}
		)
	else
		myconf+=(
			--without-acl-support
			--without-ad-dc
			--without-dnsupdate
			--without-ads
			--disable-avahi
			--without-cluster-support
			--disable-cups
			--without-dmapi
			--without-fam
			--disable-gnutls
			--without-gpgme
			--disable-iprint
			$(use_with ldap)
			--without-pam
			--without-quotas
			--without-syslog
			--without-systemd
			$(usex system-mitkrb5 '--with-system-mitkrb5' '')
			--without-winbind
			--disable-python
		)
	fi

	CPPFLAGS="-I${SYSROOT}${EPREFIX}/usr/include/et ${CPPFLAGS}" \
		waf-utils_src_configure ${myconf[@]}
}

multilib_src_compile() {
	waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install

	# Make all .so files executable
	find "${D}" -type f -name "*.so" -exec chmod +x {} +

	if multilib_is_native_abi; then
		# install ldap schema for server (bug #491002)
		if use ldap ; then
			insinto /etc/openldap/schema
			doins examples/LDAP/samba.schema
		fi

		# create symlink for cups (bug #552310)
		if use cups ; then
			dosym ../../../bin/smbspool /usr/libexec/cups/backend/smb
		fi

		# install example config file
		insinto /etc/samba
		doins examples/smb.conf.default

		# Fix paths in example file (#603964)
		sed \
			-e '/log file =/s@/usr/local/samba/var/@/var/log/samba/@' \
			-e '/include =/s@/usr/local/samba/lib/@/etc/samba/@' \
			-e '/path =/s@/usr/local/samba/lib/@/var/lib/samba/@' \
			-e '/path =/s@/usr/local/samba/@/var/lib/samba/@' \
			-e '/path =/s@/usr/spool/samba@/var/spool/samba@' \
			-i "${ED%/}"/etc/samba/smb.conf.default || die

		# Install init script and conf.d file
		newinitd "${CONFDIR}/samba4.initd-r1" samba
		newconfd "${CONFDIR}/samba4.confd" samba

		systemd_dotmpfilesd "${FILESDIR}"/samba.conf
		systemd_dounit "${FILESDIR}"/nmbd.service
		systemd_dounit "${FILESDIR}"/smbd.{service,socket}
		systemd_newunit "${FILESDIR}"/smbd_at.service 'smbd@.service'
		systemd_dounit "${FILESDIR}"/winbindd.service
		systemd_dounit "${FILESDIR}"/samba.service
	fi
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		"${WAF_BINARY}" test || die "test failed"
	fi
}

pkg_postinst() {
	ewarn "Be aware the this release contains the best of all of Samba's"
	ewarn "technology parts, both a file server (that you can reasonably expect"
	ewarn "to upgrade existing Samba 3.x releases to) and the AD domain"
	ewarn "controller work previously known as 'samba4'."

	elog "For further information and migration steps make sure to read "
	elog "http://samba.org/samba/history/${P}.html "
	elog "http://samba.org/samba/history/${PN}-4.5.0.html and"
	elog "http://wiki.samba.org/index.php/Samba4/HOWTO "
}
