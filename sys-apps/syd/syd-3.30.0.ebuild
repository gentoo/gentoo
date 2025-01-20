# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RESTRICT="test" # fails with sandbox

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	anyhow@1.0.95
	argv@0.1.11
	arrayref@0.3.9
	arrayvec@0.5.2
	arrayvec@0.7.6
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.13.1
	bitflags@1.3.2
	bitflags@2.6.0
	bitvec@1.0.1
	blake2b_simd@0.5.11
	block-buffer@0.10.4
	brunch@0.7.0
	btoi@0.4.3
	bumpalo@3.16.0
	caps@0.5.5
	cc@1.2.7
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	cfg_aliases@0.2.1
	chrono@0.4.39
	clap@4.5.24
	clap_builder@4.5.24
	clap_derive@4.5.24
	clap_lex@0.7.4
	colorchoice@1.0.3
	constant_time_eq@0.1.5
	constant_time_eq@0.3.1
	core-foundation-sys@0.8.7
	cpufeatures@0.2.16
	crc-catalog@2.4.0
	crc32fast@1.4.2
	crc@3.2.1
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	dactyl@0.8.0
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	digest@0.10.7
	dirs-sys@0.3.7
	dirs-sys@0.4.1
	dirs@1.0.5
	dirs@4.0.0
	dirs@5.0.1
	either@1.13.0
	equivalent@1.0.1
	errno@0.3.10
	error-chain@0.12.4
	expiringmap@0.1.2
	fastrand@2.3.0
	fixedbitset@0.5.7
	flate2@1.0.35
	fnv@1.0.7
	funty@2.0.0
	generic-array@0.14.7
	getargs@0.5.0
	getrandom@0.1.16
	getrandom@0.2.15
	getset@0.1.3
	gimli@0.31.1
	goblin@0.9.3
	gperftools@0.2.0
	hashbrown@0.12.3
	hashbrown@0.14.5
	hashbrown@0.15.2
	heck@0.5.0
	hermit-abi@0.3.9
	hex-conservative@0.3.0
	hex@0.4.3
	hkdf@0.12.4
	hmac@0.12.1
	home@0.5.11
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	iced-x86@1.21.0
	ident_case@1.0.1
	indexmap@1.9.3
	indexmap@2.7.0
	io-uring@0.6.4
	ipnet@2.10.1
	iprange@0.6.7
	is_terminal_polyfill@1.70.1
	itoa@1.0.14
	js-sys@0.3.76
	keccak@0.1.5
	lazy_static@1.5.0
	lexis@0.2.3
	libc@0.2.169
	libcgroups@0.5.0
	libcontainer@0.5.0
	libloading@0.8.6
	liboci-cli@0.5.0
	libredox@0.1.3
	libseccomp-sys@0.2.1
	libseccomp@0.3.0
	linefeed@0.6.0
	linux-raw-sys@0.4.14
	log@0.4.22
	md5@0.7.0
	memchr@2.7.4
	memoffset@0.9.1
	minimal-lexical@0.2.1
	miniz_oxide@0.8.2
	mortal@0.2.4
	nc@0.9.5
	nix@0.26.4
	nix@0.28.0
	nix@0.29.0
	nom@7.1.3
	nu-ansi-term@0.46.0
	num-traits@0.2.19
	num_cpus@1.16.0
	object@0.36.7
	oci-spec@0.7.1
	once_cell@1.20.2
	option-ext@0.2.0
	overload@0.1.1
	parse-size@1.0.0
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_shared@0.11.3
	pin-project-lite@0.2.16
	pkg-config@0.3.31
	plain@0.2.3
	portable-atomic@1.10.0
	prctl@1.0.0
	proc-macro-error-attr2@2.0.0
	proc-macro-error2@2.0.1
	proc-macro2@1.0.92
	procfs-core@0.17.0
	procfs@0.17.0
	protobuf-codegen@3.2.0
	protobuf-parse@3.2.0
	protobuf-support@3.2.0
	protobuf@3.2.0
	quick_cache@0.6.9
	quote@1.0.38
	radium@0.7.0
	raki@1.3.1
	rand@0.8.5
	rand_core@0.6.4
	rand_hc@0.3.2
	redox_syscall@0.1.57
	redox_users@0.3.5
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.10.6
	ringbuf@0.4.7
	rust-argon2@0.8.3
	rust-criu@0.4.0
	rustc-demangle@0.1.24
	rustix@0.38.43
	rustversion@1.0.19
	ryu@1.0.18
	safe-path@0.1.0
	scroll@0.12.0
	scroll_derive@0.12.0
	secure-string@0.3.0
	sendfd@0.4.3
	serde@1.0.217
	serde_derive@1.0.217
	serde_json@1.0.135
	sha1@0.10.6
	sha3@0.10.8
	sharded-slab@0.1.7
	shellexpand@3.1.0
	shlex@1.3.0
	siphasher@1.0.1
	smallstr@0.2.0
	smallvec@1.13.2
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	subtle@2.6.1
	syn@2.0.95
	tabwriter@1.4.1
	tap@1.0.1
	tcmalloc@0.3.0
	tempfile@3.15.0
	terminfo@0.8.0
	thiserror-impl@1.0.69
	thiserror-impl@2.0.9
	thiserror@1.0.69
	thiserror@2.0.9
	thread_local@1.1.8
	tick_counter@0.4.5
	tinyvec@1.8.1
	tinyvec_macros@0.1.1
	tracing-attributes@0.1.28
	tracing-core@0.1.33
	tracing-log@0.2.0
	tracing-subscriber@0.3.19
	tracing@0.1.41
	typenum@1.17.0
	unicode-ident@1.0.14
	unicode-normalization@0.1.24
	unicode-width@0.1.14
	unicode-width@0.2.0
	utf8parse@0.2.2
	valuable@0.1.0
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.9.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.99
	wasm-bindgen-macro-support@0.2.99
	wasm-bindgen-macro@0.2.99
	wasm-bindgen-shared@0.2.99
	wasm-bindgen@0.2.99
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	wyz@0.5.1
	yaxpeax-arch@0.3.2
	yaxpeax-arm@0.3.0
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zeroize@1.8.1
"

inherit cargo

DESCRIPTION="seccomp and landlock based application sandbox with support for namespaces"
HOMEPAGE="https://sydbox.exherbolinux.org"
SRC_URI="https://git.sr.ht/~alip/syd/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

IUSE="static"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016"

SLOT="0"
KEYWORDS="~amd64"

DEPEND="static? ( sys-libs/libseccomp[static-libs] )
	sys-libs/libseccomp
	app-text/scdoc"
RDEPEND="sys-apps/pandora_box
	${DEPEND}"

S="${WORKDIR}/syd-v${PV}"

src_configure() {
	if use static; then
		export LIBSECCOMP_LINK_TYPE="static"
		export LIBSECCOMP_LIB_PATH=$(pkgconf --variable=libdir libseccomp)
		export RUSTFLAGS+="-Ctarget-feature=+crt-static"
		cargo_src_configure
	else
		local myfeatures=( "oci" )
		cargo_src_configure
	fi
}

src_compile() {
	cargo_src_compile
	emake man
}

src_install () {
	cargo_src_install
	mkdir -p "${D}"/usr/share/man/man{1,2,5,7}
	emake install-man DESTDIR="${D}" PREFIX="/usr"
	dodoc README.md
	insinto /usr/libexec
	doins src/esyd.sh

	insinto /etc
	newins data/user.syd-3 user.syd-3.sample

	insinto /usr/share/vim/vimfiles/ftdetect
	doins vim/ftdetect/syd.vim
	insinto /usr/share/vim/vimfiles/syntax
	doins vim/syntax/syd-3.vim
}

src_test() {
	RUSTFLAGS="" cargo_src_test
}
