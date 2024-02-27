# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	aead@0.5.2
	ahash@0.8.7
	aho-corasick@1.1.2
	allocator-api2@0.2.16
	anstream@0.6.5
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.4
	anyhow@1.0.79
	arc-swap@1.6.0
	argon2@0.5.2
	async-trait@0.1.77
	atoi@2.0.0
	atomic-write-file@0.1.2
	atomic@0.5.3
	autocfg@1.1.0
	axum-core@0.3.4
	axum-server@0.5.1
	axum@0.6.20
	backtrace@0.3.69
	base64@0.13.1
	base64@0.21.5
	base64ct@1.6.0
	beef@0.5.2
	bitflags@1.3.2
	bitflags@2.4.1
	blake2@0.10.6
	blake2@0.9.2
	block-buffer@0.10.4
	block@0.1.6
	bumpalo@3.14.0
	bytecount@0.6.7
	byteorder@1.5.0
	bytes@1.5.0
	cassowary@0.3.0
	cc@1.0.83
	cfg-if@1.0.0
	chacha20@0.8.2
	chacha20@0.9.1
	cipher@0.3.0
	cipher@0.4.4
	clap@4.4.12
	clap_builder@4.4.12
	clap_complete@4.4.6
	clap_derive@4.4.7
	clap_lex@0.6.0
	cli-clipboard@0.4.0
	clipboard-win@4.5.0
	colorchoice@1.0.0
	colored@2.1.0
	config@0.13.4
	console@0.15.7
	const-oid@0.9.6
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	cpufeatures@0.2.11
	crc-catalog@2.4.0
	crc@3.0.1
	crossbeam-epoch@0.9.17
	crossbeam-queue@0.3.10
	crossbeam-utils@0.8.18
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	crypto-common@0.1.6
	crypto-mac@0.8.0
	crypto_secretbox@0.1.1
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.1
	der@0.7.8
	deranged@0.3.11
	derive-new@0.5.9
	diff@0.1.13
	digest@0.10.7
	digest@0.9.0
	directories@5.0.1
	dirs-sys@0.4.1
	dirs@5.0.1
	dotenvy@0.15.7
	downcast-rs@1.2.0
	ed25519-dalek@2.1.0
	ed25519@2.2.3
	either@1.9.0
	encode_unicode@0.3.6
	encoding_rs@0.8.33
	env_logger@0.10.1
	equivalent@1.0.1
	errno@0.3.8
	error-code@2.3.1
	etcetera@0.8.0
	event-listener@2.5.3
	eyre@0.6.11
	fastrand@2.0.1
	fiat-crypto@0.2.5
	filedescriptor@0.8.2
	finl_unicode@1.2.0
	fixedbitset@0.4.2
	flume@0.11.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	fs-err@2.11.0
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-intrusive@0.5.0
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	futures@0.3.30
	fuzzy-matcher@0.3.7
	generic-array@0.14.7
	gethostname@0.2.3
	getrandom@0.2.11
	gimli@0.28.1
	h2@0.3.22
	hashbrown@0.12.3
	hashbrown@0.13.1
	hashbrown@0.14.3
	hashlink@0.8.4
	heck@0.4.1
	hermit-abi@0.3.3
	hex@0.4.3
	hkdf@0.12.4
	hmac@0.12.1
	home@0.5.9
	http-body@0.4.6
	http-range-header@0.3.1
	http@0.2.11
	httparse@1.8.0
	httpdate@1.0.3
	humantime@2.1.0
	hyper-rustls@0.24.2
	hyper@0.14.28
	idna@0.5.0
	indenter@0.3.3
	indexmap@1.9.3
	indexmap@2.1.0
	indicatif@0.17.7
	indoc@2.0.4
	inout@0.1.3
	instant@0.1.12
	interim@0.1.1
	ipnet@2.9.0
	is-terminal@0.4.10
	iso8601@0.4.2
	itertools@0.11.0
	itertools@0.12.0
	itoa@1.0.10
	js-sys@0.3.66
	lazy_static@1.4.0
	libc@0.2.151
	libm@0.2.8
	libredox@0.0.1
	libsqlite3-sys@0.27.0
	linux-raw-sys@0.4.12
	lock_api@0.4.11
	log@0.4.20
	logos-codegen@0.13.0
	logos-derive@0.13.0
	logos@0.13.0
	lru@0.12.1
	mach2@0.4.2
	malloc_buf@0.0.6
	matchers@0.1.0
	matchit@0.7.3
	md-5@0.10.6
	memchr@2.7.1
	memoffset@0.6.5
	metrics-exporter-prometheus@0.12.2
	metrics-macros@0.7.1
	metrics-util@0.15.1
	metrics@0.21.1
	mime@0.3.17
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	minspan@0.1.1
	mio@0.8.10
	nix@0.24.3
	nix@0.27.1
	nom@7.1.3
	nu-ansi-term@0.46.0
	nu-ansi-term@0.49.0
	num-bigint-dig@0.8.4
	num-bigint@0.2.6
	num-complex@0.2.4
	num-integer@0.1.45
	num-iter@0.1.43
	num-rational@0.2.4
	num-traits@0.2.17
	num@0.2.1
	num_cpus@1.16.0
	num_threads@0.1.6
	number_prefix@0.4.0
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	object@0.32.2
	once_cell@1.19.0
	opaque-debug@0.3.0
	openssl-probe@0.1.5
	option-ext@0.2.0
	os_pipe@1.1.5
	overload@0.1.1
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	parse_duration@2.1.1
	password-hash@0.5.0
	paste@1.0.14
	pathdiff@0.2.1
	pbkdf2@0.11.0
	pem-rfc7468@0.7.0
	percent-encoding@2.3.1
	petgraph@0.6.4
	pin-project-internal@1.1.3
	pin-project-lite@0.2.13
	pin-project@1.1.3
	pin-utils@0.1.0
	pkcs1@0.7.5
	pkcs8@0.10.2
	pkg-config@0.3.28
	platforms@3.3.0
	poly1305@0.8.0
	portable-atomic@1.6.0
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	pretty_assertions@1.4.0
	proc-macro2@1.0.74
	quanta@0.11.1
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	ratatui@0.24.0
	raw-cpuid@10.7.0
	redox_syscall@0.4.1
	redox_users@0.4.4
	regex-automata@0.1.10
	regex-automata@0.4.3
	regex-syntax@0.6.29
	regex-syntax@0.8.2
	regex@1.10.2
	reqwest@0.11.23
	ring@0.16.20
	ring@0.17.7
	rmp@0.8.12
	rpassword@7.3.1
	rsa@0.9.6
	rtoolbox@0.0.2
	runtime-format@0.1.3
	rustc-demangle@0.1.23
	rustc-hash@1.1.0
	rustc_version@0.4.0
	rustix@0.38.28
	rustls-native-certs@0.6.3
	rustls-pemfile@1.0.4
	rustls-webpki@0.101.7
	rustls@0.21.10
	rustversion@1.0.14
	rusty_paserk@0.3.0
	rusty_paseto@0.6.0
	ryu@1.0.16
	salsa20@0.10.2
	schannel@0.1.23
	scopeguard@1.2.0
	sct@0.7.1
	security-framework-sys@2.9.1
	security-framework@2.9.2
	semver@1.0.21
	serde@1.0.194
	serde_derive@1.0.194
	serde_json@1.0.110
	serde_path_to_error@0.1.15
	serde_regex@1.1.0
	serde_urlencoded@0.7.1
	sha1@0.10.6
	sha2@0.10.8
	sharded-slab@0.1.7
	shellexpand@3.1.0
	signal-hook-mio@0.2.3
	signal-hook-registry@1.4.1
	signal-hook@0.3.17
	signature@2.2.0
	sketches-ddsketch@0.2.1
	slab@0.4.9
	smallvec@1.11.2
	socket2@0.5.5
	spin@0.5.2
	spin@0.9.8
	spki@0.7.3
	sql-builder@3.1.1
	sqlformat@0.2.3
	sqlx-core@0.7.3
	sqlx-macros-core@0.7.3
	sqlx-macros@0.7.3
	sqlx-mysql@0.7.3
	sqlx-postgres@0.7.3
	sqlx-sqlite@0.7.3
	sqlx@0.7.3
	str-buf@1.0.6
	stringprep@0.1.4
	strsim@0.10.0
	strum@0.25.0
	strum_macros@0.25.3
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.46
	sync_wrapper@0.1.2
	system-configuration-sys@0.5.0
	system-configuration@0.5.1
	tempfile@3.9.0
	termcolor@1.4.0
	thiserror-impl@1.0.56
	thiserror@1.0.56
	thread_local@1.1.7
	time-core@0.1.2
	time-macros@0.2.16
	time@0.3.31
	tiny-bip39@1.0.0
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-macros@2.2.0
	tokio-rustls@0.24.1
	tokio-stream@0.1.14
	tokio-util@0.7.10
	tokio@1.35.1
	toml@0.5.11
	tower-http@0.4.4
	tower-layer@0.3.2
	tower-service@0.3.2
	tower@0.4.13
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	tracing-tree@0.3.0
	tracing@0.1.40
	tree_magic_mini@3.0.3
	try-lock@0.2.5
	typed-builder-macro@0.18.0
	typed-builder@0.18.0
	typenum@1.17.0
	unicode-bidi@0.3.14
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unicode-width@0.1.11
	unicode_categories@0.1.1
	universal-hash@0.5.1
	untrusted@0.7.1
	untrusted@0.9.0
	url@2.5.0
	urlencoding@2.1.3
	utf8parse@0.2.1
	uuid@1.6.1
	valuable@0.1.0
	vcpkg@0.2.15
	version_check@0.9.4
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.89
	wasm-bindgen-futures@0.4.39
	wasm-bindgen-macro-support@0.2.89
	wasm-bindgen-macro@0.2.89
	wasm-bindgen-shared@0.2.89
	wasm-bindgen@0.2.89
	wayland-client@0.29.5
	wayland-commons@0.29.5
	wayland-protocols@0.29.5
	wayland-scanner@0.29.5
	wayland-sys@0.29.5
	web-sys@0.3.66
	webpki-roots@0.25.3
	whoami@1.4.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-wsapoll@0.1.1
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.42.2
	windows-targets@0.48.5
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.0
	winreg@0.50.0
	wl-clipboard-rs@0.7.0
	x11-clipboard@0.7.1
	x11rb-protocol@0.10.0
	x11rb@0.10.1
	xml-rs@0.8.19
	yansi@0.5.1
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
	zeroize@1.7.0
	zeroize_derive@1.4.2
"

inherit cargo shell-completion systemd readme.gentoo-r1

DESCRIPTION="Shell history manager supporting encrypted synchronisation"
HOMEPAGE="https://atuin.sh https://github.com/atuinsh/atuin"
SRC_URI="
	https://github.com/atuinsh/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
# - openssl for ring crate
LICENSE+=" Apache-2.0 BSD Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 openssl"
SLOT="0"
KEYWORDS="amd64"
IUSE="+client server test +sync"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( client server )
	sync? ( client )
	test? ( client server sync )
"
RDEPEND="server? ( acct-user/atuin )"
BDEPEND=">=virtual/rust-1.71.0"

QA_FLAGS_IGNORED="usr/bin/${PN}"

DOCS=(
	CONTRIBUTING.md
	CONTRIBUTORS
	README.md
	docs/docs
)

src_prepare() {
	default

	rm atuin/tests/sync.rs || die
}

src_configure() {
	local myfeatures=(
		$(usev client)
		$(usev server)
		$(usev sync)
	)
	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile

	ATUIN_BIN="target/$(usex debug debug release)/${PN}"

	# Prepare shell completion generation
	mkdir completions || die
	local shell
	for shell in bash fish zsh; do
		"${ATUIN_BIN}" gen-completions \
					 -s ${shell} \
					 -o completions \
			|| die
	done

	mkdir shell-init || die
	for shell in bash fish zsh; do
		"${ATUIN_BIN}" init ${shell} > shell-init/${shell} || die
	done
}

src_install() {
	exeinto "/usr/bin"
	doexe "${ATUIN_BIN}"

	if use server; then
		systemd_dounit "${FILESDIR}/atuin.service"
	else
		rm -r "docs/docs/self-hosting" || die
	fi

	dodoc -r "${DOCS[@]}"

	newbashcomp "completions/${PN}.bash" "${PN}"
	dozshcomp "completions/_${PN}"
	dofishcomp "completions/${PN}.fish"

	insinto "/usr/share/${PN}"
	doins -r shell-init

	local DOC_CONTENTS="Gentoo installs atuin's shell-init code under
		  /usr/share/atuin/shell-init/.
		  Therefore, instead of using, e.g., 'eval \"\$(atuin init zsh)\"' in
		  your .zshrc you can simply put \"source /usr/share/atuin/shell-init/zsh\"
		  there, which avoids the cost of forking a process."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
