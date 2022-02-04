# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.14.0
	adler-0.2.3
	aead-0.3.2
	ahash-0.4.7
	aho-corasick-0.7.15
	ansi_term-0.11.0
	anyhow-1.0.35
	arrayref-0.3.6
	arrayvec-0.5.2
	ascii-canvas-2.0.0
	assert_cli-0.6.3
	atty-0.2.14
	autocfg-0.1.7
	autocfg-1.0.1
	backtrace-0.3.55
	base64-0.13.0
	bindgen-0.51.1
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.2.1
	blake2b_simd-0.5.11
	block-buffer-0.7.3
	block-buffer-0.9.0
	block-padding-0.1.5
	byte-tools-0.3.1
	byteorder-1.3.4
	bytes-0.5.6
	bzip2-0.4.1
	bzip2-sys-0.1.9+1.0.8
	capnp-0.13.6
	capnp-futures-0.13.1
	capnp-rpc-0.13.1
	capnpc-0.13.1
	cc-1.0.66
	cexpr-0.3.6
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	cipher-0.2.5
	clang-sys-0.28.1
	clap-2.33.3
	cmac-0.5.1
	colored-1.9.3
	constant_time_eq-0.1.5
	core-foundation-0.9.1
	core-foundation-sys-0.8.2
	cpuid-bool-0.1.2
	crc32fast-1.2.1
	crossbeam-utils-0.8.1
	crypto-mac-0.10.0
	ctor-0.1.16
	ctr-0.6.0
	curve25519-dalek-3.0.0
	dbl-0.3.0
	diff-0.1.12
	difference-2.0.0
	digest-0.8.1
	digest-0.9.0
	dirs-1.0.5
	dirs-2.0.2
	dirs-sys-0.3.5
	doc-comment-0.3.3
	docopt-1.1.0
	dyn-clone-1.0.3
	eax-0.3.0
	ed25519-1.0.3
	ed25519-dalek-1.0.1
	either-1.6.1
	ena-0.14.0
	environment-0.1.1
	failure-0.1.8
	failure_derive-0.1.8
	fake-simd-0.1.2
	fallible-iterator-0.2.0
	fallible-streaming-iterator-0.1.9
	filetime-0.2.13
	fixedbitset-0.2.0
	flate2-1.0.19
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.0
	fs2-0.4.3
	fuchsia-zircon-0.3.3
	fuchsia-zircon-sys-0.3.3
	futures-0.3.8
	futures-channel-0.3.8
	futures-core-0.3.8
	futures-executor-0.3.8
	futures-io-0.3.8
	futures-macro-0.3.8
	futures-sink-0.3.8
	futures-task-0.3.8
	futures-util-0.3.8
	generic-array-0.12.3
	generic-array-0.14.4
	getrandom-0.1.15
	gimli-0.23.0
	glob-0.3.0
	h2-0.2.7
	hashbrown-0.9.1
	hashlink-0.6.0
	hermit-abi-0.1.17
	http-0.2.1
	http-body-0.3.1
	httparse-1.3.4
	httpdate-0.3.2
	hyper-0.13.9
	hyper-tls-0.4.3
	idna-0.2.0
	indexmap-1.6.0
	iovec-0.1.4
	itertools-0.9.0
	itoa-0.4.6
	kernel32-sys-0.2.2
	lalrpop-0.19.1
	lalrpop-util-0.19.1
	lazy_static-1.4.0
	libc-0.2.81
	libloading-0.5.2
	libm-0.2.1
	libsqlite3-sys-0.20.1
	log-0.4.11
	matches-0.1.8
	memchr-2.3.4
	memsec-0.6.0
	miniz_oxide-0.4.3
	mio-0.6.23
	mio-named-pipes-0.1.7
	mio-uds-0.6.8
	miow-0.2.2
	miow-0.3.6
	native-tls-0.2.6
	net2-0.2.37
	nettle-7.0.0
	nettle-src-3.5.1-2
	nettle-sys-2.0.4
	new_debug_unreachable-1.0.4
	nom-4.2.3
	num-bigint-dig-0.6.1
	num-integer-0.1.44
	num-iter-0.1.42
	num-traits-0.2.14
	num_cpus-1.13.0
	object-0.22.0
	once_cell-1.5.2
	opaque-debug-0.2.3
	opaque-debug-0.3.0
	openssl-0.10.31
	openssl-probe-0.1.2
	openssl-sys-0.9.59
	peeking_take_while-0.1.2
	percent-encoding-2.1.0
	petgraph-0.5.1
	phf_shared-0.8.0
	pin-project-0.4.27
	pin-project-1.0.2
	pin-project-internal-0.4.27
	pin-project-internal-1.0.2
	pin-project-lite-0.1.11
	pin-project-lite-0.2.0
	pin-utils-0.1.0
	pkg-config-0.3.19
	ppv-lite86-0.2.10
	precomputed-hash-0.1.1
	proc-macro-hack-0.5.19
	proc-macro-nested-0.1.6
	proc-macro2-1.0.24
	quickcheck-0.9.2
	quote-1.0.7
	rand-0.7.3
	rand_chacha-0.2.2
	rand_core-0.5.1
	rand_hc-0.2.0
	redox_syscall-0.1.57
	redox_users-0.3.5
	regex-1.4.2
	regex-syntax-0.6.21
	remove_dir_all-0.5.3
	rpassword-5.0.0
	rusqlite-0.24.2
	rust-argon2-0.8.3
	rustc-demangle-0.1.18
	rustc-hash-1.1.0
	ryu-1.0.5
	schannel-0.1.19
	security-framework-2.0.0
	security-framework-sys-2.0.0
	serde-1.0.118
	serde_derive-1.0.118
	serde_json-1.0.60
	sha1collisiondetection-0.2.3
	sha2-0.8.2
	sha2-0.9.2
	shlex-0.1.1
	signal-hook-registry-1.2.2
	signature-1.2.2
	siphasher-0.3.3
	slab-0.4.2
	smallvec-1.6.1
	socket2-0.3.17
	spin-0.5.2
	string_cache-0.8.1
	strsim-0.8.0
	strsim-0.9.3
	subtle-2.3.0
	syn-1.0.54
	synstructure-0.12.4
	tempfile-3.1.0
	term-0.5.2
	term_size-0.3.2
	textwrap-0.11.0
	thiserror-1.0.22
	thiserror-impl-1.0.22
	thread_local-1.0.1
	time-0.1.44
	tinyvec-1.1.0
	tinyvec_macros-0.1.0
	tokio-0.2.24
	tokio-macros-0.2.6
	tokio-tls-0.3.1
	tokio-util-0.3.1
	tower-service-0.3.0
	tracing-0.1.22
	tracing-core-0.1.17
	tracing-futures-0.2.4
	try-lock-0.2.3
	typenum-1.12.0
	unicode-bidi-0.3.4
	unicode-normalization-0.1.16
	unicode-width-0.1.8
	unicode-xid-0.2.1
	url-2.2.0
	vcpkg-0.2.11
	vec_map-0.8.2
	version_check-0.1.5
	version_check-0.9.2
	want-0.3.0
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.10.0+wasi-snapshot-preview1
	win-crypto-ng-0.4.0
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	ws2_32-sys-0.2.1
	zbase32-0.1.2
	zeroize-1.2.0
	zeroize_derive-1.0.1
"

inherit bash-completion-r1 cargo

DESCRIPTION="CLI of the Sequoia OpenPGP implementation"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia"

SRC_URI="
	https://gitlab.com/sequoia-pgp/sequoia/-/archive/sq/v${PV}/${PN}-v${PV}.tar.bz2
	$(cargo_crate_uris)
"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 GPL-2 GPL-2+ GPL-3 GPL-3+ ISC LGPL-2+ LGPL-3 LGPL-3+ MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

S="${WORKDIR}/${PN}-v${PV}"

QA_FLAGS_IGNORED="usr/bin/sq"

COMMON_DEPEND="
	dev-libs/gmp:=
	dev-libs/nettle:=
	dev-libs/openssl:=
"

DEPEND="
	sys-devel/clang
	${COMMON_DEPEND}
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_compile() {
	cd sq || die
	# Setting CARGO_TARGET_DIR is required to have the build system
	# create the bash and zsh completion files.
	CARGO_TARGET_DIR="${S}/target" cargo_src_compile
}

src_test() {
	cd sq || die
	cargo_src_test
}

src_install() {
	cargo_src_install --path sq

	doman sq/man-sq-net-autocrypt/*

	newbashcomp target/sq.bash sq

	insinto /usr/share/zsh/site-functions
	doins target/_sq

	insinto /usr/share/fish/vendor_completions.d
	doins target/sq.fish
}
