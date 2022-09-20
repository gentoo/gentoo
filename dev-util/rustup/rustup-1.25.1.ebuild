# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	aead-0.3.2
	aes-0.6.0
	aes-soft-0.6.4
	aesni-0.10.0
	aho-corasick-0.7.18
	ansi_term-0.12.1
	anyhow-1.0.57
	ascii-canvas-3.0.0
	async-compression-0.3.14
	atty-0.2.14
	autocfg-0.1.8
	autocfg-1.1.0
	base64-0.13.0
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.3.2
	bitvec-0.20.4
	block-buffer-0.9.0
	block-buffer-0.10.2
	block-modes-0.7.0
	block-padding-0.2.1
	blowfish-0.7.0
	bstr-0.2.17
	buffered-reader-1.1.2
	bumpalo-3.10.0
	byteorder-1.4.3
	bytes-1.1.0
	cast5-0.9.0
	cc-1.0.73
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	cipher-0.2.5
	clap-2.34.0
	cmac-0.5.1
	const-oid-0.5.2
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	cpufeatures-0.2.2
	crc32fast-1.3.2
	crossbeam-channel-0.5.4
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.8
	crossbeam-utils-0.8.8
	crunchy-0.2.2
	crypto-common-0.1.3
	crypto-mac-0.10.1
	crypto-mac-0.11.1
	ctr-0.6.0
	curl-0.4.43
	curl-sys-0.4.55+curl-7.83.1
	curve25519-dalek-3.2.1
	dbl-0.3.2
	der-0.3.5
	des-0.6.0
	diff-0.1.12
	digest-0.9.0
	digest-0.10.3
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	dyn-clone-1.0.5
	eax-0.3.0
	ecdsa-0.11.1
	ed25519-1.5.2
	ed25519-dalek-1.0.1
	effective-limits-0.5.4
	either-1.6.1
	elliptic-curve-0.9.12
	ena-0.14.0
	encoding_rs-0.8.31
	enum-map-2.3.0
	enum-map-derive-0.9.0
	env_proxy-0.4.1
	fastrand-1.7.0
	ff-0.9.0
	filetime-0.2.16
	fixedbitset-0.4.1
	flate2-1.0.24
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	funty-1.1.0
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-io-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	generic-array-0.14.5
	getrandom-0.1.16
	getrandom-0.2.6
	git-testament-0.2.1
	git-testament-derive-0.1.13
	group-0.9.0
	h2-0.3.13
	hashbrown-0.11.2
	hermit-abi-0.1.19
	hmac-0.11.0
	http-0.2.7
	http-body-0.4.5
	httparse-1.7.1
	httpdate-1.0.2
	hyper-0.14.19
	hyper-rustls-0.23.0
	hyper-tls-0.5.0
	idea-0.3.0
	idna-0.2.3
	indexmap-1.8.2
	instant-0.1.12
	ipnet-2.5.0
	itertools-0.10.3
	itoa-1.0.2
	jobserver-0.1.24
	js-sys-0.3.57
	lalrpop-0.19.8
	lalrpop-util-0.19.8
	lazy_static-1.4.0
	libc-0.2.126
	libm-0.2.2
	libz-sys-1.1.8
	lock_api-0.4.7
	log-0.4.17
	lzma-sys-0.1.17
	matches-0.1.9
	md-5-0.9.1
	memchr-2.5.0
	memoffset-0.6.5
	memsec-0.6.2
	mime-0.3.16
	miniz_oxide-0.5.3
	mio-0.8.3
	native-tls-0.2.10
	new_debug_unreachable-1.0.4
	no-std-compat-0.4.1
	num-bigint-0.2.6
	num-bigint-dig-0.6.1
	num-integer-0.1.45
	num-iter-0.1.43
	num-traits-0.2.15
	num_cpus-1.13.1
	num_threads-0.1.6
	once_cell-1.12.0
	opaque-debug-0.3.0
	opener-0.5.0
	openssl-0.10.40
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-src-111.20.0+1.1.1o
	openssl-sys-0.9.74
	p256-0.8.1
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	pem-0.8.3
	percent-encoding-2.1.0
	petgraph-0.6.2
	phf_shared-0.10.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkcs8-0.6.1
	pkg-config-0.3.25
	ppv-lite86-0.2.16
	precomputed-hash-0.1.1
	proc-macro2-1.0.39
	pulldown-cmark-0.8.0
	quote-1.0.18
	radium-0.6.2
	rand-0.7.3
	rand-0.8.5
	rand_chacha-0.2.2
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.3
	rand_hc-0.2.0
	rayon-1.5.3
	rayon-core-1.9.3
	redox_syscall-0.2.13
	redox_users-0.4.3
	regex-1.5.6
	regex-automata-0.1.10
	regex-syntax-0.6.26
	remove_dir_all-0.5.3
	remove_dir_all-0.7.0
	reqwest-0.11.10
	retry-1.3.1
	ring-0.16.20
	ripemd160-0.9.1
	rs_tracing-1.0.1
	rsa-0.3.0
	rustls-0.20.6
	rustls-native-certs-0.6.2
	rustls-pemfile-0.3.0
	rustls-pemfile-1.0.0
	rustversion-1.0.6
	ryu-1.0.10
	same-file-1.0.6
	schannel-0.1.20
	scopeguard-1.1.0
	sct-0.7.0
	security-framework-2.6.1
	security-framework-sys-2.6.1
	semver-1.0.9
	sequoia-openpgp-1.9.0
	serde-1.0.137
	serde_derive-1.0.137
	serde_json-1.0.81
	serde_urlencoded-0.7.1
	sha-1-0.9.8
	sha1collisiondetection-0.2.5
	sha2-0.9.9
	sha2-0.10.2
	sharded-slab-0.1.4
	signature-1.3.2
	simple_asn1-0.4.1
	siphasher-0.3.10
	slab-0.4.6
	smallvec-1.8.0
	socket2-0.4.4
	spin-0.5.2
	spki-0.3.0
	string_cache-0.8.4
	strsim-0.8.0
	strsim-0.10.0
	subtle-2.4.1
	syn-1.0.96
	synstructure-0.12.6
	sys-info-0.9.1
	tap-1.0.1
	tar-0.4.38
	tempfile-3.3.0
	term-0.5.1
	term-0.7.0
	textwrap-0.11.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	threadpool-1.8.1
	time-0.1.43
	time-0.3.9
	time-macros-0.2.4
	tiny-keccak-2.0.2
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	tokio-1.19.0
	tokio-native-tls-0.3.0
	tokio-rustls-0.23.4
	tokio-socks-0.5.1
	tokio-util-0.6.10
	tokio-util-0.7.2
	toml-0.5.9
	tower-service-0.3.1
	tracing-0.1.34
	tracing-attributes-0.1.21
	tracing-core-0.1.26
	try-lock-0.2.3
	twofish-0.5.0
	typenum-1.15.0
	unicase-2.6.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.0
	unicode-normalization-0.1.19
	unicode-width-0.1.9
	unicode-xid-0.2.3
	untrusted-0.7.1
	url-2.2.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	want-0.3.0
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.80
	wasm-bindgen-backend-0.2.80
	wasm-bindgen-futures-0.4.30
	wasm-bindgen-macro-0.2.80
	wasm-bindgen-macro-support-0.2.80
	wasm-bindgen-shared-0.2.80
	web-sys-0.3.57
	webpki-0.22.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	winreg-0.8.0
	winreg-0.10.1
	wyz-0.2.0
	x25519-dalek-1.2.0
	xattr-0.2.3
	xxhash-rust-0.8.5
	xz2-0.1.6
	zeroize-1.3.0
	zeroize_derive-1.3.2
	zstd-0.11.2+zstd.1.5.2
	zstd-safe-5.0.2+zstd.1.5.2
	zstd-sys-2.0.1+zstd.1.5.2
"

inherit bash-completion-r1 cargo prefix

DESCRIPTION="Rust toolchain installer"
HOMEPAGE="https://rust-lang.github.io/rustup/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rust-lang/${PN}.git"
else
	HOME_COMMIT="a243ee2fbee6022c57d56f5aa79aefe194eabe53"
	SRC_URI="https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/rbtcollins/home/archive/${HOME_COMMIT}.tar.gz -> home-${HOME_COMMIT}.tar.gz
		$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 MIT Unlicense ZLIB"
SLOT="0"
IUSE=""

DEPEND="
	app-arch/xz-utils
	net-misc/curl:=[http2,ssl]
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="usr/bin/.*"

# uses network
RESTRICT="test"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	# patch git dep to use pre-fetched tarball
	local home_path="home = { path = '"${WORKDIR}/home-${HOME_COMMIT}"' }"
	sed -i "s@^home =.*@${home_path}@" "${S}/Cargo.toml" || die

	default
}

src_configure() {
	# modeled after ci/run.bash upstream
	# reqwest-rustls-tls requires ring crate, which is not very portable.
	local myfeatures=(
		no-self-update
		curl-backend
		reqwest-backend
		reqwest-default-tls
	)
	case ${ARCH} in
		ppc*|mips*|riscv*|s390*)
			;;
		*) myfeatures+=( reqwest-rustls-tls )
			;;
	esac
	cargo_src_configure --no-default-features
}

src_compile() {
	export OPENSSL_NO_VENDOR=true
	cargo_src_compile
}

src_install() {
	cargo_src_install
	einstalldocs
	newbin "$(prefixify_ro "${FILESDIR}"/symlink_rustup.sh)" rustup-init-gentoo

	ln -s "${ED}/usr/bin/rustup-init" rustup || die
	./rustup completions bash rustup > "${T}/rustup" || die
	./rustup completions zsh rustup > "${T}/_rustup" || die

	dobashcomp "${T}/rustup"

	insinto /usr/share/zsh/site-functions
	doins "${T}/_rustup"
}

pkg_postinst() {
		elog "No rustup toolchains installed by default"
		elog "eselect activated system rust toolchain can be added to rustup by running"
		elog "helper script installed as ${EPREFIX}/usr/bin/rustup-init-gentoo"
		elog "it will create symlinks to system-installed rustup in home directory"
		elog "and rustup updates will be managed by portage"
		elog "please delete current rustup binaries from ~/.cargo/bin/ (if any)"
		elog "before running rustup-init-gentoo"
}
