# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.82.0"

CRATES="
	adler2@2.0.1
	aho-corasick@1.1.3
	allocator-api2@0.2.21
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.13
	anyhow@1.0.100
	autocfg@1.5.0
	base64@0.22.1
	bindgen@0.71.1
	bitflags@2.10.0
	bumpalo@3.19.0
	bytemuck@1.24.0
	byteorder@1.5.0
	cassowary@0.3.0
	castaway@0.2.4
	cexpr@0.6.0
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clang-sys@1.8.1
	clap@4.5.50
	clap_builder@4.5.50
	clap_lex@0.7.6
	colorchoice@1.0.4
	compact_str@0.8.1
	console@0.16.1
	crc32c@0.6.8
	crc32fast@1.5.0
	darling@0.20.11
	darling_core@0.20.11
	darling_macro@0.20.11
	data-encoding@2.9.0
	devicemapper-sys@0.3.2
	devicemapper@0.34.5
	downcast@0.11.0
	duct@1.1.0
	either@1.15.0
	encode_unicode@1.0.0
	env_filter@0.1.4
	env_logger@0.11.8
	env_logger@0.8.4
	equivalent@1.0.2
	errno@0.3.14
	exitcode@1.1.2
	fastrand@2.3.0
	fixedbitset@0.5.7
	flate2@1.1.4
	fnv@1.0.7
	foldhash@0.1.5
	fragile@2.0.1
	getrandom@0.2.16
	getrandom@0.3.4
	glob@0.3.3
	hashbrown@0.15.5
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.5.2
	ident_case@1.0.1
	indicatif@0.18.1
	indoc@2.0.7
	instability@0.3.9
	io-lifetimes@1.0.11
	io-uring@0.7.10
	iovec@0.1.4
	is_terminal_polyfill@1.70.2
	itertools@0.13.0
	itoa@1.0.15
	jiff-static@0.2.15
	jiff@0.2.15
	js-sys@0.3.81
	libc@0.2.177
	libloading@0.8.9
	libredox@0.1.10
	libudev-sys@0.1.4
	linux-raw-sys@0.11.0
	log@0.4.28
	lru@0.12.5
	memchr@2.7.6
	minimal-lexical@0.2.1
	miniz_oxide@0.8.9
	mockall@0.13.1
	mockall_derive@0.13.1
	nix@0.30.1
	nom@7.1.3
	nom@8.0.0
	num-derive@0.4.2
	num-traits@0.2.19
	num_cpus@1.17.0
	numtoa@0.2.4
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	os_pipe@1.2.3
	paste@1.0.15
	pkg-config@0.3.32
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	ppv-lite86@0.2.21
	predicates-core@1.0.9
	predicates-tree@1.0.12
	predicates@3.1.3
	prettyplease@0.2.37
	proc-macro2@1.0.101
	quick-xml@0.38.3
	quickcheck@1.0.3
	quickcheck_macros@1.1.0
	quote@1.0.41
	r-efi@5.3.0
	rand@0.8.5
	rand@0.9.2
	rand_chacha@0.9.0
	rand_core@0.6.4
	rand_core@0.9.3
	rangemap@1.6.0
	ratatui@0.29.0
	redox_syscall@0.5.18
	redox_termios@0.1.3
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	retry@2.1.0
	roaring@0.11.2
	rustc-hash@2.1.1
	rustc_version@0.4.1
	rustix@1.1.2
	rustversion@1.0.22
	ryu@1.0.20
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	shared_child@1.1.1
	shared_thread@0.2.0
	shlex@1.3.0
	sigchld@0.2.4
	signal-hook-registry@1.4.6
	signal-hook@0.3.18
	simd-adler32@0.3.7
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.107
	tempfile@3.23.0
	termion@4.0.5
	termtree@0.5.1
	thiserror-impl@2.0.17
	thiserror@2.0.17
	udev@0.9.3
	unicode-ident@1.0.20
	unicode-segmentation@1.12.0
	unicode-truncate@1.1.0
	unicode-width@0.1.14
	unicode-width@0.2.0
	unit-prefix@0.5.1
	utf8parse@0.2.2
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-backend@0.2.104
	wasm-bindgen-macro-support@0.2.104
	wasm-bindgen-macro@0.2.104
	wasm-bindgen-shared@0.2.104
	wasm-bindgen@0.2.104
	web-time@1.1.0
	windows-link@0.2.1
	windows-sys@0.48.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.48.5
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.53.1
	wit-bindgen@0.46.0
	zerocopy-derive@0.8.27
	zerocopy@0.8.27
"

LLVM_COMPAT=( {17..20} )

inherit cargo llvm-r1

DESCRIPTION="A suite of tools for thin provisioning on Linux"
HOMEPAGE="https://github.com/jthornber/thin-provisioning-tools"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/jthornber/thin-provisioning-tools.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/jthornber/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}
	"
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
	llvm-r1_pkg_setup
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
