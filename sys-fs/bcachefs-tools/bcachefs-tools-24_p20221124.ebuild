# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.19
	android_system_properties-0.1.5
	ansi_term-0.12.1
	anyhow-1.0.66
	atty-0.2.14
	autocfg-1.1.0
	bindgen-0.59.2
	bitfield-0.13.2
	bitflags-1.3.2
	bumpalo-3.11.1
	byteorder-1.4.3
	camino-1.1.1
	cc-1.0.76
	cexpr-0.6.0
	cfg-if-1.0.0
	chrono-0.4.23
	clang-sys-1.4.0
	clap-2.34.0
	codespan-reporting-0.11.1
	core-foundation-sys-0.8.3
	cxx-1.0.82
	cxx-build-1.0.82
	cxxbridge-flags-1.0.82
	cxxbridge-macro-1.0.82
	either-1.8.0
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.8.0
	filedescriptor-0.8.2
	gag-1.0.0
	getset-0.1.2
	glob-0.3.0
	heck-0.3.3
	hermit-abi-0.1.19
	iana-time-zone-0.1.53
	iana-time-zone-haiku-0.1.1
	instant-0.1.12
	itertools-0.9.0
	itoa-1.0.4
	js-sys-0.3.60
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.137
	libudev-sys-0.1.4
	link-cplusplus-1.0.7
	log-0.4.17
	matchers-0.0.1
	memchr-2.5.0
	memoffset-0.5.6
	minimal-lexical-0.2.1
	nom-7.1.1
	num-integer-0.1.45
	num-traits-0.2.15
	once_cell-1.16.0
	parse-display-0.1.2
	parse-display-derive-0.1.2
	peeking_take_while-0.1.2
	pin-project-lite-0.2.9
	pkg-config-0.3.26
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.47
	quote-1.0.21
	redox_syscall-0.2.16
	regex-1.7.0
	regex-automata-0.1.10
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	rpassword-4.0.5
	rustc-hash-1.1.0
	ryu-1.0.11
	scratch-1.0.2
	serde_json-1.0.88
	serde-1.0.147
	sharded-slab-0.1.4
	shlex-1.1.0
	smallvec-1.10.0
	strsim-0.8.0
	structopt-0.3.26
	structopt-derive-0.4.18
	syn-1.0.103
	tempfile-3.3.0
	term_size-0.3.2
	termcolor-1.1.3
	textwrap-0.11.0
	thiserror-1.0.37
	thiserror-impl-1.0.37
	thread_local-1.1.4
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-log-0.1.3
	tracing-serde-0.1.3
	tracing-subscriber-0.2.25
	udev-0.4.0
	unicode-ident-1.0.5
	unicode-segmentation-1.10.0
	unicode-width-0.1.10
	uuid-0.8.2
	valuable-0.1.0
	vec_map-0.8.2
	version_check-0.9.4
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

PYTHON_COMPAT=( python3_{9..11} )

inherit cargo flag-o-matic multiprocessing python-any-r1 toolchain-funcs unpacker

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="https://bcachefs.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://evilpiepirate.org/git/bcachefs-tools.git"
else
	MY_COMMIT=48eefee7495c6e145f3fcfe6ab83f9e8bc27a1ec
	SRC_URI="https://evilpiepirate.org/git/bcachefs-tools.git/snapshot/bcachefs-tools-${MY_COMMIT}.tar.zst
		$(cargo_crate_uris ${CRATES})"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 BSD GPL-2 MIT"
SLOT="0"
IUSE="fuse test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/lz4
	app-arch/zstd
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
		local module
		for module in bch_bindgen mount; do
			S="${S}/rust-src/${module}" cargo_live_src_unpack
		done
	else
		unpacker bcachefs-tools-${MY_COMMIT}.tar.zst
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-e 's:pytest-3:/bin/true:g' \
		-i Makefile || die
	append-lfs-flags
}

src_compile() {
	use fuse && export BCACHEFS_FUSE=1
	export BUILD_VERBOSE=1
	export VERSION=${PV}

	default

	# Rust UUID-based mounter isn't in 'all' target, may as well use ebuild functions
	local module
	for module in bch_bindgen mount; do
		pushd "${S}/rust-src/${module}" > /dev/null || die
			LIBBCACHEFS_LIB="${S}" LIBBCACHEFS_INCLUDE="${S}" cargo_src_compile
		popd > /dev/null || die
	done

	ln -f "${S}/rust-src/mount/target/release/bcachefs-mount" "${S}/mount.bcachefs" || die

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

QA_FLAGS_IGNORED="usr/bin/mount.bcachefs"
# Raised upstream; we don't expect anything to link against this outside of bcachefs-tools bins, for now
QA_SONAME=".*libbcachefs.so"

src_install() {
	exeinto /usr/bin
	local file
	for file in bcachefs fsck.bcachefs mkfs.bcachefs mount.bcachefs mount.bcachefs.sh; do
		doexe $file
	done
	dolib.so libbcachefs.so
	doman bcachefs.8
}

pkg_postinst() {
	if use fuse; then
		ewarn "FUSE support is experimental."
		ewarn "Please only use it for development purposes at the risk of losing your data."
		ewarn "You have been warned."
	fi
}
