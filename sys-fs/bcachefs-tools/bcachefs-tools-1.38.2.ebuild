# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android_system_properties@0.1.5
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.89
	ascii@1.1.0
	autocfg@1.5.0
	bindgen@0.72.1
	bitfield@0.14.0
	bitflags@1.3.2
	bitflags@2.11.0
	bumpalo@3.19.1
	cc@1.2.55
	cexpr@0.6.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.43
	chunked_transfer@1.5.0
	clang-sys@1.8.1
	clap@4.5.20
	clap_builder@4.5.20
	clap_complete@4.5.33
	clap_derive@4.5.18
	clap_lex@0.7.2
	colorchoice@1.0.2
	core-foundation-sys@0.8.7
	crossterm@0.28.1
	either@1.13.0
	env_logger@0.10.2
	equivalent@1.0.2
	errno@0.3.9
	fiemap@0.2.0
	find-msvc-tools@0.1.9
	fuser@0.17.0
	getrandom@0.2.17
	glob@0.3.1
	hashbrown@0.16.1
	heck@0.5.0
	httpdate@1.0.3
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	indexmap@2.13.0
	is_terminal_polyfill@1.70.1
	itertools@0.12.1
	itoa@1.0.17
	js-sys@0.3.85
	libc@0.2.180
	libloading@0.8.5
	libudev-sys@0.1.4
	linux-raw-sys@0.4.14
	lock_api@0.4.14
	log@0.4.22
	memchr@2.7.4
	memoffset@0.9.1
	minimal-lexical@0.2.1
	mio@1.1.1
	nix@0.30.1
	nom@7.1.3
	num-traits@0.2.19
	num_enum@0.7.5
	num_enum_derive@0.7.5
	once_cell@1.20.2
	owo-colors@4.1.0
	page_size@0.6.0
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	paste@1.0.15
	pkg-config@0.3.31
	prettyplease@0.2.22
	proc-macro-crate@3.4.0
	proc-macro2@1.0.87
	quote@1.0.37
	redox_syscall@0.5.18
	ref-cast-impl@1.0.25
	ref-cast@1.0.25
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.0
	rustc-hash@2.1.1
	rustix@0.38.37
	rustversion@1.0.17
	ryu@1.0.22
	scopeguard@1.2.0
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.143
	shlex@1.3.0
	signal-hook-mio@0.2.5
	signal-hook-registry@1.4.8
	signal-hook@0.3.18
	smallvec@1.15.1
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.87
	terminal_size@0.4.0
	tiny_http@0.12.0
	toml_datetime@0.7.5+spec-1.1.0
	toml_edit@0.23.10+spec-1.0.0
	toml_parser@1.0.9+spec-1.1.0
	udev@0.7.0
	unicode-ident@1.0.13
	utf8parse@0.2.2
	uuid@1.10.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasm-bindgen-macro-support@0.2.108
	wasm-bindgen-macro@0.2.108
	wasm-bindgen-shared@0.2.108
	wasm-bindgen@0.2.108
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
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.14
	zerocopy-derive@0.8.27
	zerocopy@0.8.27
	zeroize@1.8.1
	zeroize_derive@1.4.2
"

LLVM_COMPAT=( {17..21} )
MODULES_INITRAMFS_IUSE=+initramfs
MODDULES_KERNEL_MIN=6.16
PYTHON_COMPAT=( python3_{11..14} )
RUST_MIN_VER="1.85.0"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kentoverstreet.asc

inherit cargo flag-o-matic linux-mod-r1 llvm-r2 multiprocessing python-any-r1
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
IUSE="debug verify-sig +modules"
RESTRICT="test"

DEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/libaio
	dev-libs/libsodium:=
	dev-libs/userspace-rcu:=
	sys-apps/keyutils:=
	sys-apps/util-linux
	virtual/zlib:=
	virtual/udev
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

	sed -i s/^VERSION=.*$/VERSION=${PV}/ Makefile || die
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-i Makefile || die
	append-lfs-flags
}

src_configure() {
	cargo_src_configure
	use modules && emake DESTDIR="${WORKDIR}" PREFIX="/module" install_dkms
}

src_compile() {
	export BUILD_VERBOSE=1
	export VERSION=${PV}

	local module_s="module/src/${PN%-*}-${PV}"
	local modlist=( "bcachefs=:../${module_s}:../${module_s}/src/fs/bcachefs" )
	local modargs=(
		KDIR=${KV_OUT_DIR}
	)

	# Makefile calls `cargo` directly, so make sure we set our rustflags (etc)
	cargo_env emake -j$(get_makeopts_jobs) bcachefs || die
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
