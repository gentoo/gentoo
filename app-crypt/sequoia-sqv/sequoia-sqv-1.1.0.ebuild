# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.17.0
	adler-1.0.2
	aead-0.3.2
	aho-corasick-0.7.18
	ansi_term-0.12.1
	anyhow-1.0.51
	ascii-canvas-3.0.0
	assert_cli-0.6.3
	atty-0.2.14
	autocfg-0.1.7
	autocfg-1.0.1
	backtrace-0.3.63
	base64-0.13.0
	bindgen-0.57.0
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.3.2
	block-buffer-0.9.0
	buffered-reader-1.1.1
	byteorder-1.4.3
	cc-1.0.72
	cexpr-0.4.0
	cfg-if-1.0.0
	chrono-0.4.19
	cipher-0.2.5
	clang-sys-1.3.0
	clap-2.34.0
	cmac-0.5.1
	colored-1.9.3
	cpufeatures-0.2.1
	crunchy-0.2.2
	crypto-mac-0.10.1
	ctr-0.6.0
	curve25519-dalek-3.2.0
	dbl-0.3.1
	diff-0.1.12
	difference-2.0.0
	digest-0.9.0
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	dyn-clone-1.0.4
	eax-0.3.0
	ed25519-1.3.0
	ed25519-dalek-1.0.1
	either-1.6.1
	ena-0.14.0
	environment-0.1.1
	failure-0.1.8
	failure_derive-0.1.8
	fixedbitset-0.2.0
	generic-array-0.14.4
	getrandom-0.2.3
	gimli-0.26.1
	glob-0.3.0
	hashbrown-0.11.2
	hermit-abi-0.1.19
	idna-0.2.3
	indexmap-1.7.0
	instant-0.1.12
	itertools-0.10.3
	itoa-0.4.8
	lalrpop-0.19.6
	lalrpop-util-0.19.6
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.109
	libloading-0.7.2
	libm-0.2.1
	lock_api-0.4.5
	log-0.4.14
	matches-0.1.9
	memchr-2.4.1
	memsec-0.6.0
	miniz_oxide-0.4.4
	nettle-7.0.3
	nettle-sys-2.0.8
	new_debug_unreachable-1.0.4
	nom-5.1.2
	num-bigint-dig-0.6.1
	num-integer-0.1.44
	num-iter-0.1.42
	num-traits-0.2.14
	object-0.27.1
	opaque-debug-0.3.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	peeking_take_while-0.1.2
	petgraph-0.5.1
	phf_shared-0.8.0
	pico-args-0.4.2
	pkg-config-0.3.23
	ppv-lite86-0.2.15
	precomputed-hash-0.1.1
	proc-macro2-1.0.33
	quote-1.0.10
	rand-0.7.3
	rand_chacha-0.2.2
	rand_core-0.5.1
	rand_hc-0.2.0
	redox_syscall-0.2.10
	redox_users-0.4.0
	regex-1.5.4
	regex-syntax-0.6.25
	rustc-demangle-0.1.21
	rustc-hash-1.1.0
	rustversion-1.0.6
	ryu-1.0.6
	scopeguard-1.1.0
	sequoia-openpgp-1.6.0
	serde-1.0.130
	serde_json-1.0.72
	sha1collisiondetection-0.2.5
	sha2-0.9.8
	shlex-0.1.1
	signature-1.4.0
	siphasher-0.3.7
	smallvec-1.7.0
	spin-0.5.2
	string_cache-0.8.2
	strsim-0.8.0
	subtle-2.4.1
	syn-1.0.82
	synstructure-0.12.6
	term-0.7.0
	term_size-0.3.2
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	time-0.1.43
	tiny-keccak-2.0.2
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	typenum-1.14.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-width-0.1.9
	unicode-xid-0.2.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.3
	wasi-0.10.2+wasi-snapshot-preview1
	win-crypto-ng-0.4.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	xxhash-rust-0.8.2
	zeroize-1.4.3
	zeroize_derive-1.2.2
"

inherit bash-completion-r1 cargo

DESCRIPTION="A simple OpenPGP signature verification program"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia"
SRC_URI="
	https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${PN}-v${PV}.crate.tar.gz
	$(cargo_crate_uris)
"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 GPL-2 GPL-2+ GPL-3 ISC LGPL-3 LGPL-3+ MIT MPL-2.0 ZLIB"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

QA_FLAGS_IGNORED="usr/bin/sqv"

COMMON_DEPEND="
	dev-libs/gmp:=
	dev-libs/nettle:=
"

DEPEND="
	sys-devel/clang
	${COMMON_DEPEND}
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
"

src_compile() {
	# Setting CARGO_TARGET_DIR is required to have the build system
	# create the bash and zsh completion files.
	CARGO_TARGET_DIR="${S}/target" cargo_src_compile
}

src_install() {
	cargo_src_install

	newbashcomp target/sqv.bash sqv

	local -r manpage="${T}"/sqv.1
	help2man \
		--no-info \
		--version-string="${PV}" \
		--name="${DESCRIPTION}" \
		--output="${manpage}" \
		"${ED}"/usr/bin/sqv || die "Failed to create manpage"
	doman "${manpage}"

	insinto /usr/share/zsh/site-functions
	doins target/_sqv

	insinto /usr/share/fish/vendor_completions.d
	doins target/sqv.fish
}
