# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.1
	aho-corasick@1.1.5
	allocator-api2@0.2.21
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.104
	approx@0.5.1
	autocfg@1.5.1
	base64@0.22.1
	bindgen@0.72.1
	bitflags@1.3.2
	bitflags@2.13.2
	bumpalo@3.20.3
	by_address@1.2.1
	bytemuck@1.25.2
	byteorder@1.5.0
	castaway@0.2.4
	cexpr@0.6.0
	cfg-if@1.0.5
	cfg_aliases@0.2.2
	chacha20@0.10.2
	clang-sys@1.9.1
	clap@4.6.7
	clap_builder@4.6.7
	clap_lex@1.1.1
	colorchoice@1.0.5
	compact_str@0.9.1
	console@0.16.6
	cpufeatures@0.3.1
	crc32c@0.6.8
	crc32fast@1.5.2
	darling@0.24.1
	darling_core@0.24.1
	darling_macro@0.24.1
	data-encoding@2.11.1
	defmt-macros@1.1.1
	defmt-parser@1.0.0
	defmt@1.1.1
	deranged@0.5.8
	devicemapper-sys@0.3.3
	devicemapper@0.34.8
	downcast@0.11.0
	duct@1.1.2
	either@1.18.0
	encode_unicode@1.0.0
	env_filter@2.0.0
	env_logger@0.11.11
	equivalent@1.0.2
	errno@0.3.14
	exitcode@1.1.2
	fastrand@2.5.0
	fixedbitset@0.5.7
	flate2@1.1.10
	foldhash@0.2.0
	fragile@2.1.0
	futures-core@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	getrandom@0.3.4
	getrandom@0.4.3
	glob@0.3.4
	hashbrown@0.16.1
	hashbrown@0.17.1
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.5.3
	ident_case@1.0.1
	indicatif@0.18.6
	indoc@2.0.7
	instability@0.3.13
	io-lifetimes@1.0.11
	io-uring@0.7.15
	iovec@0.1.4
	is_terminal_polyfill@1.70.2
	itertools@0.13.0
	itertools@0.14.0
	itoa@1.0.18
	jiff-core@0.1.1
	jiff-static@0.2.37
	jiff@0.2.37
	js-sys@0.3.105
	kasuari@0.4.12
	libc@0.2.189
	libloading@0.8.9
	libm@0.2.16
	libudev-sys@0.1.4
	line-clipping@0.3.8
	linux-raw-sys@0.12.1
	log@0.4.34
	lru@0.18.4
	memchr@2.8.3
	minimal-lexical@0.2.1
	miniz_oxide@0.9.1
	mockall@0.13.1
	mockall_derive@0.13.1
	nix@0.31.3
	nom@7.1.3
	nom@8.0.0
	num-conv@0.2.2
	num-derive@0.4.2
	num-traits@0.2.19
	num_cpus@1.17.0
	num_threads@0.1.7
	numtoa@0.2.4
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	os_pipe@1.2.3
	palette@0.7.7
	palette_derive@0.7.7
	palette_math@0.7.7
	pin-project-lite@0.2.17
	pkg-config@0.3.34
	portable-atomic-util@0.2.8
	portable-atomic@1.15.0
	powerfmt@0.2.0
	ppv-lite86@0.2.21
	predicates-core@1.0.10
	predicates-tree@1.0.13
	predicates@3.1.4
	prettyplease@0.2.37
	proc-macro2@1.0.107
	quick-xml@0.38.4
	quickcheck@1.1.0
	quickcheck_macros@1.2.0
	quote@1.0.47
	r-efi@5.3.0
	r-efi@6.0.0
	rand@0.10.2
	rand@0.9.5
	rand_chacha@0.9.0
	rand_core@0.10.1
	rand_core@0.9.5
	rangemap@1.8.0
	ratatui-core@0.1.2
	ratatui-termion@0.1.2
	ratatui-widgets@0.3.2
	ratatui@0.30.2
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	retry@2.2.0
	roaring@0.11.5
	rustc-hash@2.1.3
	rustc_version@0.4.1
	rustix@1.1.5
	rustversion@1.0.23
	ryu@1.0.23
	semver@1.0.28
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	shared_child@1.1.2
	shared_thread@0.2.1
	shlex@1.3.0
	sigchld@0.2.5
	signal-hook-registry@1.4.8
	signal-hook@0.4.4
	simd-adler32@0.3.10
	slab@0.4.12
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.28.0
	strum_macros@0.28.0
	syn@2.0.119
	syn@3.0.6
	tempfile@3.27.0
	termion@4.0.6
	termtree@0.5.1
	thiserror-impl@2.0.20
	thiserror@2.0.20
	time-core@0.1.9
	time@0.3.55
	udev@0.9.3
	unicode-ident@1.0.26
	unicode-segmentation@1.13.3
	unicode-truncate@2.0.1
	unicode-width@0.2.2
	unit-prefix@0.5.2
	utf8parse@0.2.2
	wasip2@1.0.4+wasi-0.2.12
	wasm-bindgen-macro-support@0.2.128
	wasm-bindgen-macro@0.2.128
	wasm-bindgen-shared@0.2.128
	wasm-bindgen@0.2.128
	web-time@1.1.0
	windows-link@0.2.1
	windows-sys@0.48.0
	windows-sys@0.61.2
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	wit-bindgen@0.57.1
	zerocopy-derive@0.8.57
	zerocopy@0.8.57
	zlib-rs@0.6.8
"

LLVM_COMPAT=( {19..22} )
RUST_MIN_VER="1.90.0"

inherit cargo llvm-r2

DESCRIPTION="A suite of tools for thin provisioning on Linux"
HOMEPAGE="https://github.com/jthornber/thin-provisioning-tools"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/jthornber/thin-provisioning-tools.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/jthornber/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	if [[ ${PKGBUMPING} != ${PVR} ]]; then
		SRC_URI+=" ${CARGO_CRATE_URIS}"
	fi
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
IUSE="io-uring"

RDEPEND="virtual/libudev:="
# libdevmapper.h needed for devicemapper-sys crate
DEPEND="
	${RDEPEND}
	sys-fs/lvm2
"
# Needed for bindgen
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	virtual/pkgconfig
"

DOCS=(
	CHANGES
	COPYING
	README.md
	doc/TODO.md
	doc/thinp-version-2/notes.md
)

# Rust
QA_FLAGS_IGNORED="usr/sbin/pdata_tools"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.6-build-with-cargo.patch"
)

pkg_setup() {
	llvm-r2_pkg_setup
	rust_pkg_setup
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	local myfeatures=( $(usev io-uring io_uring) )
	cargo_src_configure
}

src_install() {
	emake \
		DESTDIR="${D}" \
		DATADIR="${ED}/usr/share" \
		PDATA_TOOLS="$(cargo_target_dir)/pdata_tools" \
		install

	einstalldocs
}
