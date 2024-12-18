# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	anstream@0.6.11
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.6
	anyhow@1.0.79
	autocfg@1.1.0
	bindgen@0.69.4
	bitfield@0.14.0
	bitflags@1.3.2
	bitflags@2.4.2
	byteorder@1.5.0
	cc@1.0.83
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.7.0
	clap@4.4.18
	clap_builder@4.4.18
	clap_complete@4.4.10
	clap_derive@4.4.7
	clap_lex@0.6.0
	colorchoice@1.0.0
	either@1.9.0
	env_logger@0.10.2
	errno-dragonfly@0.1.2
	errno@0.2.8
	errno@0.3.8
	glob@0.3.1
	heck@0.4.1
	home@0.5.9
	itertools@0.12.1
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.153
	libloading@0.8.1
	libudev-sys@0.1.4
	linux-raw-sys@0.4.13
	log@0.4.22
	memchr@2.7.1
	memoffset@0.8.0
	minimal-lexical@0.2.1
	nom@7.1.3
	once_cell@1.19.0
	owo-colors@4.0.0
	paste@1.0.14
	pkg-config@0.3.29
	prettyplease@0.2.16
	proc-macro2@1.0.78
	quote@1.0.35
	regex-automata@0.4.5
	regex-syntax@0.8.2
	regex@1.10.3
	rustc-hash@1.1.0
	rustix@0.38.34
	rustversion@1.0.17
	shlex@1.3.0
	strsim@0.10.0
	strum@0.26.2
	strum_macros@0.26.2
	syn@2.0.48
	terminal_size@0.3.0
	udev@0.7.0
	unicode-ident@1.0.12
	utf8parse@0.2.1
	uuid@1.7.0
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.0
	zeroize@1.8.1
	zeroize_derive@1.4.2
"

LLVM_COMPAT=( {16..18} )
PYTHON_COMPAT=( python3_{10..13} )

inherit cargo flag-o-matic llvm-r1 python-any-r1 shell-completion toolchain-funcs unpacker

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="https://bcachefs.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://evilpiepirate.org/bcachefs-tools.git"
else
	SRC_URI="https://github.com/koverstreet/bcachefs-tools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"
	S="${WORKDIR}/${P}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="Apache-2.0 BSD GPL-2 MIT"
SLOT="0"
IUSE="fuse"
RESTRICT="test"

DEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/libaio
	dev-libs/libsodium:=
	dev-libs/userspace-rcu:=
	sys-apps/keyutils:=
	sys-apps/util-linux
	sys-libs/zlib
	virtual/udev
	fuse? ( >=sys-fs/fuse-3.7.0 )
"

RDEPEND="${DEPEND}"
#
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
"

QA_FLAGS_IGNORED="/sbin/bcachefs"

python_check_deps() {
	python_has_version "dev-python/docutils[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm-r1_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
		S="${S}/rust-src" cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	tc-export CC

	# Version sed needed because the Makefile hasn't been bumped yet
	# Check if it is no longer before bumping
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-i Makefile || die
	append-lfs-flags
}

src_compile() {
	use fuse && export BCACHEFS_FUSE=1
	export BUILD_VERBOSE=1
	export VERSION=${PV}

	default

	local shell
	for shell in bash fish zsh; do
		./bcachefs completions ${shell} > ${shell}.completion || die
	done
}

src_install() {
	into /
	dosbin bcachefs

	dosym bcachefs /sbin/fsck.bcachefs
	dosym bcachefs /sbin/mkfs.bcachefs
	dosym bcachefs /sbin/mount.bcachefs

	if use fuse; then
		dosym bcachefs /sbin/fsck.fuse.bcachefs
		dosym bcachefs /sbin/mkfs.fuse.bcachefs
		dosym bcachefs /sbin/mount.fuse.bcachefs
	fi

	newbashcomp bash.completion bcachefs
	newfishcomp fish.completion bcachefs.fish
	newzshcomp zsh.completion _bcachefs

	doman bcachefs.8
}

pkg_postinst() {
	if use fuse; then
		ewarn "FUSE support is experimental."
		ewarn "Please only use it for development purposes at the risk of losing your data."
		ewarn "You have been warned."
	fi
}
