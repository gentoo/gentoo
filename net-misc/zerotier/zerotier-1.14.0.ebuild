# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	ahash@0.8.11
	aho-corasick@1.1.2
	allocator-api2@0.2.16
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	ansi_term@0.12.1
	anstyle@1.0.6
	anyhow@1.0.81
	async-stream-impl@0.3.5
	async-stream@0.3.5
	async-trait@0.1.78
	atty@0.2.14
	autocfg@1.1.0
	axum-core@0.3.4
	axum@0.6.20
	backoff@0.4.0
	backtrace@0.3.69
	base16ct@0.2.0
	base64@0.13.1
	base64@0.21.7
	base64ct@1.6.0
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	bumpalo@3.15.4
	byteorder@1.5.0
	bytes@1.5.0
	cbindgen@0.20.0
	cc@1.0.90
	cfg-if@1.0.0
	chrono@0.4.35
	clap@2.34.0
	const-oid@0.9.6
	convert_case@0.4.0
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	cpufeatures@0.2.12
	crossbeam-channel@0.5.12
	crossbeam-queue@0.3.11
	crossbeam-utils@0.8.19
	crypto-bigint@0.5.5
	crypto-common@0.1.6
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.2
	darling@0.20.8
	darling_core@0.20.8
	darling_macro@0.20.8
	dashmap@5.5.3
	der@0.7.8
	deranged@0.3.11
	derive_builder@0.20.0
	derive_builder_core@0.20.0
	derive_builder_macro@0.20.0
	derive_more@0.99.17
	digest@0.10.7
	downcast@0.11.0
	dyn-clone@1.0.17
	ecdsa@0.16.9
	ed25519-dalek@2.1.1
	ed25519@2.2.3
	either@1.10.0
	elliptic-curve@0.13.8
	encoding_rs@0.8.33
	enum-iterator-derive@1.3.0
	enum-iterator@2.0.0
	enum_dispatch@0.3.12
	equivalent@1.0.1
	erased-serde@0.4.4
	errno@0.3.8
	fastrand@2.0.1
	ff@0.13.0
	fiat-crypto@0.2.6
	fixedbitset@0.4.2
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.1
	fragile@2.0.0
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-retry@0.6.0
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-timer@3.0.3
	futures-util@0.3.30
	futures@0.3.30
	generic-array@0.14.7
	getrandom@0.2.12
	gimli@0.28.1
	governor@0.6.3
	group@0.13.0
	h2@0.3.25
	hashbrown@0.12.3
	hashbrown@0.14.3
	heck@0.3.3
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.3.9
	hex@0.4.3
	hkdf@0.12.4
	hmac@0.12.1
	home@0.5.9
	http-body@0.4.6
	http@0.2.12
	httparse@1.8.0
	httpdate@1.0.3
	hyper-timeout@0.4.1
	hyper-tls@0.5.0
	hyper@0.14.28
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	ident_case@1.0.1
	idna@0.5.0
	indexmap@1.9.3
	indexmap@2.2.5
	instant@0.1.12
	inventory@0.3.15
	ipnet@2.9.0
	itertools@0.10.5
	itertools@0.11.0
	itertools@0.12.1
	itoa@1.0.10
	js-sys@0.3.69
	lazy_static@1.4.0
	libc@0.2.153
	libm@0.2.8
	linux-raw-sys@0.4.13
	lock_api@0.4.11
	log@0.4.21
	lru@0.12.3
	matchers@0.1.0
	matchit@0.7.3
	memchr@2.7.1
	mime@0.3.17
	miniz_oxide@0.7.2
	mio@0.8.11
	mockall@0.12.1
	mockall_derive@0.12.1
	multimap@0.8.3
	native-tls@0.2.11
	no-std-compat@0.4.1
	nonzero_ext@0.3.0
	nu-ansi-term@0.46.0
	num-bigint-dig@0.8.4
	num-conv@0.1.0
	num-integer@0.1.46
	num-iter@0.1.44
	num-traits@0.2.18
	num_cpus@1.16.0
	oauth2@4.4.2
	object@0.32.2
	once_cell@1.19.0
	openidconnect@3.5.0
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.101
	openssl@0.10.64
	opentelemetry@0.22.0
	ordered-float@2.10.1
	overload@0.1.1
	p256@0.13.2
	p384@0.13.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	pem-rfc7468@0.7.0
	percent-encoding@2.3.1
	petgraph@0.6.4
	pin-project-internal@1.1.5
	pin-project-lite@0.2.13
	pin-project@1.1.5
	pin-utils@0.1.0
	pkcs1@0.7.5
	pkcs8@0.10.2
	pkg-config@0.3.30
	platforms@3.3.0
	portable-atomic@1.6.0
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	prettyplease@0.2.16
	primeorder@0.13.6
	proc-macro2@1.0.79
	prometheus@0.13.3
	prost-build@0.12.3
	prost-derive@0.12.3
	prost-types@0.12.3
	prost-wkt-build@0.5.0
	prost-wkt-types@0.5.0
	prost-wkt@0.5.0
	prost@0.12.3
	protobuf@2.28.0
	quanta@0.12.2
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	raw-cpuid@11.0.1
	redox_syscall@0.4.1
	regex-automata@0.1.10
	regex-automata@0.4.6
	regex-syntax@0.6.29
	regex-syntax@0.8.2
	regex@1.10.3
	reqwest@0.11.26
	rfc6979@0.4.0
	ring@0.17.8
	ringbuf@0.3.3
	rsa@0.9.6
	rustc-demangle@0.1.23
	rustc_version@0.4.0
	rustix@0.38.31
	rustls-native-certs@0.7.0
	rustls-pemfile@1.0.4
	rustls-pemfile@2.1.1
	rustls-pki-types@1.3.1
	rustls-webpki@0.102.2
	rustls@0.22.2
	rustversion@1.0.14
	ryu@1.0.17
	schannel@0.1.23
	scopeguard@1.2.0
	sec1@0.7.3
	security-framework-sys@2.9.1
	security-framework@2.9.2
	semver@1.0.22
	serde-value@0.7.0
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	serde_path_to_error@0.1.16
	serde_plain@1.0.2
	serde_urlencoded@0.7.1
	serde_with@3.7.0
	serde_with_macros@3.7.0
	sha2@0.10.8
	sharded-slab@0.1.7
	signal-hook-registry@1.4.1
	signature@2.2.0
	siphasher@1.0.1
	slab@0.4.9
	slotmap@1.0.7
	smallvec@1.13.1
	socket2@0.5.6
	spin@0.5.2
	spin@0.9.8
	spinning_top@0.3.0
	spki@0.7.3
	strsim@0.10.0
	strsim@0.8.0
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.53
	sync_wrapper@0.1.2
	system-configuration-sys@0.5.0
	system-configuration@0.5.1
	tempfile@3.10.1
	termtree@0.4.1
	textwrap@0.11.0
	thiserror-impl@1.0.58
	thiserror@1.0.58
	thread_local@1.1.8
	time-core@0.1.2
	time-macros@0.2.17
	time@0.3.34
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-io-timeout@1.2.0
	tokio-macros@2.2.0
	tokio-native-tls@0.3.1
	tokio-rustls@0.25.0
	tokio-stream@0.1.15
	tokio-util@0.7.10
	tokio@1.36.0
	toml@0.5.11
	tonic-build@0.11.0
	tonic@0.11.0
	tower-layer@0.3.2
	tower-service@0.3.2
	tower@0.4.13
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	tracing@0.1.40
	try-lock@0.2.5
	typenum@1.17.0
	typetag-impl@0.2.16
	typetag@0.2.16
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-segmentation@1.11.0
	unicode-width@0.1.11
	untrusted@0.9.0
	url@2.5.0
	urlencoding@2.1.3
	uuid@1.8.0
	valuable@0.1.0
	vcpkg@0.2.15
	vec_map@0.8.2
	version_check@0.9.4
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	web-sys@0.3.69
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.4
	winreg@0.50.0
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
	zeroize@1.7.0
"

declare -A GIT_CRATES=(
	[jwt]='https://github.com/glimberg/rust-jwt;61a9291fdeec747c6edf14f4fa0caf235136c168;rust-jwt-%commit%'
	[rustfsm]='https://github.com/temporalio/sdk-core;4840a9c570fa3388e190e20f01f61065d0b7e965;sdk-core-%commit%/fsm'
	[rustfsm_procmacro]='https://github.com/temporalio/sdk-core;4840a9c570fa3388e190e20f01f61065d0b7e965;sdk-core-%commit%/fsm/rustfsm_procmacro'
	[rustfsm_trait]='https://github.com/temporalio/sdk-core;4840a9c570fa3388e190e20f01f61065d0b7e965;sdk-core-%commit%/fsm/rustfsm_trait'
	[temporal-client]='https://github.com/temporalio/sdk-core;4840a9c570fa3388e190e20f01f61065d0b7e965;sdk-core-%commit%/client'
	[temporal-sdk-core-api]='https://github.com/temporalio/sdk-core;4840a9c570fa3388e190e20f01f61065d0b7e965;sdk-core-%commit%/core-api'
	[temporal-sdk-core-protos]='https://github.com/temporalio/sdk-core;4840a9c570fa3388e190e20f01f61065d0b7e965;sdk-core-%commit%/sdk-core-protos'
	[temporal-sdk-core]='https://github.com/temporalio/sdk-core;4840a9c570fa3388e190e20f01f61065d0b7e965;sdk-core-%commit%/core'
	[temporal-sdk]='https://github.com/temporalio/sdk-core;4840a9c570fa3388e190e20f01f61065d0b7e965;sdk-core-%commit%/sdk'
)

inherit cargo systemd toolchain-funcs

DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
HOMEPAGE="https://www.zerotier.com/"
SRC_URI="
	https://github.com/zerotier/ZeroTierOne/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	sso? (
		${CARGO_CRATE_URIS}
	)
"
S="${WORKDIR}"/ZeroTierOne-${PV}

LICENSE="BUSL-1.1"
# Crate licenses
LICENSE+=" sso? ( Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="cpu_flags_arm_neon debug sso"

RDEPEND="
	dev-libs/openssl:=
	net-libs/libnatpmp
	>=net-libs/miniupnpc-2:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sso? (
		virtual/rust
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.14.0-respect-ldflags.patch
	"${FILESDIR}"/${PN}-1.10.1-add-armv7a-support.patch
	"${FILESDIR}"/${PN}-1.12.2-noexecstack.patch
)

DOCS=( README.md AUTHORS.md )

src_unpack() {
	unpack ${P}.tar.gz
	use sso && cargo_src_unpack
}

src_prepare() {
	default

	#1. Dont call cargo, we'll run it with cargo eclass functions
	#2. Remove man page compression and install, we'll handle it with ebuild functions
	#3. Gentoo generates target specific build dirs now bug #937782
	sed -i \
		-e '/ifeq ($(ZT_SSO_SUPPORTED)/,/endif/ { /cargo build/d }' \
		-e '/install:/,/^$/ { /man[0-9]/d }' \
		-e "s|rustybits/target/$(usex debug debug release)|rustybits/$(cargo_target_dir)|" \
		make-linux.mk || die
}

src_configure() {
	tc-export CXX CC

	use cpu_flags_arm_neon || export ZT_DISABLE_NEON=1

	use sso && cargo_src_configure
}

src_compile() {
	#TODO: New rusty bit smeeclient isnt built
	myemakeargs=(
		CXX="${CXX}"
		STRIP=:

		# Debug doesnt do more than add preprocessor arguments normally,
		# but when rust is used it sets the correct rust directory to link against.
		# It would be added by cargo eclass eitherway, so instead of adding REQUIRED_USE
		# and patching the makefile its just easier to have it.
		ZT_DEBUG="$(usex debug 1 0)"
		ZT_SSO_SUPPORTED="$(usex sso 1 0)"
	)

	pushd rustybits/zeroidc > /dev/null || die
	use sso && cargo_src_compile
	popd > /dev/null || die

	emake "${myemakeargs[@]}" one
}

src_test() {
	emake "${myemakeargs[@]}" selftest
	./zerotier-selftest || die
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}".init-r1 "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service

	doman doc/zerotier-{cli.1,idtool.1,one.8}
}
