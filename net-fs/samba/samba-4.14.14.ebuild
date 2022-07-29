# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+),xml(+)"
inherit python-single-r1 waf-utils multilib-minimal linux-info systemd pam tmpfiles

DESCRIPTION="Samba Suite Version 4"
HOMEPAGE="https://samba.org/"

MY_PV="${PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"
if [[ ${PV} = *_rc* ]]; then
	SRC_URI="mirror://samba/rc/${MY_P}.tar.gz"
else
	SRC_URI="mirror://samba/stable/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
IUSE="acl addc addns ads ceph client cluster cpu_flags_x86_aes cups debug fam
glusterfs gpg iprint json ldap ntvfs pam profiling-data python quota +regedit
selinux snapper spotlight syslog system-heimdal +system-mitkrb5 systemd test
winbind zeroconf"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	addc? ( python json winbind )
	addns? ( python )
	ads? ( acl ldap winbind )
	cluster? ( ads )
	gpg? ( addc )
	ntvfs? ( addc )
	spotlight? ( json )
	test? ( python )
	!ads? ( !addc )
	?? ( system-heimdal system-mitkrb5 )
"

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

COMMON_DEPEND="
	>=app-arch/libarchive-3.1.2[${MULTILIB_USEDEP}]
	dev-lang/perl:=
	dev-libs/icu:=[${MULTILIB_USEDEP}]
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	dev-libs/libtasn1[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	dev-perl/Parse-Yapp
	>=net-libs/gnutls-3.4.7[${MULTILIB_USEDEP}]
	net-libs/libnsl:=[${MULTILIB_USEDEP}]
	>=sys-fs/e2fsprogs-1.46.4-r51[${MULTILIB_USEDEP}]
	>=sys-libs/ldb-2.3.4[ldap(+)?,${MULTILIB_USEDEP}]
	<sys-libs/ldb-2.4.0[ldap(+)?,${MULTILIB_USEDEP}]
	sys-libs/libcap[${MULTILIB_USEDEP}]
	sys-libs/liburing:=[${MULTILIB_USEDEP}]
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	>=sys-libs/talloc-2.3.2[${MULTILIB_USEDEP}]
	>=sys-libs/tdb-1.4.3[${MULTILIB_USEDEP}]
	>=sys-libs/tevent-0.10.2[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/libcrypt:=[${MULTILIB_USEDEP}]
	virtual/libiconv
	$(python_gen_cond_dep "
		addc? (
			dev-python/dnspython:=[\${PYTHON_USEDEP}]
			dev-python/markdown[\${PYTHON_USEDEP}]
		)
		addns? (
			dev-python/dnspython:=[\${PYTHON_USEDEP}]
			net-dns/bind-tools[gssapi]
		)
	")
	!alpha? ( !sparc? ( sys-libs/libunwind:= ) )
	acl? ( virtual/acl )
	ceph? ( sys-cluster/ceph )
	cluster? ( net-libs/rpcsvc-proto )
	cups? ( net-print/cups )
	debug? ( dev-util/lttng-ust )
	fam? ( virtual/fam )
	gpg? ( app-crypt/gpgme:= )
	json? ( dev-libs/jansson:= )
	ldap? ( net-nds/openldap:=[${MULTILIB_USEDEP}] )
	pam? ( sys-libs/pam )
	python? (
		sys-libs/ldb[python,${PYTHON_SINGLE_USEDEP}]
		sys-libs/talloc[python,${PYTHON_SINGLE_USEDEP}]
		sys-libs/tdb[python,${PYTHON_SINGLE_USEDEP}]
		sys-libs/tevent[python,${PYTHON_SINGLE_USEDEP}]
	)
	snapper? ( sys-apps/dbus )
	system-heimdal? ( >=app-crypt/heimdal-1.5[-ssl,${MULTILIB_USEDEP}] )
	system-mitkrb5? ( >=app-crypt/mit-krb5-1.15.1[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:0= )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/cmocka-1.1.3[${MULTILIB_USEDEP}]
	net-libs/libtirpc[${MULTILIB_USEDEP}]
	|| (
		net-libs/rpcsvc-proto
		<sys-libs/glibc-2.26[rpc(+)]
	)
	spotlight? ( dev-libs/glib )
	test? (
		$(python_gen_cond_dep "dev-python/subunit[\${PYTHON_USEDEP},${MULTILIB_USEDEP}]" )
		!system-mitkrb5? (
			>=net-dns/resolv_wrapper-1.1.4
			>=net-libs/socket_wrapper-1.1.9
			>=sys-libs/nss_wrapper-1.1.3
			>=sys-libs/uid_wrapper-1.2.1
		)
	)"
RDEPEND="${COMMON_DEPEND}
	client? ( net-fs/cifs-utils[ads?] )
	python? ( ${PYTHON_DEPS} )
	selinux? ( sec-policy/selinux-samba )
"
BDEPEND="${PYTHON_DEPS}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.0-pam.patch"
	"${FILESDIR}/ldb-2.5.2-skip-wav-tevent-check.patch"
)

#CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"
CONFDIR="${FILESDIR}/4.4"

WAF_BINARY="${S}/buildtools/bin/waf"

SHAREDMODS=""

pkg_setup() {
	# Package fails to build with distcc
	export DISTCC_DISABLE=1

	python-single-r1_pkg_setup

	SHAREDMODS="$(usex snapper '' '!')vfs_snapper"
	if use cluster ; then
		SHAREDMODS+=",idmap_rid,idmap_tdb2,idmap_ad"
	elif use ads ; then
		SHAREDMODS+=",idmap_ad"
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
		--accel-aes=$(usex cpu_flags_x86_aes intelaesni none)
		$(multilib_native_use_with acl acl-support)
		$(multilib_native_usex addc '' '--without-ad-dc')
		$(multilib_native_use_with addns dnsupdate)
		$(multilib_native_use_with ads)
		$(multilib_native_use_enable ceph cephfs)
		$(multilib_native_use_with cluster cluster-support)
		$(multilib_native_use_enable cups)
		--without-dmapi
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

	if multilib_is_native_abi ; then
		myconf+=( --with-shared-modules=${SHAREDMODS} )
	else
		myconf+=( --with-shared-modules=DEFAULT,!vfs_snapper )
	fi

	CPPFLAGS="-I${ESYSROOT}/usr/include/et ${CPPFLAGS}" \
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
			dosym ../../../bin/smbspool \
				/usr/libexec/cups/backend/smb
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
			-i "${ED}"/etc/samba/smb.conf.default || die

		# Install init script and conf.d file
		newinitd "${CONFDIR}/samba4.initd-r1" samba
		newconfd "${CONFDIR}/samba4.confd" samba

		dotmpfiles "${FILESDIR}"/samba.conf
		if ! use addc ; then
			rm "${D}/$(systemd_get_systemunitdir)/samba.service" \
				|| die
		fi

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
	tmpfiles_process samba.conf

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Be aware that this release contains the best of all of Samba's"
		elog "technology parts, both a file server (that you can reasonably expect"
		elog "to upgrade existing Samba 3.x releases to) and the AD domain"
		elog "controller work previously known as 'samba4'."
		elog
	fi
	elog "For further information and migration steps make sure to read "
	elog "https://samba.org/samba/history/${P}.html "
	elog "https://wiki.samba.org/index.php/Samba4/HOWTO "
}
