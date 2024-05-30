# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aead@0.5.2
	aes-gcm@0.10.3
	aes@0.8.4
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.13
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.6
	anyhow@1.0.76
	ascii-canvas@3.0.0
	assert_cmd@2.0.13
	autocfg@1.2.0
	base16ct@0.2.0
	base64@0.22.0
	base64ct@1.6.0
	bindgen@0.68.1
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	block-padding@0.3.3
	blowfish@0.9.1
	botan-sys@0.10.5
	botan@0.10.7
	bstr@1.9.1
	buffered-reader@1.3.1
	bumpalo@3.16.0
	byteorder@1.5.0
	camellia@0.1.0
	cast5@0.11.1
	cc@1.0.94
	cexpr@0.6.0
	cfb-mode@0.8.2
	cfg-if@1.0.0
	chrono@0.4.38
	cipher@0.4.4
	clang-sys@1.7.0
	clap@4.4.18
	clap_builder@4.4.18
	clap_complete@4.4.10
	clap_derive@4.4.7
	clap_lex@0.6.0
	clap_mangen@0.2.19
	cmac@0.7.2
	colorchoice@1.0.0
	const-oid@0.9.6
	core-foundation-sys@0.8.6
	cpufeatures@0.2.12
	crunchy@0.2.2
	crypto-bigint@0.5.5
	crypto-common@0.1.6
	ctr@0.9.2
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.2
	dbl@0.3.2
	der@0.7.9
	des@0.8.1
	difflib@0.4.0
	digest@0.10.7
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	doc-comment@0.3.3
	dsa@0.6.3
	dyn-clone@1.0.17
	eax@0.5.0
	ecb@0.1.2
	ecdsa@0.16.9
	ed25519-dalek@2.1.1
	ed25519@2.2.3
	either@1.11.0
	elliptic-curve@0.13.8
	ena@0.14.2
	equivalent@1.0.1
	errno@0.3.8
	fastrand@2.0.2
	ff@0.13.0
	fiat-crypto@0.2.7
	fixedbitset@0.4.2
	float-cmp@0.9.0
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	generic-array@0.14.7
	getrandom@0.2.14
	ghash@0.5.1
	glob@0.3.1
	group@0.13.0
	hashbrown@0.14.3
	heck@0.4.1
	hkdf@0.12.4
	hmac@0.12.1
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	idea@0.5.1
	idna@0.5.0
	indexmap@2.2.6
	inout@0.1.3
	itertools@0.11.0
	js-sys@0.3.69
	lalrpop-util@0.20.2
	lalrpop@0.20.2
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.153
	libloading@0.8.3
	libm@0.2.8
	libredox@0.1.3
	linux-raw-sys@0.4.13
	lock_api@0.4.11
	log@0.4.21
	md-5@0.10.6
	memchr@2.7.2
	memsec@0.6.3
	minimal-lexical@0.2.1
	nettle-sys@2.3.0
	nettle@7.4.0
	new_debug_unreachable@1.0.6
	nom@7.1.3
	normalize-line-endings@0.3.0
	num-bigint-dig@0.8.4
	num-integer@0.1.46
	num-iter@0.1.44
	num-traits@0.2.18
	once_cell@1.19.0
	opaque-debug@0.3.1
	openssl-macros@0.1.1
	openssl-sys@0.9.102
	openssl@0.10.64
	p256@0.13.2
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	peeking_take_while@0.1.2
	pem-rfc7468@0.7.0
	petgraph@0.6.4
	phf_shared@0.10.0
	pkcs1@0.7.5
	pkcs8@0.10.2
	pkg-config@0.3.30
	platforms@3.4.0
	polyval@0.6.2
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	primeorder@0.13.6
	proc-macro2@1.0.81
	quote@1.0.36
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.4.1
	redox_users@0.4.5
	regex-automata@0.4.6
	regex-syntax@0.8.3
	regex@1.10.4
	rfc6979@0.4.0
	ripemd@0.1.3
	roff@0.2.1
	rsa@0.9.6
	rustc-hash@1.1.0
	rustc_version@0.4.0
	rustix@0.38.32
	rustversion@1.0.15
	same-file@1.0.6
	scopeguard@1.2.0
	sec1@0.7.3
	semver@1.0.22
	sequoia-openpgp@1.20.0
	sequoia-policy-config@0.6.0
	serde@1.0.198
	serde_derive@1.0.198
	sha1collisiondetection@0.3.4
	sha2@0.10.8
	shlex@1.3.0
	signature@2.2.0
	siphasher@0.3.11
	smallvec@1.13.2
	spin@0.5.2
	spki@0.7.3
	string_cache@0.8.7
	strsim@0.10.0
	subtle@2.5.0
	syn@2.0.60
	tempfile@3.10.1
	term@0.7.0
	terminal_size@0.3.0
	termtree@0.4.1
	thiserror-impl@1.0.58
	thiserror@1.0.58
	tiny-keccak@2.0.2
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	twofish@0.7.1
	typenum@1.17.0
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-xid@0.2.4
	universal-hash@0.5.1
	utf8parse@0.2.1
	vcpkg@0.2.15
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	win-crypto-ng@0.5.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
	x25519-dalek@2.0.1
	xxhash-rust@0.8.10
	zeroize@1.7.0
	zeroize_derive@1.4.2
"

LLVM_COMPAT=( {17..18} )

inherit bash-completion-r1 cargo llvm-r1

DESCRIPTION="A simple OpenPGP signature verification program"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia-sqv"
SRC_URI="
	https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="GPL-2+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC LGPL-2+ MIT Unicode-DFS-2016
	|| ( GPL-2 GPL-3 LGPL-3 )
"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

QA_FLAGS_IGNORED="usr/bin/sqv"

COMMON_DEPEND="
	dev-libs/gmp:=
	dev-libs/nettle:=
"

DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="${COMMON_DEPEND}"
# Needed for bindgen
BDEPEND="
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
	')
	virtual/pkgconfig
"

src_compile() {
	# Set this here so that it doesn't change if we run tests
	# and cause a recompilation.
	asset_dir="${T}"/assets
	export ASSET_OUT_DIR="${asset_dir}"

	# Setting CARGO_TARGET_DIR is required to have the build system
	# create the bash and zsh completion files.
	export CARGO_TARGET_DIR="${S}/target"

	cargo_src_compile
}

src_install() {
	cargo_src_install

	newbashcomp "${asset_dir}"/shell-completions/sqv.bash sqv

	doman "${asset_dir}"/man-pages/sqv.1

	insinto /usr/share/zsh/site-functions
	doins "${asset_dir}"/shell-completions/_sqv

	insinto /usr/share/fish/vendor_completions.d
	doins "${asset_dir}"/shell-completions/sqv.fish
}
