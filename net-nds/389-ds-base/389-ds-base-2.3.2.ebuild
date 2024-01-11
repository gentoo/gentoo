# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.7.6
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.1
	bitflags-1.3.2
	byteorder-1.4.3
	cbindgen-0.9.1
	cc-1.0.78
	cfg-if-1.0.0
	clap-2.34.0
	concread-0.2.21
	crossbeam-0.8.2
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.13
	crossbeam-queue-0.3.8
	crossbeam-utils-0.8.14
	fastrand-1.8.0
	fernet-0.1.4
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	getrandom-0.2.8
	hashbrown-0.12.3
	hermit-abi-0.1.19
	instant-0.1.12
	itoa-1.0.5
	jobserver-0.1.25
	libc-0.2.139
	lock_api-0.4.9
	log-0.4.17
	lru-0.7.8
	memoffset-0.7.1
	once_cell-1.17.0
	openssl-0.10.45
	openssl-macros-0.1.0
	openssl-sys-0.9.80
	parking_lot-0.11.2
	parking_lot_core-0.8.6
	paste-0.1.18
	paste-impl-0.1.18
	pin-project-lite-0.2.9
	pkg-config-0.3.26
	ppv-lite86-0.2.17
	proc-macro-hack-0.5.20+deprecated
	proc-macro2-1.0.50
	quote-1.0.23
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	redox_syscall-0.2.16
	remove_dir_all-0.5.3
	ryu-1.0.12
	scopeguard-1.1.0
	serde-1.0.152
	serde_derive-1.0.152
	serde_json-1.0.91
	smallvec-1.10.0
	strsim-0.8.0
	syn-1.0.107
	synstructure-0.12.6
	tempfile-3.3.0
	textwrap-0.11.0
	tokio-1.24.1
	tokio-macros-1.8.2
	toml-0.5.10
	unicode-ident-1.0.6
	unicode-width-0.1.10
	unicode-xid-0.2.4
	uuid-0.8.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.4
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.42.1
	zeroize-1.5.7
	zeroize_derive-1.3.3
"

PYTHON_COMPAT=( python3_{9..11} )

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit autotools cargo distutils-r1 readme.gentoo-r1 systemd tmpfiles

DESCRIPTION="389 Directory Server (core libraries and daemons)"
HOMEPAGE="https://directory.fedoraproject.org/"
SRC_URI="
	https://github.com/389ds/${PN}/archive/refs/tags/${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"
LICENSE="GPL-3+ Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE_PLUGINS="+accountpolicy +bitwise +dna +pam-passthru"
IUSE="${IUSE_PLUGINS} +autobind auto-dn-suffix debug doc +ldapi selinux systemd"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# lib389 tests (which is most of the suite) can't find their own modules.
RESTRICT="test"

# Do not add any AGPL-3 BDB here!
# See bug 525110, comment 15.

# dev-libs/libevent: https://github.com/389ds/389-ds-base/pull/5172
DEPEND="
	>=app-crypt/mit-krb5-1.7-r100[openldap]
	dev-db/lmdb:=
	>=dev-libs/cyrus-sasl-2.1.19:2[kerberos]
	dev-libs/json-c:=
	>=dev-libs/icu-60.2:=
	dev-libs/nspr
	>=dev-libs/nss-3.22[utils]
	dev-libs/libevent:=
	dev-libs/libpcre2:=
	dev-libs/openssl:0=
	>=net-analyzer/net-snmp-5.1.2:=
	net-nds/openldap:=[sasl]
	sys-libs/cracklib
	sys-libs/db:5.3
	sys-libs/zlib
	sys-fs/e2fsprogs
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
	doc? ( app-text/doxygen )
	test? ( dev-util/cmocka )
"

# perl dependencies are for logconv.pl
RDEPEND="${DEPEND}
	!net-nds/389-ds-base:1.4
	acct-user/dirsrv
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
	"${FILESDIR}/${PN}-2.3.2-setuptools-67-packaging-23.patch"
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
		--enable-rust-offline
		--with-pythonexec="${PYTHON}"
		--with-fhs
		--with-openldap
		--with-db-inc="${EPREFIX}"/usr/include/db5.3
		--disable-cockpit
	)

	econf "${myeconfargs[@]}"

	rm .cargo/config || die
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"

	default

	if use doc; then
		doxygen docs/slapi.doxy || die
	fi

	pushd src/lib389 &>/dev/null || die
	distutils-r1_src_compile
	popd &>/dev/null || die

	# argparse-manpage dynamic man pages have hardcoded man v1 in header
	sed -i \
		"1s/\"1\"/\"8\"/" \
		src/lib389/man/{openldap_to_ds,ds{conf,ctl,idm,create}}.8 || die
}

src_test () {
	emake check
	cd src/lib389 || die
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
		docinto html/
		dodoc -r html/.
	fi

	pushd src/lib389 &>/dev/null || die
	distutils-r1_src_install
	popd &>/dev/null || die

	python_fix_shebang "${ED}"

	readme.gentoo_create_doc

	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
}

pkg_postinst() {
	tmpfiles_process 389-ds-base.conf

	readme.gentoo_print_elog
}
