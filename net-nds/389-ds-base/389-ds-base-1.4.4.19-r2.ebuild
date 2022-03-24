# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
	ahash-0.7.6
	ansi_term-0.11.0
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.0.1
	base64-0.13.0
	bitflags-1.2.1
	bitflags-1.3.2
	byteorder-1.4.3
	cbindgen-0.9.1
	cc-1.0.72
	cfg-if-0.1.10
	cfg-if-1.0.0
	clap-2.33.3
	clap-2.34.0
	concread-0.2.21
	crossbeam-0.8.1
	crossbeam-channel-0.5.2
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.6
	crossbeam-queue-0.3.3
	crossbeam-utils-0.8.6
	fastrand-1.7.0
	fernet-0.1.4
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	getrandom-0.1.16
	getrandom-0.2.4
	hashbrown-0.11.2
	hermit-abi-0.1.17
	hermit-abi-0.1.19
	instant-0.1.12
	itoa-0.4.7
	itoa-1.0.1
	jobserver-0.1.24
	lazy_static-1.4.0
	libc-0.2.113
	libc-0.2.82
	lock_api-0.4.5
	log-0.4.13
	log-0.4.14
	lru-0.7.2
	memoffset-0.6.5
	once_cell-1.9.0
	openssl-0.10.38
	openssl-sys-0.9.72
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	paste-0.1.18
	paste-impl-0.1.18
	pin-project-lite-0.2.8
	pkg-config-0.3.24
	ppv-lite86-0.2.10
	ppv-lite86-0.2.16
	proc-macro2-1.0.24
	proc-macro2-1.0.36
	proc-macro-hack-0.5.19
	quote-1.0.15
	quote-1.0.8
	rand-0.7.3
	rand-0.8.4
	rand_chacha-0.2.2
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.3
	rand_hc-0.2.0
	rand_hc-0.3.1
	redox_syscall-0.1.57
	redox_syscall-0.2.10
	remove_dir_all-0.5.3
	ryu-1.0.5
	ryu-1.0.9
	scopeguard-1.1.0
	serde-1.0.119
	serde-1.0.135
	serde_derive-1.0.119
	serde_derive-1.0.135
	serde_json-1.0.61
	serde_json-1.0.78
	smallvec-1.8.0
	strsim-0.8.0
	syn-1.0.58
	syn-1.0.86
	synstructure-0.12.6
	tempfile-3.1.0
	tempfile-3.3.0
	textwrap-0.11.0
	tokio-1.15.0
	tokio-macros-1.7.0
	toml-0.5.8
	unicode-width-0.1.8
	unicode-width-0.1.9
	unicode-xid-0.2.1
	unicode-xid-0.2.2
	uuid-0.8.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.4
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.9.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	zeroize-1.5.0
	zeroize_derive-1.3.1
"

PYTHON_COMPAT=( python3_{8,9,10} )

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit autotools distutils-r1 systemd tmpfiles db-use cargo

DESCRIPTION="389 Directory Server (core libraries and daemons)"
HOMEPAGE="https://directory.fedoraproject.org/"
SRC_URI="https://github.com/389ds/${PN}/archive/refs/tags/${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
LICENSE="GPL-3+ Apache-2.0 BSD MIT MPL-2.0"
SLOT="$(ver_cut 1-2)/0"
KEYWORDS="~amd64"
IUSE_PLUGINS="+accountpolicy +bitwise +dna +pam-passthru"
IUSE="${IUSE_PLUGINS} +autobind auto-dn-suffix debug doc +ldapi selinux systemd"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# lib389 tests (which is most of the suite) can't find their own modules.
RESTRICT="test"

# always list newer first
# Do not add any AGPL-3 BDB here!
# See bug 525110, comment 15.
BERKDB_SLOTS=( 5.3 )

DEPEND="
	>=app-crypt/mit-krb5-1.7-r100[openldap]
	>=dev-libs/cyrus-sasl-2.1.19:2[kerberos]
	>=dev-libs/icu-60.2:=
	dev-libs/nspr
	>=dev-libs/nss-3.22[utils]
	dev-libs/libevent:=
	dev-libs/libpcre:3
	dev-libs/openssl:0=
	>=net-analyzer/net-snmp-5.1.2:=
	net-nds/openldap:=[sasl]
	|| (
		$(for slot in ${BERKDB_SLOTS[@]} ; do printf '%s\n' "sys-libs/db:${slot}" ; done)
	)
	sys-libs/cracklib
	|| ( sys-fs/e2fsprogs sys-libs/e2fsprogs-libs )
	pam-passthru? ( sys-libs/pam )
	selinux? (
		$(python_gen_cond_dep '
			sys-libs/libselinux[python,${PYTHON_USEDEP}]
		')
	)
	systemd? ( >=sys-apps/systemd-244 )
	virtual/libcrypt:=
	"

BDEPEND=">=sys-devel/autoconf-2.69-r5
	virtual/pkgconfig
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/argparse-manpage[${PYTHON_USEDEP}]
	')
	doc? ( app-doc/doxygen )
	test? ( dev-util/cmocka )
"

# perl dependencies are for logconv.pl
RDEPEND="${DEPEND}
	!net-nds/389-ds-base:2.1
	acct-user/dirsrv
	acct-group/dirsrv
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyasn1[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		dev-python/argcomplete[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/python-ldap[sasl,${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
	')
	virtual/perl-Archive-Tar
	virtual/perl-DB_File
	virtual/perl-IO
	virtual/perl-Getopt-Long
	virtual/perl-IO-Compress
	virtual/perl-MIME-Base64
	virtual/perl-Scalar-List-Utils
	virtual/perl-Time-Local
	virtual/logger
	selinux? ( sec-policy/selinux-dirsrv )
"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}/${PN}-db-gentoo.patch"
)

distutils_enable_tests pytest

src_prepare() {
	# https://github.com/389ds/389-ds-base/issues/4292
	if use !systemd; then
		sed -i \
			-e 's|WITH_SYSTEMD = 1|WITH_SYSTEMD = 0|' \
			Makefile.am || die
	fi

	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable accountpolicy acctpolicy)
		$(use_enable bitwise)
		$(use_enable dna)
		$(use_enable pam-passthru)
		$(use_enable autobind)
		$(use_enable auto-dn-suffix)
		$(use_enable debug)
		$(use_enable ldapi)
		$(use_with selinux)
		$(use_with systemd)
		$(use_with systemd systemdgroupname "dirsrv.target")
		$(use_with systemd tmpfiles-d "/usr/lib/tmpfiles.d")
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_with !systemd initddir "/etc/init.d")
		$(use_enable test cmocka)
		--enable-rust
		--enable-rust-offline
		--with-pythonexec="${PYTHON}"
		--with-fhs
		--with-openldap
		--with-db-inc="$(db_includedir)"
		--disable-cockpit
	)

	econf "${myeconfargs[@]}"

	rm "${S}"/.cargo/config || die
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"

	default

	if use doc; then
		doxygen "${S}"/docs/slapi.doxy || die
	fi

	cd "${S}"/src/lib389 || die
	distutils-r1_src_compile

	# argparse-manpage dynamic man pages have hardcoded man v1 in header
	sed -i \
		"1s/\"1\"/\"8\"/" \
		"${S}"/src/lib389/man/{openldap_to_ds,ds{conf,ctl,idm,create}}.8 || die
}

src_test () {
	emake check
	cd "${S}"/src/lib389 || die
	distutils-r1_src_test
}

src_install() {
	# -j1 is a temporary workaround for bug #605432
	emake -j1 DESTDIR="${D}" install

	# Install gentoo style init script
	# Get these merged upstream
	newinitd "${FILESDIR}"/389-ds.initd-r1 389-ds
	newinitd "${FILESDIR}"/389-ds-snmp.initd 389-ds-snmp

	dotmpfiles "${FILESDIR}"/389-ds-base.conf

	# cope with libraries being in /usr/lib/dirsrv
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/dirsrv" > "${ED}"/etc/env.d/08dirsrv || die

	if use doc; then
		cd "${S}" || die
		docinto html/
		dodoc -r html/.
	fi

	cd "${S}"/src/lib389 || die
	distutils-r1_src_install
	python_fix_shebang "${ED}"

	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
}

pkg_postinst() {
	tmpfiles_process 389-ds-base.conf

	echo
	elog "If you are planning to use 389-ds-snmp (ldap-agent),"
	elog "make sure to properly configure: /etc/dirsrv/config/ldap-agent.conf"
	elog "adding proper 'server' entries, and adding the lines below to"
	elog " => /etc/snmp/snmpd.conf"
	elog
	elog "master agentx"
	elog "agentXSocket /var/agentx/master"
	elog
	elog "To start 389 Directory Server (LDAP service) at boot:"
	elog
	elog "    rc-update add 389-ds default"
	elog
	echo
}
