# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@0.7.20
	android_system_properties@0.1.5
	anyhow@1.0.68
	atty@0.2.14
	autocfg@1.1.0
	bitfield@0.14.0
	bitflags@1.3.2
	bumpalo@3.12.0
	byteorder@1.4.3
	cc@1.0.79
	cexpr@0.6.0
	cfg-if@1.0.0
	chrono@0.4.23
	clang-sys@1.6.0
	clap@4.1.4
	clap_derive@4.1.0
	clap_lex@0.3.1
	codespan-reporting@0.11.1
	colored@2.0.0
	core-foundation-sys@0.8.3
	cxx@1.0.89
	cxx-build@1.0.89
	cxxbridge-flags@1.0.89
	cxxbridge-macro@1.0.89
	either@1.8.1
	errno@0.2.8
	errno-dragonfly@0.1.2
	fastrand@1.8.0
	filedescriptor@0.8.2
	gag@1.0.0
	getset@0.1.2
	glob@0.3.1
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.2.6
	iana-time-zone@0.1.53
	iana-time-zone-haiku@0.1.1
	instant@0.1.12
	io-lifetimes@1.0.4
	is-terminal@0.4.2
	itertools@0.9.0
	js-sys@0.3.61
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.139
	libudev-sys@0.1.4
	link-cplusplus@1.0.8
	linux-raw-sys@0.1.4
	log@0.4.17
	memchr@2.5.0
	memoffset@0.8.0
	minimal-lexical@0.2.1
	nom@7.1.3
	num-integer@0.1.45
	num-traits@0.2.15
	once_cell@1.17.0
	os_str_bytes@6.4.1
	parse-display@0.1.2
	parse-display-derive@0.1.2
	paste@1.0.11
	peeking_take_while@0.1.2
	pkg-config@0.3.26
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.50
	quote@1.0.23
	redox_syscall@0.2.16
	regex@1.7.1
	regex-syntax@0.6.28
	remove_dir_all@0.5.3
	rpassword@4.0.5
	rustc-hash@1.1.0
	rustix@0.36.7
	scratch@1.0.3
	shlex@1.1.0
	strsim@0.10.0
	syn@1.0.107
	tempfile@3.3.0
	termcolor@1.2.0
	terminal_size@0.2.3
	thiserror@1.0.38
	thiserror-impl@1.0.38
	time@0.1.45
	udev@0.7.0
	unicode-ident@1.0.6
	unicode-width@0.1.10
	uuid@1.3.0
	version_check@0.9.4
	wasi@0.10.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.84
	wasm-bindgen-backend@0.2.84
	wasm-bindgen-macro@0.2.84
	wasm-bindgen-macro-support@0.2.84
	wasm-bindgen-shared@0.2.84
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.42.0
	windows_aarch64_gnullvm@0.42.1
	windows_aarch64_msvc@0.42.1
	windows_i686_gnu@0.42.1
	windows_i686_msvc@0.42.1
	windows_x86_64_gnu@0.42.1
	windows_x86_64_gnullvm@0.42.1
	windows_x86_64_msvc@0.42.1
"

# Upstream have a fork of bindgen and use cgit
declare -A GIT_CRATES=(
	[bindgen]="https://gitlab.com/Matt.Jolly/rust-bindgen-bcachefs;f773267b090bf16b9e8375fcbdcd8ba5e88806a8;rust-bindgen-bcachefs-%commit%/bindgen"
)

PYTHON_COMPAT=( python3_{10..12} )

inherit cargo flag-o-matic multiprocessing python-any-r1 toolchain-funcs unpacker

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="https://bcachefs.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://evilpiepirate.org/git/bcachefs-tools.git"
else
	MY_COMMIT=4d04fe42623a2f2b91a75cfa3d3503ab88e48acc
	SRC_URI="https://github.com/koverstreet/bcachefs-tools/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 BSD GPL-2 MIT"
SLOT="0"
IUSE="fuse test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/lz4
	dev-libs/libaio
	dev-libs/libsodium
	dev-libs/userspace-rcu
	sys-apps/keyutils
	sys-apps/util-linux
	sys-libs/zlib
	virtual/udev
	fuse? ( >=sys-fs/fuse-3.7.0 )
"

RDEPEND="${DEPEND}"

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
	sys-devel/clang
	virtual/rust
"

python_check_deps() {
	if use test; then
		python_has_version \
			"dev-python/pytest[${PYTHON_USEDEP}]" \
			"dev-python/pytest-xdist[${PYTHON_USEDEP}]"
	fi
	python_has_version "dev-python/docutils[${PYTHON_USEDEP}]"

}

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
		S="${S}/rust-src" cargo_live_src_unpack
	else
		default
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
	dosbin bcachefs fsck.bcachefs mkfs.bcachefs mount.bcachefs

	if use fuse; then
		dosbin mount.fuse.bcachefs
		newsbin fsck.bcachefs fsck.fuse.bcachefs
		newsbin mkfs.bcachefs mkfs.fuse.bcachefs
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
