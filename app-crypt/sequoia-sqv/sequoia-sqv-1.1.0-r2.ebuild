# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.17.0
	adler@1.0.2
	aead@0.5.2
	aho-corasick@0.7.18
	ansi_term@0.12.1
	anyhow@1.0.51
	ascii-canvas@3.0.0
	assert_cli@0.6.3
	atty@0.2.14
	autocfg@1.0.1
	backtrace@0.3.63
	base64@0.21.1
	bindgen@0.63.0
	bit-set@0.5.2
	bit-vec@0.6.3
	bitflags@1.3.2
	block-buffer@0.10.4
	block-buffer@0.9.0
	block-padding@0.3.3
	buffered-reader@1.2.0
	bumpalo@3.13.0
	byteorder@1.4.3
	cc@1.0.72
	cexpr@0.6.0
	cfg-if@1.0.0
	chrono@0.4.19
	cipher@0.2.5
	cipher@0.4.4
	clang-sys@1.3.0
	clap@2.34.0
	cmac@0.7.2
	colored@1.9.3
	cpufeatures@0.2.1
	crunchy@0.2.2
	crypto-common@0.1.6
	ctr@0.9.2
	curve25519-dalek@3.2.0
	dbl@0.3.1
	diff@0.1.12
	difference@2.0.0
	digest@0.10.7
	digest@0.9.0
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	doc-comment@0.3.3
	dyn-clone@1.0.4
	eax@0.5.0
	ed25519-dalek@1.0.1
	ed25519@1.3.0
	either@1.6.1
	ena@0.14.0
	environment@0.1.1
	errno-dragonfly@0.1.2
	errno@0.3.1
	failure@0.1.8
	failure_derive@0.1.8
	fastrand@1.9.0
	fixedbitset@0.2.0
	generic-array@0.14.4
	getrandom@0.1.16
	getrandom@0.2.3
	gimli@0.26.1
	glob@0.3.0
	hashbrown@0.11.2
	hermit-abi@0.1.19
	hermit-abi@0.3.1
	idna@0.2.3
	indexmap@1.7.0
	inout@0.1.3
	instant@0.1.12
	io-lifetimes@1.0.11
	itertools@0.10.3
	itoa@0.4.8
	js-sys@0.3.63
	lalrpop-util@0.19.6
	lalrpop@0.19.6
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.144
	libloading@0.7.2
	libm@0.2.1
	linux-raw-sys@0.3.8
	lock_api@0.4.5
	log@0.4.14
	matches@0.1.9
	memchr@2.4.1
	memsec@0.6.0
	minimal-lexical@0.2.1
	miniz_oxide@0.4.4
	nettle-sys@2.2.0
	nettle@7.3.0
	new_debug_unreachable@1.0.4
	nom@7.1.3
	num-bigint-dig@0.8.2
	num-integer@0.1.44
	num-iter@0.1.42
	num-traits@0.2.14
	object@0.27.1
	once_cell@1.17.1
	opaque-debug@0.3.0
	parking_lot@0.11.2
	parking_lot_core@0.8.5
	peeking_take_while@0.1.2
	petgraph@0.5.1
	phf_shared@0.8.0
	pkg-config@0.3.23
	ppv-lite86@0.2.15
	precomputed-hash@0.1.1
	proc-macro2@1.0.58
	quote@1.0.27
	rand@0.7.3
	rand_chacha@0.2.2
	rand_core@0.5.1
	rand_core@0.6.4
	rand_hc@0.2.0
	redox_syscall@0.2.10
	redox_syscall@0.3.5
	redox_users@0.4.0
	regex-syntax@0.6.25
	regex@1.5.4
	rustc-demangle@0.1.21
	rustc-hash@1.1.0
	rustix@0.37.19
	rustversion@1.0.6
	ryu@1.0.6
	scopeguard@1.1.0
	sequoia-openpgp@1.16.0
	serde@1.0.130
	serde_json@1.0.72
	sha1collisiondetection@0.2.5
	sha2@0.9.8
	shlex@1.1.0
	signature@1.4.0
	siphasher@0.3.7
	smallvec@1.10.0
	spin@0.5.2
	string_cache@0.8.2
	strsim@0.8.0
	subtle@2.4.1
	syn@1.0.109
	syn@2.0.16
	synstructure@0.12.6
	tempfile@3.5.0
	term@0.7.0
	term_size@0.3.2
	textwrap@0.11.0
	thiserror-impl@1.0.30
	thiserror@1.0.30
	time@0.1.43
	tiny-keccak@2.0.2
	tinyvec@1.5.1
	tinyvec_macros@0.1.0
	typenum@1.14.0
	unicode-bidi@0.3.7
	unicode-ident@1.0.9
	unicode-normalization@0.1.19
	unicode-width@0.1.9
	unicode-xid@0.2.2
	vcpkg@0.2.15
	vec_map@0.8.2
	version_check@0.9.3
	wasi@0.10.2+wasi-snapshot-preview1
	wasi@0.9.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.86
	wasm-bindgen-macro-support@0.2.86
	wasm-bindgen-macro@0.2.86
	wasm-bindgen-shared@0.2.86
	wasm-bindgen@0.2.86
	win-crypto-ng@0.4.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.0
	xxhash-rust@0.8.2
	zeroize@1.4.3
	zeroize_derive@1.2.2
"

LLVM_MAX_SLOT=17

inherit bash-completion-r1 cargo llvm

DESCRIPTION="A simple OpenPGP signature verification program"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia-sqv"
SRC_URI="
	https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	${CARGO_CRATE_URIS}
"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-CVEs-bug906801.patch.xz"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="GPL-2+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC LGPL-2+ MIT MPL-2.0
	Unicode-DFS-2016
	|| ( GPL-2 GPL-3 LGPL-3 )
"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

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
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1))
	sys-apps/help2man
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}"/${P}-CVEs-bug906801.patch
)

llvm_check_deps() {
	has_version -b "sys-devel/clang:${LLVM_SLOT}"
}

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
