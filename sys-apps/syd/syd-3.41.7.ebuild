# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RESTRICT="test" # fails with sandbox

RUST_MIN_VER="1.83.0"

CRATES="
	addr2line@0.25.1
	adler2@2.0.1
	ahash@0.8.12
	aho-corasick@1.1.4
	android_system_properties@0.1.5
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.13
	anyhow@1.0.100
	arrayref@0.3.9
	arrayvec@0.5.2
	autocfg@1.5.0
	backtrace@0.3.76
	base64@0.13.1
	bitflags@1.3.2
	bitflags@2.10.0
	bitvec@1.0.1
	blake2b_simd@0.5.11
	block-buffer@0.10.4
	brunch@0.8.1
	btoi@0.5.0
	bumpalo@3.19.0
	bytes@1.10.1
	caps@0.5.6
	cc@1.2.44
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	chrono@0.4.42
	clap@4.5.51
	clap_builder@4.5.51
	clap_derive@4.5.49
	clap_lex@0.7.6
	colorchoice@1.0.4
	const_format@0.2.35
	const_format_proc_macros@0.2.34
	constant_time_eq@0.1.5
	core-foundation-sys@0.8.7
	cpufeatures@0.2.17
	crc-catalog@2.4.0
	crc32fast@1.5.0
	crc@3.3.0
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	dactyl@0.9.1
	darling@0.20.11
	darling_core@0.20.11
	darling_macro@0.20.11
	data-encoding@2.9.0
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	digest@0.10.7
	dirs-sys@0.3.7
	dirs-sys@0.5.0
	dirs@1.0.5
	dirs@4.0.0
	dirs@6.0.0
	either@1.15.0
	equivalent@1.0.2
	errno@0.3.14
	error-chain@0.12.4
	expiringmap@0.1.2
	fastrand@2.3.0
	find-msvc-tools@0.1.4
	fixedbitset@0.5.7
	flate2@1.1.5
	fnv@1.0.7
	funty@2.0.0
	generic-array@0.14.9
	getrandom@0.1.16
	getrandom@0.2.16
	getrandom@0.3.4
	getset@0.1.6
	gimli@0.32.3
	goblin@0.9.3
	gperftools@0.2.0
	hashbrown@0.12.3
	hashbrown@0.16.0
	heck@0.5.0
	hermit-abi@0.5.2
	hex@0.4.3
	home@0.5.12
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.64
	iced-x86@1.21.0
	ident_case@1.0.1
	indexmap@1.9.3
	indexmap@2.12.0
	io-uring@0.6.4
	ipnet@2.11.0
	iprange@0.6.7
	is_terminal_polyfill@1.70.2
	itoa@1.0.15
	js-sys@0.3.82
	keccak@0.1.5
	lazy_static@1.5.0
	lexis@0.2.3
	lexopt@0.3.1
	libc@0.2.177
	libcgroups@0.5.6
	libcontainer@0.5.6
	libloading@0.8.9
	libmimalloc-sys@0.1.44
	liboci-cli@0.5.6
	libredox@0.1.10
	libseccomp-sys@0.3.0
	libseccomp@0.4.0
	linefeed@0.6.0
	linux-raw-sys@0.11.0
	linux-raw-sys@0.4.15
	log@0.4.28
	md5@0.8.0
	memchr@2.7.6
	memoffset@0.9.1
	mimalloc@0.1.48
	minimal-lexical@0.2.1
	miniz_oxide@0.8.9
	mortal@0.2.4
	nc@0.9.6
	netlink-sys@0.8.7
	nix@0.26.4
	nix@0.29.0
	nix@0.30.1
	nom@7.1.3
	nom@8.0.0
	nu-ansi-term@0.50.3
	num-traits@0.2.19
	num_cpus@1.17.0
	object@0.37.3
	oci-spec@0.8.3
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	option-ext@0.2.0
	parse-size@1.1.0
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_shared@0.11.3
	pin-project-lite@0.2.16
	pkg-config@0.3.32
	plain@0.2.3
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	prctl@1.0.0
	proc-macro-error-attr2@2.0.0
	proc-macro-error2@2.0.1
	proc-macro2@1.0.103
	procfs-core@0.17.0
	procfs-core@0.18.0
	procfs@0.17.0
	procfs@0.18.0
	protobuf-codegen@3.2.0
	protobuf-parse@3.2.0
	protobuf-support@3.2.0
	protobuf@3.2.0
	quote@1.0.41
	r-efi@5.3.0
	radium@0.7.0
	raki@1.3.2
	rand@0.8.5
	rand_core@0.6.4
	redox_syscall@0.1.57
	redox_users@0.3.5
	redox_users@0.4.6
	redox_users@0.5.2
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	ringbuf@0.4.8
	rpassword@7.4.0
	rtoolbox@0.0.3
	rust-argon2@0.8.3
	rust-criu@0.4.0
	rustc-demangle@0.1.26
	rustix@0.38.44
	rustix@1.1.2
	rustversion@1.0.22
	ryu@1.0.20
	safe-path@0.1.0
	scroll@0.12.0
	scroll_derive@0.12.1
	sendfd@0.4.4
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	sha1@0.10.6
	sha3@0.10.8
	sharded-slab@0.1.7
	shellexpand@3.1.1
	shlex@1.3.0
	simd-adler32@0.3.7
	siphasher@1.0.1
	smallstr@0.2.0
	smallvec@1.15.1
	strsim@0.11.1
	strum@0.27.2
	strum_macros@0.27.2
	subtle@2.6.1
	syn@2.0.108
	tabwriter@1.4.1
	tap@1.0.1
	tcmalloc@0.3.0
	tempfile@3.23.0
	terminfo@0.8.0
	thiserror-impl@1.0.69
	thiserror-impl@2.0.17
	thiserror@1.0.69
	thiserror@2.0.17
	thread_local@1.1.9
	tick_counter@0.4.5
	tinyvec@1.10.0
	tinyvec_macros@0.1.1
	tracing-attributes@0.1.30
	tracing-core@0.1.34
	tracing-log@0.2.0
	tracing-subscriber@0.3.20
	tracing@0.1.41
	typenum@1.19.0
	unicode-ident@1.0.22
	unicode-normalization@0.1.25
	unicode-width@0.1.14
	unicode-width@0.2.2
	unicode-xid@0.2.6
	utf8parse@0.2.2
	valuable@0.1.1
	version_check@0.9.5
	wasi@0.11.1+wasi-snapshot-preview1
	wasi@0.9.0+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-macro-support@0.2.105
	wasm-bindgen-macro@0.2.105
	wasm-bindgen-shared@0.2.105
	wasm-bindgen@0.2.105
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	wit-bindgen@0.46.0
	wyz@0.5.1
	yaxpeax-arch@0.3.2
	yaxpeax-arm@0.4.0
	zerocopy-derive@0.8.27
	zerocopy@0.8.27
	zeroize@1.8.2
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
LICENSE+="
	0BSD Apache-2.0 BSD-2 BSD CC0-1.0 GPL-3+ ISC MIT MPL-2.0 Unicode-3.0
	WTFPL-2 ZLIB
"

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
