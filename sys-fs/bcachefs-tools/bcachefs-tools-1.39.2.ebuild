# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.4
	android_system_properties@0.1.5
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.103
	arbitrary@1.4.2
	ascii@1.1.0
	autocfg@1.5.1
	bindgen@0.72.1
	bitfield@0.14.0
	bitflags@1.3.2
	bitflags@2.13.0
	bumpalo@3.19.1
	bytemuck@1.25.0
	bytemuck_derive@1.10.2
	cc@1.2.66
	cexpr@0.6.0
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	chrono@0.4.45
	chunked_transfer@1.5.0
	clang-sys@1.8.1
	clap@4.6.1
	clap_builder@4.6.0
	clap_complete@4.5.33
	clap_derive@4.6.1
	clap_lex@1.1.0
	clipboard-win@5.4.1
	colorchoice@1.0.5
	core-foundation-sys@0.8.7
	crossterm@0.29.0
	derive_arbitrary@1.4.2
	dissimilar@1.0.11
	document-features@0.2.12
	either@1.16.0
	endian-type@0.1.2
	env_logger@0.10.2
	equivalent@1.0.2
	errno@0.3.14
	error-code@3.3.2
	fd-lock@4.0.4
	fiemap@0.2.0
	find-msvc-tools@0.1.9
	fuser@0.17.0
	getrandom@0.4.3
	glob@0.3.3
	hashbrown@0.17.1
	heck@0.5.0
	home@0.5.11
	httpdate@1.0.3
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	indexmap@2.14.0
	is_terminal_polyfill@1.70.2
	itertools@0.12.1
	itoa@1.0.18
	js-sys@0.3.85
	libc@0.2.186
	libloading@0.8.5
	libudev-sys@0.1.4
	linux-raw-sys@0.12.1
	litrs@1.0.0
	lock_api@0.4.14
	log@0.4.33
	memchr@2.8.3
	memoffset@0.9.1
	minimal-lexical@0.2.1
	mio@1.2.1
	nibble_vec@0.1.0
	nix@0.30.1
	nom@7.1.3
	num-traits@0.2.19
	num_enum@0.7.5
	num_enum_derive@0.7.5
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	owo-colors@4.1.0
	page_size@0.6.0
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	paste-test-suite@0.0.0
	paste@1.0.15
	pkg-config@0.3.33
	prettyplease@0.2.37
	proc-macro-crate@3.5.0
	proc-macro2@1.0.106
	quote@1.0.46
	r-efi@6.0.0
	radix_trie@0.2.1
	redox_syscall@0.5.18
	ref-cast-impl@1.0.25
	ref-cast@1.0.25
	regex-automata@0.4.14
	regex-syntax@0.8.11
	regex@1.12.4
	rustc-demangle@0.1.27
	rustc-hash@2.1.2
	rustix@1.1.4
	rustversion@1.0.22
	rustyline@17.0.2
	scopeguard@1.2.0
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.150
	serde_spanned@1.1.1
	serde_test@1.0.177
	shlex@1.3.0
	shlex@2.0.1
	signal-hook-mio@0.2.5
	signal-hook-registry@1.4.8
	signal-hook@0.3.18
	smallvec@1.15.2
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.118
	target-triple@1.0.0
	termcolor@1.4.1
	terminal_size@0.4.4
	tiny_http@0.12.0
	toml@1.0.6+spec-1.1.0
	toml_datetime@1.1.1+spec-1.1.0
	toml_edit@0.25.10+spec-1.1.0
	toml_parser@1.1.2+spec-1.1.0
	toml_writer@1.1.1+spec-1.1.0
	trybuild@1.0.116
	udev@0.7.0
	unicode-ident@1.0.24
	unicode-segmentation@1.13.3
	unicode-width@0.2.2
	utf8parse@0.2.2
	uuid@1.23.4
	wasi@0.11.1+wasi-snapshot-preview1
	wasm-bindgen-macro-support@0.2.108
	wasm-bindgen-macro@0.2.108
	wasm-bindgen-shared@0.2.108
	wasm-bindgen@0.2.108
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
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
	winnow@0.7.15
	winnow@1.0.3
	zerocopy-derive@0.8.53
	zerocopy@0.8.53
	zeroize@1.9.0
	zeroize_derive@1.5.0
	zmij@1.0.21
"

LLVM_COMPAT=( {17..21} )
MODULES_INITRAMFS_IUSE=+initramfs
MODULES_KERNEL_MIN=6.16
MODULES_OPTIONAL_IUSE=+modules
PYTHON_COMPAT=( python3_{11..14} )
RUST_MIN_VER="1.85.0"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kentoverstreet.asc

inherit cargo flag-o-matic linux-mod-r1 llvm-r2 python-any-r1
inherit shell-completion sysroot toolchain-funcs unpacker verify-sig

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="https://bcachefs.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://evilpiepirate.org/git/bcachefs-tools.git"
else
	SRC_URI="https://evilpiepirate.org/bcachefs-tools/bcachefs-tools-${PV}.tar.zst
		${CARGO_CRATE_URIS}
	"
	SRC_URI+=" verify-sig? ( https://evilpiepirate.org/bcachefs-tools/bcachefs-tools-${PV}.tar.sign )"
	S="${WORKDIR}/${P}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT Unicode-DFS-2016"
SLOT="0"
IUSE="debug llvm-libunwind verify-sig"
RESTRICT="test"

DEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/libaio
	dev-libs/libsodium:=
	dev-libs/userspace-rcu:=
	sys-apps/keyutils:=
	sys-apps/util-linux
	llvm-libunwind? ( llvm-runtimes/libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
	virtual/udev
	virtual/zlib:=
"

RDEPEND="${DEPEND}"

# Clang is required for bindgen
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/docutils[${PYTHON_USEDEP}]
	')
	$(unpacker_src_uri_depends)
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	elibc_musl? ( >=sys-libs/musl-1.2.5 )
	virtual/pkgconfig
	modules? ( >=sys-kernel/linux-headers-6.16.0 )
	verify-sig? ( >=sec-keys/openpgp-keys-kentoverstreet-20241012 )
"

QA_FLAGS_IGNORED="/sbin/bcachefs"

python_check_deps() {
	python_has_version "dev-python/docutils[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm-r2_pkg_setup
	python-any-r1_pkg_setup
	rust_pkg_setup
	if use modules; then
		# grep -r 'depends on\|select ' ${S}/libbcachefs/Kconfig | grep -v '^#'
		local CONFIG_CHECK="
			!BCACHEFS_FS
			BLOCK
			EXPORTFS
			CRC32
			CRC64
			FS_POSIX_ACL
			LZ4_COMPRESS
			LZ4_DECOMPRESS
			LZ4HC_COMPRESS
			ZLIB_DEFLATE
			ZLIB_INFLATE
			ZSTD_COMPRESS
			ZSTD_DECOMPRESS
			CRYPTO_LIB_SHA256
			CRYPTO_LIB_CHACHA
			CRYPTO_LIB_POLY1305
			KEYS
			RAID6_PQ
			RUST
			XOR_BLOCKS
			XXHASH
			SYMBOLIC_ERRNAME
		"
		use debug && CONFIG_CHECK+="
			DEBUG_INFO
			FRAME_POINTER
			!DEBUG_INFO_REDUCED
		"
		linux-mod-r1_pkg_setup
	fi
}

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
		S="${S}/src" cargo_live_src_unpack
	else
		# Upstream signs the uncompressed tarball
		if use verify-sig; then
			einfo "Unpacking ${P}.tar.zst ..."
			verify-sig_verify_detached - "${DISTDIR}"/${P}.tar.sign \
				< <(zstd -fdc "${DISTDIR}"/${P}.tar.zst | tee >(tar -xf -))
			assert "Unpack failed"
		fi
		unpacker ${P}.tar.zst
		cargo_src_unpack
	fi

}

src_prepare() {
	default
	tc-export CC

	echo "${PV}" > .version || die
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-i Makefile || die

	if use llvm-libunwind; then
		sed -i s/libunwind// Makefile || die
	fi

	append-lfs-flags
}

src_configure() {
	cargo_src_configure

	MODULE_SRC="module/${PN%-*}-${PV}"
	use modules && emake DESTDIR="${WORKDIR}" DKMSDIR="/${MODULE_SRC}" install_dkms
}

src_compile() {
	export BUILD_VERBOSE=1
	export VERSION=${PV}

	local modlist=( "bcachefs=:../${MODULE_SRC}:../${MODULE_SRC}/src/fs/bcachefs" )
	local modargs=(
		KDIR=${KV_OUT_DIR}
	)

	# Makefile calls `cargo` directly, so make sure we set our rustflags (etc)
	cargo_env emake bcachefs || die
	use modules && linux-mod-r1_src_compile

	# Recent versions mangle the 'bcachefs' symbolic link, work around it.
	[[ -e bcachefs ]] && die "bcachefs symlink is valid, please remove workaround"
	ln -rsf target/release/bcachefs bcachefs || die

	local shell
	for shell in bash fish zsh; do
		sysroot_try_run_prefixed ./bcachefs completions ${shell} > ${shell}.completion || die
	done
}

src_install() {
	into /
	dosbin bcachefs

	dosym bcachefs /sbin/fsck.bcachefs
	dosym bcachefs /sbin/mkfs.bcachefs
	dosym bcachefs /sbin/mount.bcachefs

	# Uses a crate-based implementation of FUSE, no dependency on sys-fs/fuse and unconditionally included.
	dosym bcachefs /sbin/fsck.fuse.bcachefs
	dosym bcachefs /sbin/mkfs.fuse.bcachefs
	dosym bcachefs /sbin/mount.fuse.bcachefs

	newbashcomp bash.completion bcachefs
	newfishcomp fish.completion bcachefs.fish
	newzshcomp zsh.completion _bcachefs

	doman bcachefs.8

	use modules && linux-mod-r1_src_install
}
