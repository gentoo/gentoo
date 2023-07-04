# Copyright 2023-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	ahash-0.7.6
	ahash-0.8.3
	aho-corasick-0.7.20
	aho-corasick-1.0.1
	android_system_properties-0.1.5
	anyhow-1.0.71
	arc-swap-1.6.0
	autocfg-1.1.0
	bitflags-1.3.2
	bitflags-2.2.1
	bstr-1.4.0
	btoi-0.4.3
	bumpalo-3.12.0
	bytecount-0.6.3
	bytes-1.4.0
	cassowary-0.3.0
	cc-1.0.79
	cfg-if-1.0.0
	chardetng-0.1.17
	chrono-0.4.24
	clipboard-win-4.5.0
	clru-0.6.1
	codespan-reporting-0.11.1
	content_inspector-0.2.4
	core-foundation-sys-0.8.4
	crc32fast-1.3.2
	crossterm-0.26.1
	crossterm_winapi-0.9.0
	cxx-1.0.94
	cxx-build-1.0.94
	cxxbridge-flags-1.0.94
	cxxbridge-macro-1.0.94
	dunce-1.0.4
	either-1.8.1
	encoding_rs-0.8.32
	encoding_rs_io-0.1.7
	errno-0.3.1
	errno-dragonfly-0.1.2
	error-code-2.3.1
	etcetera-0.8.0
	fastrand-1.9.0
	fern-0.6.2
	filetime-0.2.21
	flate2-1.0.25
	fnv-1.0.7
	form_urlencoded-1.1.0
	futures-core-0.3.28
	futures-executor-0.3.28
	futures-task-0.3.28
	futures-util-0.3.28
	fuzzy-matcher-0.3.7
	getrandom-0.2.9
	gix-0.44.1
	gix-actor-0.20.0
	gix-attributes-0.12.0
	gix-bitmap-0.2.3
	gix-chunk-0.4.1
	gix-command-0.2.4
	gix-config-0.22.0
	gix-config-value-0.12.0
	gix-credentials-0.14.0
	gix-date-0.5.0
	gix-diff-0.29.0
	gix-discover-0.18.1
	gix-features-0.29.0
	gix-fs-0.1.1
	gix-glob-0.7.0
	gix-hash-0.11.1
	gix-hashtable-0.2.0
	gix-ignore-0.2.0
	gix-index-0.16.0
	gix-lock-5.0.0
	gix-mailmap-0.12.0
	gix-object-0.29.1
	gix-odb-0.45.0
	gix-pack-0.35.0
	gix-path-0.8.0
	gix-prompt-0.5.0
	gix-quote-0.4.3
	gix-ref-0.29.1
	gix-refspec-0.10.1
	gix-revision-0.13.0
	gix-sec-0.8.0
	gix-tempfile-5.0.2
	gix-traverse-0.25.0
	gix-url-0.18.0
	gix-utils-0.1.1
	gix-validate-0.7.4
	gix-worktree-0.17.0
	globset-0.4.10
	grep-matcher-0.1.6
	grep-regex-0.1.11
	grep-searcher-0.1.11
	hashbrown-0.12.3
	hashbrown-0.13.2
	hermit-abi-0.2.6
	hermit-abi-0.3.1
	hex-0.4.3
	home-0.5.4
	iana-time-zone-0.1.56
	iana-time-zone-haiku-0.1.1
	idna-0.3.0
	ignore-0.4.20
	imara-diff-0.1.5
	indexmap-1.9.3
	indoc-2.0.1
	instant-0.1.12
	io-close-0.3.7
	io-lifetimes-1.0.10
	itoa-1.0.6
	js-sys-0.3.61
	kstring-2.0.0
	lazy_static-1.4.0
	libc-0.2.144
	libloading-0.8.0
	link-cplusplus-1.0.8
	linux-raw-sys-0.3.4
	lock_api-0.4.9
	log-0.4.17
	lsp-types-0.94.0
	memchr-2.5.0
	memmap2-0.5.10
	minimal-lexical-0.2.1
	miniz_oxide-0.6.2
	mio-0.8.6
	nom-7.1.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.15.0
	num_threads-0.1.6
	once_cell-1.17.1
	parking_lot-0.12.1
	parking_lot_core-0.9.7
	percent-encoding-2.2.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	proc-macro2-1.0.56
	prodash-23.1.2
	pulldown-cmark-0.9.2
	quickcheck-1.0.3
	quote-1.0.26
	rand-0.8.5
	rand_core-0.6.4
	redox_syscall-0.2.16
	redox_syscall-0.3.5
	regex-1.8.1
	regex-automata-0.1.10
	regex-syntax-0.6.29
	regex-syntax-0.7.1
	ropey-1.6.0
	rustix-0.37.15
	ryu-1.0.13
	same-file-1.0.6
	scopeguard-1.1.0
	scratch-1.0.5
	serde-1.0.163
	serde_derive-1.0.163
	serde_json-1.0.96
	serde_repr-0.1.12
	serde_spanned-0.6.1
	sha1_smol-1.0.0
	signal-hook-0.3.15
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.1
	signal-hook-tokio-0.3.1
	slab-0.4.8
	slotmap-1.0.6
	smallvec-1.10.0
	smartstring-1.0.1
	smawk-0.3.1
	socket2-0.4.9
	static_assertions-1.1.0
	str-buf-1.0.6
	str_indices-0.4.1
	syn-1.0.109
	syn-2.0.15
	tempfile-3.5.0
	termcolor-1.2.0
	termini-1.0.0
	textwrap-0.16.0
	thiserror-1.0.40
	thiserror-impl-1.0.40
	thread_local-1.1.7
	threadpool-1.8.1
	time-0.3.20
	time-core-0.1.0
	time-macros-0.2.8
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	tokio-1.28.1
	tokio-macros-2.1.0
	tokio-stream-0.1.14
	toml-0.7.3
	toml_datetime-0.6.1
	toml_edit-0.19.8
	tree-sitter-0.20.10
	unicase-2.6.0
	unicode-bidi-0.3.13
	unicode-bom-2.0.2
	unicode-general-category-0.6.0
	unicode-ident-1.0.8
	unicode-linebreak-0.1.4
	unicode-normalization-0.1.22
	unicode-segmentation-1.10.1
	unicode-width-0.1.10
	url-2.3.1
	version_check-0.9.4
	walkdir-2.3.3
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	which-4.4.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.48.0
	windows-sys-0.45.0
	windows-sys-0.48.0
	windows-targets-0.42.2
	windows-targets-0.48.0
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.42.2
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.42.2
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.42.2
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.42.2
	windows_x86_64_msvc-0.48.0
	winnow-0.4.1
"

inherit bash-completion-r1 cargo desktop xdg

DESCRIPTION="A post-modern text editor"
HOMEPAGE="
	https://helix-editor.com/
	https://github.com/helix-editor/helix
"
SRC_URI="
	https://github.com/helix-editor/helix/releases/download/${PV}/${P}-source.tar.xz -> ${P}.tar.xz
	$(cargo_crate_uris)
"

S="${WORKDIR}"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+grammar"

QA_FLAGS_IGNORED="
	usr/bin/hx
	usr/share/helix/runtime/grammars/.*\.so
"

DOCS=(
	README.md
	CHANGELOG.md
	book/
	docs/
)

src_compile() {
	use grammar || local -x HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1

	cargo_src_compile
}

src_install() {
	cargo_src_install --path helix-term

	rm -r runtime/grammars/.gitkeep || die
	rm -r runtime/grammars/sources || die

	insinto /usr/share/helix
	doins -r runtime

	dodoc -r "${DOCS[@]}"

	doicon -s 256x256 contrib/${PN}.png
	domenu contrib/Helix.desktop

	insinto /usr/share/metainfo
	doins contrib/Helix.appdata.xml

	newbashcomp contrib/completion/hx.bash hx

	insinto /usr/share/zsh/site-functions
	newins contrib/completion/hx.zsh _hx

	insinto /usr/share/fish/vendor_completions.d
	doins contrib/completion/hx.fish

	newenvd - 99helix <<< 'HELIX_RUNTIME="/usr/share/helix/runtime"'
}
