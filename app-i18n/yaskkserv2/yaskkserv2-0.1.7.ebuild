# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

CRATES="
	addr2line-0.21.0
	adler-1.0.2
	aho-corasick-1.0.5
	atty-0.2.14
	autocfg-1.1.0
	backtrace-0.3.69
	base64-0.21.4
	bincode-1.3.3
	bitflags-1.3.2
	bitflags-2.4.0
	block-buffer-0.10.4
	bumpalo-3.14.0
	bytes-1.5.0
	cc-1.0.83
	cfg-if-1.0.0
	clap-3.2.25
	clap_lex-0.2.4
	core-foundation-0.9.3
	core-foundation-sys-0.8.4
	cpufeatures-0.2.9
	crypto-common-0.1.6
	daemonize-0.5.0
	digest-0.10.7
	encoding_rs-0.8.33
	env_logger-0.7.1
	errno-0.3.3
	errno-dragonfly-0.1.2
	error-chain-0.11.0
	fastrand-2.0.0
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.2.0
	futures-channel-0.3.28
	futures-core-0.3.28
	futures-io-0.3.28
	futures-sink-0.3.28
	futures-task-0.3.28
	futures-util-0.3.28
	generic-array-0.14.7
	getrandom-0.2.10
	gimli-0.28.0
	h2-0.3.21
	hashbrown-0.12.3
	hermit-abi-0.1.19
	hermit-abi-0.3.2
	http-0.2.9
	http-body-0.4.5
	httparse-1.8.0
	httpdate-1.0.3
	humantime-1.3.0
	hyper-0.14.27
	hyper-tls-0.5.0
	idna-0.4.0
	indexmap-1.9.3
	ipnet-2.8.0
	itoa-1.0.9
	js-sys-0.3.64
	json-0.12.4
	lazy_static-1.4.0
	libc-0.2.148
	linux-raw-sys-0.4.7
	log-0.4.20
	memchr-2.6.3
	mime-0.3.17
	miniz_oxide-0.7.1
	mio-0.8.8
	native-tls-0.2.11
	num_cpus-1.16.0
	object-0.32.1
	once_cell-1.18.0
	openssl-0.10.57
	openssl-macros-0.1.1
	openssl-probe-0.1.5
	openssl-sys-0.9.93
	os_str_bytes-6.5.1
	percent-encoding-2.3.0
	pin-project-lite-0.2.13
	pin-utils-0.1.0
	pkg-config-0.3.27
	ppv-lite86-0.2.17
	proc-macro2-1.0.67
	quick-error-1.2.3
	quote-1.0.33
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	redox_syscall-0.3.5
	regex-1.9.5
	regex-automata-0.3.8
	regex-syntax-0.7.5
	reqwest-0.11.20
	rustc-demangle-0.1.23
	rustc-hash-1.1.0
	rustix-0.38.13
	ryu-1.0.15
	schannel-0.1.22
	security-framework-2.9.2
	security-framework-sys-2.9.1
	serde-1.0.188
	serde_derive-1.0.188
	serde_json-1.0.107
	serde_urlencoded-0.7.1
	sha1-0.10.5
	slab-0.4.9
	socket2-0.4.9
	socket2-0.5.4
	strsim-0.10.0
	syn-2.0.33
	syslog-4.0.1
	tempfile-3.8.0
	termcolor-1.2.0
	textwrap-0.16.0
	thiserror-1.0.48
	thiserror-impl-1.0.48
	time-0.1.45
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	tokio-1.32.0
	tokio-native-tls-0.3.1
	tokio-util-0.7.8
	tower-service-0.3.2
	tracing-0.1.37
	tracing-core-0.1.31
	try-lock-0.2.4
	twoway-0.2.2
	typenum-1.16.0
	unchecked-index-0.2.2
	unicode-bidi-0.3.13
	unicode-ident-1.0.12
	unicode-normalization-0.1.22
	url-2.4.1
	vcpkg-0.2.15
	version_check-0.9.4
	want-0.3.1
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.87
	wasm-bindgen-backend-0.2.87
	wasm-bindgen-futures-0.4.37
	wasm-bindgen-macro-0.2.87
	wasm-bindgen-macro-support-0.2.87
	wasm-bindgen-shared-0.2.87
	web-sys-0.3.64
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.48.0
	windows-targets-0.48.5
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_msvc-0.48.5
	windows_i686_gnu-0.48.5
	windows_i686_msvc-0.48.5
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_msvc-0.48.5
	winreg-0.50.0
"
TESTDATA="${PN}-testdata-202110"

inherit cargo systemd

DESCRIPTION="Yet Another SKK server"
HOMEPAGE="https://github.com/wachikun/yaskkserv2"
SRC_URI="https://github.com/wachikun/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
	test? ( https://dev.gentoo.org/~hattya/distfiles/${TESTDATA}.tar.xz )"
RESTRICT="!test? ( test )"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}
	app-i18n/skk-jisyo"
BDEPEND="test? (
	app-emacs/ddskk
	app-i18n/yaskkserv
)"

QA_FLAGS_IGNORED=".*"

src_prepare() {
	default

	sed -i "/^dictionary =/s|= .*|= ${EPREFIX}/usr/lib/${PN}/default.euc|" etc/${PN}.conf
	export OPENSSL_NO_VENDOR=true
	# skip network tests
	sed -i "s/^fn ${PN}.*_google_/#[ignore]\n&/" src/skk/test_unix/${PN}.rs
}

src_test() {
	export YASKKSERV2_TEST_DIRECTORY="${T}"/${PN}
	mkdir -p "${YASKKSERV2_TEST_DIRECTORY}" || die
	cp -r "${WORKDIR}"/${TESTDATA}/* "${YASKKSERV2_TEST_DIRECTORY}" || die
	cargo_src_test
}

src_install() {
	cargo_src_install
	dodir /usr/sbin
	mv "${ED}"/usr/{,s}bin/${PN}    || die
	rm "${ED}"/usr/bin/test_wrapper || die
	einstalldocs

	keepdir /usr/lib/${PN}

	insinto /etc
	doins etc/${PN}.conf

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_preinst() {
	"${ED}"/usr/bin/${PN}_make_dictionary --dictionary-filename "${ED}"/usr/lib/${PN}/default.euc         "${EPREFIX}"/usr/share/skk/SKK-JISYO.L || die
	"${ED}"/usr/bin/${PN}_make_dictionary --dictionary-filename "${ED}"/usr/lib/${PN}/default.utf8 --utf8 "${EPREFIX}"/usr/share/skk/SKK-JISYO.L || die
}
