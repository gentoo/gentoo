# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	anstream@0.3.2
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@1.0.2
	anstyle@1.0.2
	anyhow@1.0.75
	atty@0.2.14
	autocfg@1.1.0
	bitfield@0.14.0
	bitflags@1.3.2
	bitflags@2.4.1
	byteorder@1.5.0
	cc@1.0.83
	cexpr@0.6.0
	cfg-if@1.0.0
	chrono@0.4.31
	clang-sys@1.6.1
	clap_builder@4.3.24
	clap_complete@4.3.2
	clap_derive@4.3.12
	clap_lex@0.5.0
	clap@4.3.24
	colorchoice@1.0.0
	colored@2.0.4
	either@1.9.0
	errno-dragonfly@0.1.2
	errno@0.2.8
	errno@0.3.7
	fastrand@2.0.1
	filedescriptor@0.8.2
	gag@1.0.0
	getset@0.1.2
	glob@0.3.1
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.3.3
	io-lifetimes@1.0.11
	is-terminal@0.4.9
	itertools@0.9.0
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.150
	libudev-sys@0.1.4
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.11
	log@0.4.20
	memchr@2.6.4
	memoffset@0.8.0
	minimal-lexical@0.2.1
	nom@7.1.3
	num-traits@0.2.17
	once_cell@1.18.0
	parse-display-derive@0.1.2
	parse-display@0.1.2
	paste@1.0.14
	peeking_take_while@0.1.2
	pkg-config@0.3.27
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.69
	quote@1.0.33
	redox_syscall@0.4.1
	regex-automata@0.4.3
	regex-syntax@0.6.29
	regex-syntax@0.8.2
	regex@1.10.2
	rpassword@4.0.5
	rustc-hash@1.1.0
	rustix@0.37.27
	rustix@0.38.25
	shlex@1.2.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.39
	tempfile@3.8.1
	terminal_size@0.2.6
	thiserror-impl@1.0.50
	thiserror@1.0.50
	udev@0.7.0
	unicode-ident@1.0.12
	utf8parse@0.2.1
	uuid@1.6.1
	version_check@0.9.4
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	windows-sys@0.48.0
	windows-targets@0.48.5
"

# Upstream have a fork of bindgen and use cgit
declare -A GIT_CRATES=(
	[bindgen]="https://gitlab.com/Matt.Jolly/rust-bindgen-bcachefs;f773267b090bf16b9e8375fcbdcd8ba5e88806a8;rust-bindgen-bcachefs-%commit%/bindgen"
)

LLVM_MAX_SLOT=17
PYTHON_COMPAT=( python3_{10..12} )

inherit cargo flag-o-matic llvm multiprocessing python-any-r1 toolchain-funcs unpacker

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="https://bcachefs.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://evilpiepirate.org/git/bcachefs-tools.git"
else
	SRC_URI="https://github.com/koverstreet/bcachefs-tools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 BSD GPL-2 MIT"
SLOT="0"
IUSE="fuse test"
RESTRICT="!test? ( test )"

DEPEND="
	fuse? ( >=sys-fs/fuse-3.7.0 )
	app-arch/lz4:=
	dev-libs/libaio
	dev-libs/libsodium:=
	dev-libs/userspace-rcu:=
	sys-apps/keyutils
	sys-apps/util-linux
	sys-libs/zlib
	virtual/udev
"

RDEPEND="${DEPEND}"

# Clang is required for bindgen
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/docutils[${PYTHON_USEDEP}]
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		)
	')
	$(unpacker_src_uri_depends)
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1))
	virtual/pkgconfig
	virtual/rust
"

llvm_check_deps() {
	has_version -b "sys-devel/clang:${LLVM_SLOT}"
}

python_check_deps() {
	if use test; then
		python_has_version \
			"dev-python/pytest[${PYTHON_USEDEP}]" \
			"dev-python/pytest-xdist[${PYTHON_USEDEP}]"
	fi
	python_has_version "dev-python/docutils[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
		S="${S}/rust-src" cargo_live_src_unpack
	else
		unpack ${P}.tar.gz
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-i Makefile || die
	# Patch our cargo-ebuild patch definition to pretend that our GIT_CRATE is upstream's URI.
	if ! [[ ${PV} == "9999" ]]; then
		sed -e 's https://gitlab.com/Matt.Jolly/rust-bindgen-bcachefs https://evilpiepirate.org/git/rust-bindgen.git ' \
			-i "${WORKDIR}/cargo_home/config" || die
	fi
	append-lfs-flags
}

src_compile() {
	use fuse && export BCACHEFS_FUSE=1
	export BUILD_VERBOSE=1
	export VERSION=${PV}

	default

	use test && emake tests
}

src_test() {
	if ! use fuse; then
		EPYTEST_IGNORE=( tests/test_fuse.py )
	fi
	EPYTEST_DESELECT=(
		# Valgrind
		'tests/test_fixture.py::test_read_after_free'
		'tests/test_fixture.py::test_undefined'
		'tests/test_fixture.py::test_write_after_free'
		'tests/test_fixture.py::test_undefined_branch'
		'tests/test_fixture.py::test_leak'
		'tests/test_fixture.py::test_check'
		# Fails in portage because of usersandbox; ensure that these pass before bumping!
		'tests/test_basic.py::test_format'
		'tests/test_basic.py::test_fsck'
		'tests/test_basic.py::test_list'
		'tests/test_basic.py::test_list_inodes'
		'tests/test_basic.py::test_list_dirent'
	)
	epytest -v -n "$(makeopts_jobs)"
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

	doman bcachefs.8
}

pkg_postinst() {
	if use fuse; then
		ewarn "FUSE support is experimental."
		ewarn "Please only use it for development purposes at the risk of losing your data."
		ewarn "You have been warned."
	fi
}
