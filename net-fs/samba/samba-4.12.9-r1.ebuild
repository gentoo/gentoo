# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE='threads(+),xml(+)'
inherit python-single-r1 waf-utils multilib-minimal linux-info systemd pam

MY_PV="${PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

SRC_PATH="stable"
[[ ${PV} = *_rc* ]] && SRC_PATH="rc"

SRC_URI="mirror://samba/${SRC_PATH}/${MY_P}.tar.gz"
[[ ${PV} = *_rc* ]] || \
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

DESCRIPTION="Samba Suite Version 4"
HOMEPAGE="https://www.samba.org/"
LICENSE="GPL-3"

SLOT="0"

IUSE="acl addc addns ads ceph client cluster cups debug dmapi fam glusterfs
gpg iprint json ldap ntvfs pam profiling-data python quota +regedit selinux
snapper spotlight syslog system-heimdal +system-mitkrb5 systemd test winbind
zeroconf"

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

CDEPEND="
	>=app-arch/libarchive-3.1.2[${MULTILIB_USEDEP}]
	dev-lang/perl:=
	dev-libs/icu:=[${MULTILIB_USEDEP}]
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	dev-libs/libtasn1[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	dev-perl/Parse-Yapp
	>=net-libs/gnutls-3.4.7[${MULTILIB_USEDEP}]
	net-libs/libnsl:=[${MULTILIB_USEDEP}]
	sys-libs/e2fsprogs-libs[${MULTILIB_USEDEP}]
	>=sys-libs/ldb-2.1.4[ldap(+)?,python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	<sys-libs/ldb-2.2.0[ldap(+)?,python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	sys-libs/libcap[${MULTILIB_USEDEP}]
	sys-libs/liburing:=[${MULTILIB_USEDEP}]
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	>=sys-libs/talloc-2.3.1[python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	>=sys-libs/tdb-1.4.3[python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	>=sys-libs/tevent-0.10.2[python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/libiconv
	pam? ( sys-libs/pam )
	acl? ( virtual/acl )
	$(python_gen_cond_dep "
		dev-python/subunit[\${PYTHON_MULTI_USEDEP},${MULTILIB_USEDEP}]
		addns? (
			net-dns/bind-tools[gssapi]
			dev-python/dnspython:=[\${PYTHON_MULTI_USEDEP}]
		)
	")
	ceph? ( sys-cluster/ceph )
	cluster? (
		net-libs/rpcsvc-proto
		!dev-db/ctdb
	)
	cups? ( net-print/cups )
	debug? ( dev-util/lttng-ust )
	dmapi? ( sys-apps/dmapi )
	fam? ( virtual/fam )
	gpg? ( app-crypt/gpgme )
	json? ( dev-libs/jansson )
	ldap? ( net-nds/openldap[${MULTILIB_USEDEP}] )
	snapper? ( sys-apps/dbus )
	system-heimdal? ( >=app-crypt/heimdal-1.5[-ssl,${MULTILIB_USEDEP}] )
	system-mitkrb5? ( >=app-crypt/mit-krb5-1.15.1[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:0= )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	>=dev-util/cmocka-1.1.3[${MULTILIB_USEDEP}]
	net-libs/libtirpc[${MULTILIB_USEDEP}]
	virtual/pkgconfig
	|| (
		net-libs/rpcsvc-proto
		<sys-libs/glibc-2.26[rpc(+)]
	)
	spotlight? ( dev-libs/glib )
	test? (
		!system-mitkrb5? (
			>=sys-libs/nss_wrapper-1.1.3
			>=net-dns/resolv_wrapper-1.1.4
			>=net-libs/socket_wrapper-1.1.9
			>=sys-libs/uid_wrapper-1.2.1
		)
	)"
RDEPEND="${CDEPEND}
	python? ( ${PYTHON_DEPS} )
	client? ( net-fs/cifs-utils[ads?] )
	selinux? ( sec-policy/selinux-samba )
"

BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
"

REQUIRED_USE="
	addc? ( python json winbind )
	addns? ( python )
	ads? ( acl ldap winbind )
	cluster? ( ads )
	gpg? ( addc )
	ntvfs? ( addc )
	spotlight? ( json )
	test? ( python )
	?? ( system-heimdal system-mitkrb5 )
	${PYTHON_REQUIRED_USE}
"

# the test suite is messed, it uses system-installed samba
# bits instead of what was built, tests things disabled via use
# flags, and generally just fails to work in a way ebuilds could
# rely on in its current state
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.0-pam.patch"
	"${FILESDIR}/${PN}-4.9.2-timespec.patch"
	"${FILESDIR}/${PN}-4.13-winexe_option.patch"
	"${FILESDIR}/${PN}-4.13-vfs_snapper_configure_option.patch"
)

#CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"
CONFDIR="${FILESDIR}/4.4"

WAF_BINARY="${S}/buildtools/bin/waf"

SHAREDMODS=""

pkg_setup() {
	# Package fails to build with distcc
	export DISTCC_DISABLE=1

	python-single-r1_pkg_setup
	if use cluster ; then
		SHAREDMODS="idmap_rid,idmap_tdb2,idmap_ad"
	elif use ads ; then
		SHAREDMODS="idmap_ad"
	fi
}

src_prepare() {
	default

	# un-bundle dnspython
	sed -i -e '/"dns.resolver":/d' "${S}"/third_party/wscript || die

	# unbundle iso8601 unless tests are enabled
	if ! use test ; then
		sed -i -e '/"iso8601":/d' "${S}"/third_party/wscript || die
	fi

	## ugly hackaround for bug #592502
	#cp /usr/include/tevent_internal.h "${S}"/lib/tevent/ || die

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

	local myconf=(
		--enable-fhs
		--sysconfdir="${EPREFIX}/etc"
		--localstatedir="${EPREFIX}/var"
		--with-modulesdir="${EPREFIX}/usr/$(get_libdir)/samba"
		--with-piddir="${EPREFIX}/run/${PN}"
		--bundled-libraries="${bundled_libs}"
		--builtin-libraries=NONE
		--disable-rpath
		--disable-rpath-install
		--nopyc
		--nopyo
		--without-winexe
		$(multilib_native_use_with acl acl-support)
		$(multilib_native_usex addc '' '--without-ad-dc')
		$(multilib_native_use_with addns dnsupdate)
		$(multilib_native_use_with ads)
		$(multilib_native_use_enable ceph cephfs)
		$(multilib_native_use_with cluster cluster-support)
		$(multilib_native_use_enable cups)
		$(multilib_native_use_with dmapi)
		$(multilib_native_use_with fam)
		$(multilib_native_use_enable glusterfs)
		$(multilib_native_use_with gpg gpgme)
		$(multilib_native_use_with json)
		$(multilib_native_use_enable iprint)
		$(multilib_native_use_with ntvfs ntvfs-fileserver)
		$(multilib_native_use_with pam)
		$(multilib_native_usex pam "--with-pammodulesdir=${EPREFIX}/$(get_libdir)/security" '')
		$(multilib_native_use_with quota quotas)
		$(multilib_native_use_with regedit)
		$(multilib_native_use_enable snapper)
		$(multilib_native_use_enable spotlight)
		$(multilib_native_use_with syslog)
		$(multilib_native_use_with systemd)
		--systemd-install-services
		--with-systemddir="$(systemd_get_systemunitdir)"
		$(multilib_native_use_with winbind)
		$(multilib_native_usex python '' '--disable-python')
		$(multilib_native_use_enable zeroconf avahi)
		$(multilib_native_usex test '--enable-selftest' '')
		$(usex system-mitkrb5 "--with-system-mitkrb5 $(multilib_native_usex addc --with-experimental-mit-ad-dc '')" '')
		$(use_with debug lttng)
		$(use_with ldap)
		$(use_with profiling-data)
		# bug #683148
		--jobs 1
	)

	multilib_is_native_abi && myconf+=( --with-shared-modules=${SHAREDMODS} )

	CPPFLAGS="-I${SYSROOT}${EPREFIX}/usr/include/et ${CPPFLAGS}" \
		waf-utils_src_configure ${myconf[@]}
}

multilib_src_compile() {
	waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install

	# Make all .so files executable
	find "${ED}" -type f -name "*.so" -exec chmod +x {} + || die

	if multilib_is_native_abi ; then
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
		use addc || rm "${D}/$(systemd_get_systemunitdir)/samba.service" || die

		# Preserve functionality for old gentoo-specific unit names
		dosym nmb.service "$(systemd_get_systemunitdir)/nmbd.service"
		dosym smb.service "$(systemd_get_systemunitdir)/smbd.service"
		dosym winbind.service "$(systemd_get_systemunitdir)/winbindd.service"
	fi

	if use pam && use winbind ; then
		newpamd "${CONFDIR}/system-auth-winbind.pam" system-auth-winbind
		# bugs #376853 and #590374
		insinto /etc/security
		doins examples/pam_winbind/pam_winbind.conf
	fi

	keepdir /var/cache/samba
	keepdir /var/lib/ctdb
	keepdir /var/lib/samba/{bind-dns,private}
	keepdir /var/lock/samba
	keepdir /var/log/samba
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		"${WAF_BINARY}" test || die "test failed"
	fi
}

pkg_postinst() {
	ewarn "Be aware that this release contains the best of all of Samba's"
	ewarn "technology parts, both a file server (that you can reasonably expect"
	ewarn "to upgrade existing Samba 3.x releases to) and the AD domain"
	ewarn "controller work previously known as 'samba4'."

	elog "For further information and migration steps make sure to read "
	elog "https://samba.org/samba/history/${P}.html "
	elog "https://wiki.samba.org/index.php/Samba4/HOWTO "
}
