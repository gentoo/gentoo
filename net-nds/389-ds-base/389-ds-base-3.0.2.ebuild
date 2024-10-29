# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	ahash@0.7.7
	atty@0.2.14
	autocfg@1.1.0
	backtrace@0.3.69
	base64@0.13.1
	bitflags@1.3.2
	bitflags@2.4.2
	byteorder@1.5.0
	cbindgen@0.26.0
	cc@1.0.83
	cfg-if@1.0.0
	clap@3.2.25
	clap_lex@0.2.4
	concread@0.2.21
	crossbeam-channel@0.5.11
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.11
	crossbeam-utils@0.8.19
	crossbeam@0.8.4
	errno@0.3.8
	fastrand@2.0.1
	fernet@0.1.4
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	getrandom@0.2.12
	gimli@0.28.1
	hashbrown@0.12.3
	heck@0.4.1
	hermit-abi@0.1.19
	indexmap@1.9.3
	instant@0.1.12
	itoa@1.0.10
	jobserver@0.1.27
	libc@0.2.152
	linux-raw-sys@0.4.13
	lock_api@0.4.11
	log@0.4.20
	lru@0.7.8
	memchr@2.7.1
	miniz_oxide@0.7.1
	object@0.32.2
	once_cell@1.19.0
	openssl-macros@0.1.1
	openssl-sys@0.9.99
	openssl@0.10.63
	os_str_bytes@6.6.1
	parking_lot@0.11.2
	parking_lot_core@0.8.6
	paste-impl@0.1.18
	paste@0.1.18
	pin-project-lite@0.2.13
	pkg-config@0.3.29
	ppv-lite86@0.2.17
	proc-macro-hack@0.5.20+deprecated
	proc-macro2@1.0.78
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.2.16
	redox_syscall@0.4.1
	rustc-demangle@0.1.23
	rustix@0.38.30
	ryu@1.0.16
	scopeguard@1.2.0
	serde@1.0.196
	serde_derive@1.0.196
	serde_json@1.0.113
	smallvec@1.13.1
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.48
	tempfile@3.9.0
	termcolor@1.4.1
	textwrap@0.16.0
	tokio-macros@2.2.0
	tokio@1.35.1
	toml@0.5.11
	unicode-ident@1.0.12
	uuid@0.8.2
	vcpkg@0.2.15
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.52.0
	zeroize@1.7.0
	zeroize_derive@1.4.2
"

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit autotools cargo distutils-r1 readme.gentoo-r1 systemd tmpfiles

DESCRIPTION="389 Directory Server (core libraries and daemons)"
HOMEPAGE="https://directory.fedoraproject.org/"
SRC_URI="
	https://github.com/389ds/${PN}/archive/refs/tags/${P}.tar.gz
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD MIT MPL-2.0 Unicode-DFS-2016"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE_PLUGINS="+accountpolicy +bitwise +dna +pam-passthru"
IUSE="${IUSE_PLUGINS} +autobind auto-dn-suffix debug doc +ldapi selinux systemd"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# lib389 tests (which is most of the suite) can't find their own modules.
RESTRICT="test"

# Do not add any AGPL-3 BDB here!
# See bug 525110, comment 15.
DEPEND="
	>=app-crypt/mit-krb5-1.7-r100[openldap]
	dev-db/lmdb:=
	>=dev-libs/cyrus-sasl-2.1.19:2[kerberos]
	dev-libs/json-c:=
	>=dev-libs/icu-60.2:=
	dev-libs/nspr
	>=dev-libs/nss-3.22[utils]
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

BDEPEND=">=dev-build/autoconf-2.69-r5
	virtual/pkgconfig
	>=virtual/rust-1.70
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/argparse-manpage[${PYTHON_USEDEP}]
	')
	doc? ( app-text/doxygen )
	test? ( dev-util/cmocka )
"

# perl dependencies are for logconv.pl
RDEPEND="${DEPEND}
	acct-user/dirsrv
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyasn1[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		dev-python/argcomplete[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
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
		$(use_with !systemd initddir "/etc/init.d")
		$(use_with systemd)
		$(use_enable test cmocka)
		--with-systemdgroupname="dirsrv.target"
		--with-tmpfiles-d="${EPREFIX}/usr/lib/tmpfiles.d"
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
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

	emake src/lib389/setup.py
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

	# wheel installs this in site-packages/usr..
	local misplaced_usr="${D}/usr/lib/${EPYTHON}/site-packages/usr"
	mkdir -p "${ED}"/usr/libexec/dirsrv
	mv "${misplaced_usr}/libexec/dirsrv/dscontainer" "${ED}"/usr/libexec/dirsrv
	mv "${misplaced_usr}/sbin/openldap_to_ds" "${ED}"/usr/sbin
	mv "${misplaced_usr}/sbin/dsconf" "${ED}"/usr/sbin
	mv "${misplaced_usr}/sbin/dsctl" "${ED}"/usr/sbin
	mv "${misplaced_usr}/sbin/dsidm" "${ED}"/usr/sbin
	mv "${misplaced_usr}/sbin/dscreate" "${ED}"/usr/sbin
	mv "${misplaced_usr}/share/man/man8/openldap_to_ds.8" "${ED}"/usr/share/man/man8
	mv "${misplaced_usr}/share/man/man8/dsconf.8" "${ED}"/usr/share/man/man8
	mv "${misplaced_usr}/share/man/man8/dsctl.8" "${ED}"/usr/share/man/man8
	mv "${misplaced_usr}/share/man/man8/dsidm.8" "${ED}"/usr/share/man/man8
	mv "${misplaced_usr}/share/man/man8/dscreate.8" "${ED}"/usr/share/man/man8
	rm -d "${misplaced_usr}"/share/man/man8 || die
	rm -d "${misplaced_usr}"/share/man || die
	rm -d "${misplaced_usr}"/libexec/dirsrv || die
	rm -d "${misplaced_usr}"/{libexec,sbin,share} || die
	rm -d "${misplaced_usr}" || die

	python_fix_shebang "${ED}"
	python_optimize

	readme.gentoo_create_doc

	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
}

pkg_postinst() {
	tmpfiles_process 389-ds-base.conf

	readme.gentoo_print_elog
}
