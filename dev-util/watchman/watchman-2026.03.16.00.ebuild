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
	ahash@0.8.12
	aho-corasick@1.1.4
	android_system_properties@0.1.5
	ansi_term@0.12.1
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.102
	atty@0.2.14
	autocfg@1.5.0
	base64@0.10.1
	bitflags@1.3.2
	bitflags@2.11.0
	bumpalo@3.20.2
	byteorder@1.5.0
	bytes@1.11.1
	cc@1.2.57
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	chrono@0.4.44
	clap@2.34.0
	clap@4.6.0
	clap_builder@4.6.0
	clap_derive@4.6.0
	clap_lex@1.1.0
	colorchoice@1.0.5
	core-foundation-sys@0.8.7
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.12
	crossbeam-utils@0.8.21
	crossbeam@0.8.4
	deelevate@0.1.1
	dirs-sys@0.3.7
	dirs@4.0.0
	duct@0.13.7
	either@1.15.0
	embed-resource@1.8.0
	errno@0.3.14
	filedescriptor@0.7.3
	find-msvc-tools@0.1.9
	fnv@1.0.7
	futures-channel@0.3.32
	futures-core@0.3.32
	futures-executor@0.3.32
	futures-io@0.3.32
	futures-macro@0.3.32
	futures-sink@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	futures@0.1.31
	futures@0.3.32
	getrandom@0.1.16
	getrandom@0.2.17
	getrandom@0.3.4
	hashbrown@0.15.5
	heck@0.3.3
	heck@0.5.0
	hermit-abi@0.1.19
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	js-sys@0.3.91
	jwalk@0.8.1
	lazy_static@1.5.0
	libc@0.2.183
	libredox@0.1.14
	lock_api@0.4.14
	log@0.4.29
	maplit@1.0.2
	maybe-uninit@2.0.0
	memchr@2.8.0
	memmem@0.1.1
	memoffset@0.9.1
	mio@1.1.1
	nix@0.30.1
	nom@5.1.3
	ntapi@0.4.3
	num-bigint@0.2.6
	num-complex@0.2.4
	num-derive@0.2.5
	num-integer@0.1.46
	num-iter@0.1.45
	num-rational@0.2.4
	num-traits@0.2.19
	num@0.2.1
	objc2-core-foundation@0.3.2
	objc2-io-kit@0.3.2
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	ordered-float@1.1.1
	os_pipe@1.2.3
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pathsearch@0.2.0
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_shared@0.11.3
	pin-project-lite@0.2.17
	ppv-lite86@0.2.21
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@0.4.30
	proc-macro2@1.0.106
	quote@0.6.13
	quote@1.0.45
	r-efi@5.3.0
	rand@0.7.3
	rand@0.8.5
	rand_chacha@0.2.2
	rand_core@0.5.1
	rand_core@0.6.4
	rand_hc@0.2.0
	rayon-core@1.13.0
	rayon@1.11.0
	redox_syscall@0.5.18
	redox_users@0.4.6
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rustc_version@0.4.1
	rustversion@1.0.22
	scopeguard@1.2.0
	semver-parser@0.7.0
	semver@0.9.0
	semver@1.0.27
	serde@1.0.228
	serde_bytes@0.11.19
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	shared_child@1.1.1
	shared_library@0.1.9
	shlex@1.3.0
	sigchld@0.2.4
	signal-hook-registry@1.4.8
	signal-hook@0.1.17
	signal-hook@0.3.18
	siphasher@1.0.2
	slab@0.4.12
	smallvec@0.6.14
	smallvec@1.15.1
	socket2@0.6.3
	strsim@0.11.1
	strsim@0.8.0
	structopt-derive@0.4.18
	structopt@0.3.26
	syn@0.15.44
	syn@1.0.109
	syn@2.0.117
	sysinfo@0.35.2
	tabular@0.2.0
	terminfo@0.7.5
	termios@0.3.3
	termwiz@0.8.0
	textwrap@0.11.0
	thiserror-impl@1.0.69
	thiserror-impl@2.0.18
	thiserror@1.0.69
	thiserror@2.0.18
	tokio-macros@2.6.1
	tokio-util@0.7.18
	tokio@1.50.0
	toml@0.5.11
	tracing-core@0.1.36
	tracing@0.1.44
	unicode-ident@1.0.24
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	unicode-xid@0.1.0
	utf8parse@0.1.1
	utf8parse@0.2.2
	vec_map@0.8.2
	vergen@3.2.0
	version_check@0.9.5
	vswhom-sys@0.1.3
	vswhom@0.1.0
	vtparse@0.2.2
	wasi@0.11.1+wasi-snapshot-preview1
	wasi@0.9.0+wasi-snapshot-preview1
	wasip2@1.0.2+wasi-0.2.9
	wasm-bindgen-macro-support@0.2.114
	wasm-bindgen-macro@0.2.114
	wasm-bindgen-shared@0.2.114
	wasm-bindgen@0.2.114
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-collections@0.2.0
	windows-core@0.61.2
	windows-core@0.62.2
	windows-future@0.2.1
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.1.3
	windows-link@0.2.1
	windows-numerics@0.2.0
	windows-result@0.3.4
	windows-result@0.4.1
	windows-strings@0.4.2
	windows-strings@0.5.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows-threading@0.1.0
	windows@0.61.3
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	winreg@0.10.1
	wit-bindgen@0.51.0
	xi-unicode@0.2.1
	zerocopy-derive@0.8.47
	zerocopy@0.8.47
	zmij@1.0.21
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit cargo cmake distutils-r1 tmpfiles

DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman/"
SRC_URI="https://github.com/facebook/watchman/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-3.0 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="llvm-libunwind python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libfmt-8.1.1-r1:=
	~dev-cpp/edencommon-${PV}:=
	~dev-cpp/fb303-${PV}:=
	~dev-cpp/fbthrift-${PV}:=
	~dev-cpp/folly-${PV}:=
	dev-cpp/cpptoml:=
	dev-cpp/glog:=
	dev-libs/boost:=
	dev-libs/libpcre2:=
	dev-libs/openssl:=
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
	"${FILESDIR}"/${PN}-2026.03.16.00-cmake-update-cmake_minimum_required-to-3.10.patch
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

		# NOTE: The bser module is built as a C extension.
		#       pywatchman/__init__.py will try to import bser.so from
		#       the current directory; however, since we have phased
		#       installation, it will instead be installed in
		#       ${WORKDIR}/${P}_build-${PYTHON_USEDEP}/install.
		#       To ensure that the installed version of pywatchman is
		#       picked up, we delete the pywatchman directory and force
		#       it to be imported through the installed version. See:
		#
		#       https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions
		rm -rf pywatchman || die

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
