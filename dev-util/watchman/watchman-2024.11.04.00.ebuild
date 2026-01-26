# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# dev-cpp/edencommon
# dev-cpp/fb303
# dev-cpp/fbthrift
# dev-cpp/fizz
# dev-cpp/folly
# dev-cpp/mvfst
# dev-cpp/wangle
# dev-util/watchman

# TODO: Split into different variables then combine for each component?
# Not all is in rust/ dir.
# Rust components:
# - thirdparty/deelevate_binding/Cargo.toml
# - rust/watchman_client/Cargo.toml
# - rust/serde_bser/Cargo.toml
# - cli/Cargo.toml
CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	ansi_term@0.12.1
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	anyhow@1.0.93
	atty@0.2.14
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.10.1
	bitflags@1.3.2
	bitflags@2.6.0
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.8.0
	cc@1.1.37
	cfg-if@1.0.0
	chrono@0.4.38
	clap@2.34.0
	clap@4.5.20
	clap_builder@4.5.20
	clap_derive@4.5.18
	clap_lex@0.7.2
	colorchoice@1.0.3
	core-foundation-sys@0.8.7
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.11
	crossbeam-utils@0.8.20
	crossbeam@0.8.4
	deelevate@0.1.1
	dirs-sys@0.3.7
	dirs@4.0.0
	duct@0.13.7
	either@1.13.0
	embed-resource@1.8.0
	filedescriptor@0.7.3
	fnv@1.0.7
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.1.31
	futures@0.3.31
	getrandom@0.1.16
	getrandom@0.2.15
	gimli@0.31.1
	heck@0.3.3
	heck@0.5.0
	hermit-abi@0.1.19
	hermit-abi@0.3.9
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	js-sys@0.3.72
	jwalk@0.6.2
	lazy_static@1.5.0
	libc@0.2.162
	libredox@0.1.3
	lock_api@0.4.12
	log@0.4.22
	maplit@1.0.2
	maybe-uninit@2.0.0
	memchr@2.7.4
	memmem@0.1.1
	memoffset@0.6.5
	miniz_oxide@0.8.0
	mio@1.0.2
	nix@0.25.1
	nom@5.1.3
	ntapi@0.4.1
	num-bigint@0.2.6
	num-complex@0.2.4
	num-derive@0.2.5
	num-integer@0.1.46
	num-iter@0.1.45
	num-rational@0.2.4
	num-traits@0.2.19
	num@0.2.1
	object@0.36.5
	once_cell@1.20.2
	ordered-float@1.1.1
	os_pipe@1.2.1
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	pathsearch@0.2.0
	phf@0.11.2
	phf_codegen@0.11.2
	phf_generator@0.11.2
	phf_shared@0.11.2
	pin-project-lite@0.2.15
	pin-utils@0.1.0
	ppv-lite86@0.2.20
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@0.4.30
	proc-macro2@1.0.89
	quote@0.6.13
	quote@1.0.37
	rand@0.7.3
	rand@0.8.5
	rand_chacha@0.2.2
	rand_core@0.5.1
	rand_core@0.6.4
	rand_hc@0.2.0
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.7
	redox_users@0.4.6
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-demangle@0.1.24
	rustc_version@0.4.1
	ryu@1.0.18
	scopeguard@1.2.0
	semver-parser@0.7.0
	semver@0.9.0
	semver@1.0.23
	serde@1.0.214
	serde_bytes@0.11.15
	serde_derive@1.0.214
	serde_json@1.0.132
	shared_child@1.0.1
	shared_library@0.1.9
	shlex@1.3.0
	signal-hook-registry@1.4.2
	signal-hook@0.1.17
	siphasher@0.3.11
	slab@0.4.9
	smallvec@0.6.14
	smallvec@1.13.2
	socket2@0.5.7
	strsim@0.11.1
	strsim@0.8.0
	structopt-derive@0.4.18
	structopt@0.3.26
	syn@0.15.44
	syn@1.0.109
	syn@2.0.87
	sysinfo@0.30.13
	tabular@0.2.0
	terminfo@0.7.5
	termios@0.3.3
	termwiz@0.8.0
	textwrap@0.11.0
	thiserror-impl@1.0.69
	thiserror@1.0.69
	tokio-macros@2.4.0
	tokio-util@0.6.10
	tokio@1.41.1
	toml@0.5.11
	tracing-core@0.1.32
	tracing@0.1.40
	unicode-ident@1.0.13
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	unicode-xid@0.1.0
	utf8parse@0.1.1
	utf8parse@0.2.2
	vec_map@0.8.2
	vergen@3.2.0
	version_check@0.9.5
	vswhom-sys@0.1.2
	vswhom@0.1.0
	vtparse@0.2.2
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.9.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.95
	wasm-bindgen-macro-support@0.2.95
	wasm-bindgen-macro@0.2.95
	wasm-bindgen-shared@0.2.95
	wasm-bindgen@0.2.95
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows@0.52.0
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winreg@0.10.1
	xi-unicode@0.2.1
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit cargo cmake distutils-r1 tmpfiles

DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman/"
SRC_URI="https://github.com/facebook/watchman/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016 WTFPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="llvm-libunwind python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# See https://github.com/facebook/watchman/blob/main/CMakeLists.txt#L342 for libevent
RDEPEND="
	>=dev-libs/libfmt-8.1.1-r1:=
	dev-cpp/cpptoml:=
	dev-cpp/glog:=
	dev-libs/libevent:=
	dev-libs/libpcre2
	dev-libs/openssl:=
	~dev-cpp/edencommon-${PV}:=
	~dev-cpp/fb303-${PV}:=
	~dev-cpp/fbthrift-${PV}:=
	~dev-cpp/fizz-${PV}:=
	~dev-cpp/folly-${PV}:=
	~dev-cpp/wangle-${PV}:=
	llvm-libunwind? ( llvm-runtimes/libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
	python? ( ${PYTHON_DEPS} )
"
# TODO: Make gtest test-only (needs a fair bit of patching)
DEPEND="
	${RDEPEND}
	dev-cpp/gtest
"

PATCHES=(
	"${FILESDIR}"/${PN}-2022.02.28.00-libatomic.patch
	"${FILESDIR}"/${PN}-2022.08.08.00-musl-fsword-fix.patch
	"${FILESDIR}"/${PN}-2023.06.19.00-gcc15.patch
	"${FILESDIR}"/${PN}-2024.11.04.00-python-tests.patch
)

# Rust utility
QA_FLAGS_IGNORED="usr/bin/watchmanctl"

distutils_enable_tests unittest

src_prepare() {
	# Avoid cargo_src_prepare
	cmake_src_prepare
}

src_configure() {
	# https://github.com/facebook/watchman/blob/789678cf9855fb07b402afb75b01e4f8786deba2/build/fbcode_builder/CMake/RustStaticLibrary.cmake#L17
	export RUST_VENDORED_CRATES_DIR="${ECARGO_VENDOR}"
	export RUST_CARGO_HOME="${ECARGO_HOME}"
	export CARGO_HOME="${ECARGO_HOME}"
	# Build system already handles avoiding Rust-jobs-while-CMake-jobs-spawned issue
	# https://github.com/facebook/watchman/blob/789678cf9855fb07b402afb75b01e4f8786deba2/build/fbcode_builder/CMake/RustStaticLibrary.cmake#L69
	# so no need to force -j1 via cargo jobs

	local mycmakeargs=(
		# Rust wrangling
		-DUSE_CARGO_VENDOR=ON
		-DGENERATE_CARGO_VENDOR_CONFIG=OFF
		-DRUST_CARGO_HOME="${RUST_CARGO_HOME}"

		# General bits
		-DWATCHMAN_STATE_DIR="${EPREFIX}"/run/watchman
		-DWATCHMAN_VERSION_OVERRIDE=${PV}

		# We handle this ourselves
		-DCMAKE_DISABLE_FIND_PACKAGE_Python3=ON

		# The generated thrift services need to be statically linked into the watchman binary, otherwise
		# watchman fails to find them.
		-DBUILD_SHARED_LIBS=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use python ; then
		pushd watchman/python >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_test() {
	cmake_src_test

	if use python ; then
		pushd watchman/python >/dev/null || die
		distutils-r1_src_test
		popd >/dev/null || die
	fi
}

src_install() {
	cmake_src_install

	newtmpfiles "${FILESDIR}"/watchman.tmpfiles watchman.conf

	if use python ; then
		pushd watchman/python >/dev/null || die
		distutils-r1_src_install
		popd >/dev/null || die
	fi
}

pkg_postinst() {
	tmpfiles_process watchman.conf
}
