# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=tree-sitter
MY_P=${MY_PN}-${PV}
# It would be nice to drop GIT_CRATES for these optional/unused deps.
# Ref: https://github.com/rust-lang/cargo/issues/10801
declare -A GIT_CRATES=(
	[wasmtime]="https://github.com/bytecodealliance/wasmtime;fa6fcd946b8f6d60c2d191a1b14b9399e261a76d;wasmtime-%commit%/crates/wasmtime"
	[wasmtime-c-api-impl]="https://github.com/bytecodealliance/wasmtime;fa6fcd946b8f6d60c2d191a1b14b9399e261a76d;wasmtime-%commit%/crates/c-api"
)
CRATES="
	ahash@0.8.6
	aho-corasick@1.1.2
	ansi_term@0.12.1
	anyhow@1.0.75
	arbitrary@1.3.1
	ascii@1.1.0
	atty@0.2.14
	autocfg@1.1.0
	bincode@1.3.3
	bindgen@0.66.1
	bitflags@1.3.2
	bitflags@2.4.1
	bumpalo@3.14.0
	bytes@1.5.0
	cc@1.0.83
	cesu8@1.1.0
	cexpr@0.6.0
	cfg-if@1.0.0
	chunked_transfer@1.4.1
	clang-sys@1.6.1
	clap@2.34.0
	combine@4.6.6
	core-foundation@0.9.3
	core-foundation-sys@0.8.4
	crc32fast@1.3.2
	ctor@0.2.5
	ctrlc@3.4.1
	diff@0.1.13
	difference@2.0.0
	dirs@3.0.2
	dirs@5.0.1
	dirs-sys@0.3.7
	dirs-sys@0.4.1
	either@1.9.0
	equivalent@1.0.1
	errno@0.3.5
	fallible-iterator@0.3.0
	fastrand@2.0.1
	form_urlencoded@1.2.0
	getrandom@0.2.10
	gimli@0.28.0
	glob@0.3.1
	hashbrown@0.13.2
	hashbrown@0.14.2
	hermit-abi@0.1.19
	home@0.5.5
	html-escape@0.2.13
	httpdate@1.0.3
	idna@0.4.0
	indexmap@2.0.2
	indoc@2.0.4
	itertools@0.10.5
	itoa@1.0.9
	jni@0.21.1
	jni-sys@0.3.0
	js-sys@0.3.64
	lazy_static@1.4.0
	lazycell@1.3.0
	leb128@0.2.5
	libc@0.2.149
	libloading@0.7.4
	linux-raw-sys@0.4.10
	log@0.4.20
	mach@0.3.2
	malloc_buf@0.0.6
	memchr@2.6.4
	memfd@0.6.4
	memoffset@0.9.0
	minimal-lexical@0.2.1
	ndk-context@0.1.1
	nix@0.27.1
	nom@7.1.3
	objc@0.2.7
	object@0.32.1
	once_cell@1.18.0
	option-ext@0.2.0
	paste@1.0.14
	path-slash@0.2.1
	peeking_take_while@0.1.2
	percent-encoding@2.3.0
	pin-project-lite@0.2.13
	ppv-lite86@0.2.17
	pretty_assertions@1.4.0
	prettyplease@0.2.15
	proc-macro2@1.0.69
	psm@0.1.21
	quote@1.0.33
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	raw-window-handle@0.5.2
	redox_syscall@0.2.16
	redox_syscall@0.4.1
	redox_users@0.4.3
	regalloc2@0.9.3
	regex@1.10.2
	regex-automata@0.4.3
	regex-syntax@0.7.5
	regex-syntax@0.8.2
	rustc-hash@1.1.0
	rustix@0.38.21
	ryu@1.0.15
	same-file@1.0.6
	semver@1.0.20
	serde@1.0.190
	serde_derive@1.0.190
	serde_json@1.0.107
	serde_spanned@0.6.4
	shlex@1.2.0
	slice-group-by@0.3.1
	smallbitvec@2.5.1
	smallvec@1.11.1
	sptr@0.3.2
	stable_deref_trait@1.2.0
	strsim@0.8.0
	syn@1.0.109
	syn@2.0.38
	target-lexicon@0.12.12
	tempfile@3.8.1
	textwrap@0.11.0
	thiserror@1.0.50
	thiserror-impl@1.0.50
	tiny_http@0.12.0
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.7.8
	toml_datetime@0.6.5
	toml_edit@0.19.15
	tracing@0.1.40
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	unicode-bidi@0.3.13
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	unicode-width@0.1.11
	unindent@0.2.3
	url@2.4.1
	utf8-width@0.1.6
	vec_map@0.8.2
	version_check@0.9.4
	walkdir@2.4.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.87
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-encoder@0.35.0
	wasmparser@0.115.0
	web-sys@0.3.64
	webbrowser@0.8.12
	which@4.4.2
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	winnow@0.5.17
	yansi@0.5.1
	zerocopy@0.7.15
	zerocopy-derive@0.7.15
"
inherit cargo

DESCRIPTION="Command-line tool for creating and testing tree-sitter grammars"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz
${CARGO_CRATE_URIS}"
S="${WORKDIR}"/${MY_P}/cli

LICENSE="Apache-2.0 BSD-2 CC0-1.0 ISC MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

# Test seems to require files (grammar definitions) that we don't have.
RESTRICT="test"

BDEPEND="~dev-libs/tree-sitter-${PV}"
RDEPEND="${BDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${MY_PN}"

src_prepare() {
	default

	# Existing build.rs file invokes cc to rebuild the tree-sitter library.
	# Link with the system one instead.
	cp "${FILESDIR}"/tree-sitter-cli-0.20.2-r1-build.rs \
	   "${WORKDIR}"/${MY_P}/lib/binding_rust/build.rs || die
}
