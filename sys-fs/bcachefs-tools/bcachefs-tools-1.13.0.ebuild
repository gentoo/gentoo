# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.89
	bindgen@0.69.5
	bitfield@0.14.0
	bitflags@1.3.2
	bitflags@2.6.0
	cc@1.1.28
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.8.1
	clap@4.5.20
	clap_builder@4.5.20
	clap_complete@4.5.33
	clap_derive@4.5.18
	clap_lex@0.7.2
	colorchoice@1.0.2
	either@1.13.0
	env_logger@0.10.2
	errno-dragonfly@0.1.2
	errno@0.2.8
	errno@0.3.9
	glob@0.3.1
	heck@0.5.0
	home@0.5.9
	is_terminal_polyfill@1.70.1
	itertools@0.12.1
	lazy_static@1.5.0
	lazycell@1.3.0
	libc@0.2.159
	libloading@0.8.5
	libudev-sys@0.1.4
	linux-raw-sys@0.4.14
	log@0.4.22
	memchr@2.7.4
	minimal-lexical@0.2.1
	nom@7.1.3
	once_cell@1.20.2
	owo-colors@4.1.0
	paste@1.0.15
	pkg-config@0.3.31
	prettyplease@0.2.22
	proc-macro2@1.0.87
	quote@1.0.37
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.0
	rustc-hash@1.1.0
	rustix@0.38.37
	rustversion@1.0.17
	shlex@1.3.0
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.79
	terminal_size@0.4.0
	udev@0.7.0
	unicode-ident@1.0.13
	utf8parse@0.2.2
	uuid@1.10.0
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	zeroize@1.8.1
	zeroize_derive@1.4.2
"

LLVM_COMPAT=( {16..18} )
PYTHON_COMPAT=( python3_{10..13} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kentoverstreet.asc
inherit cargo flag-o-matic llvm-r1 python-any-r1 shell-completion toolchain-funcs unpacker verify-sig

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="https://bcachefs.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://evilpiepirate.org/git/bcachefs-tools.git"
else
	SRC_URI="https://evilpiepirate.org/bcachefs-tools/bcachefs-tools-${PV}.tar.zst
		${CARGO_CRATE_URIS}"
	SRC_URI+=" verify-sig? ( https://evilpiepirate.org/bcachefs-tools/bcachefs-tools-${PV}.tar.sign )"
	S="${WORKDIR}/${P}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="Apache-2.0 BSD GPL-2 MIT"
SLOT="0"
IUSE="fuse verify-sig"
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
		sys-devel/clang:${LLVM_SLOT}
	')
	elibc_musl? ( >=sys-libs/musl-1.2.5 )
	virtual/pkgconfig
	virtual/rust
	verify-sig? ( >=sec-keys/openpgp-keys-kentoverstreet-20241012 )
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
		unpacker ${P}.tar.zst
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

	# This version mangles the symbolic link,
	# please check if this can be removed before bumping
	rm "${S}"/bcachefs
	ln -s "${S}"/target/release/bcachefs bcachefs

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
