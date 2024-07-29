# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# dev-cpp/edencommon
# dev-cpp/folly
# dev-util/watchman

# TODO: Split into different variables then combine for each component?
# Not all is in rust/ dir.
# Rust components:
# - thirdparty/deelevate_binding/Cargo.toml
# - rust/watchman_client/Cargo.toml
# - rust/serde_bser/Cargo.toml
# - cli/Cargo.toml
CRATES="
	ahash@0.8.3
	ansi_term@0.12.1
	anyhow@1.0.71
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	byteorder@1.4.3
	bytes@1.4.0
	cfg-if@1.0.0
	clap@2.34.0
	core-foundation-sys@0.8.4
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-queue@0.3.8
	crossbeam-utils@0.8.16
	crossbeam@0.8.2
	duct@0.13.6
	either@1.8.1
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-executor@0.3.28
	futures-io@0.3.28
	futures-macro@0.3.28
	futures-sink@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	futures@0.1.31
	futures@0.3.28
	getrandom@0.2.10
	heck@0.3.3
	hermit-abi@0.1.19
	hermit-abi@0.2.6
	itoa@1.0.6
	jwalk@0.6.2
	lazy_static@1.4.0
	libc@0.2.146
	lock_api@0.4.10
	log@0.4.19
	maplit@1.0.2
	memchr@2.5.0
	memoffset@0.6.5
	memoffset@0.9.0
	mio@0.8.8
	nix@0.25.1
	ntapi@0.4.1
	num_cpus@1.15.0
	once_cell@1.18.0
	os_pipe@1.1.4
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	pin-project-lite@0.2.9
	pin-utils@0.1.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.60
	quote@1.0.28
	rayon-core@1.11.0
	rayon@1.7.0
	redox_syscall@0.3.5
	ryu@1.0.13
	scopeguard@1.1.0
	serde@1.0.164
	serde_bytes@0.11.9
	serde_derive@1.0.164
	serde_json@1.0.99
	shared_child@1.0.0
	signal-hook-registry@1.4.1
	slab@0.4.8
	smallvec@1.10.0
	socket2@0.4.9
	strsim@0.8.0
	structopt-derive@0.4.18
	structopt@0.3.26
	syn@1.0.109
	syn@2.0.20
	sysinfo@0.26.9
	tabular@0.2.0
	textwrap@0.11.0
	thiserror-impl@1.0.40
	thiserror@1.0.40
	tokio-macros@2.1.0
	tokio-util@0.6.10
	tokio@1.28.2
	tracing-core@0.1.31
	tracing@0.1.37
	unicode-ident@1.0.9
	unicode-segmentation@1.10.1
	unicode-width@0.1.10
	vec_map@0.8.2
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.0
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.48.0
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit cargo cmake distutils-r1 tmpfiles

DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman/"
SRC_URI="https://github.com/facebook/watchman/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64"
IUSE="llvm-libunwind python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# See https://github.com/facebook/watchman/blob/main/CMakeLists.txt#L342 for libevent
RDEPEND="
	dev-libs/libevent:=
	dev-libs/libpcre2
	~dev-cpp/edencommon-${PV}:=
	~dev-cpp/folly-${PV}:=
	dev-cpp/glog:=
	>=dev-libs/libfmt-8.1.1-r1:=
	dev-libs/openssl:=
	llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
	python? ( ${PYTHON_DEPS} )
"
# TODO: Make gtest test-only (needs a fair bit of patching)
DEPEND="
	${RDEPEND}
	dev-cpp/gtest
"

PATCHES=(
	"${FILESDIR}"/${PN}-2023.01.16.00-python-working-dir.patch
	"${FILESDIR}"/${PN}-2022.02.28.00-libatomic.patch
	"${FILESDIR}"/${PN}-2022.08.08.00-musl-fsword-fix.patch
	"${FILESDIR}"/${PN}-2023.06.19.00-rust-1.70-avoidance.patch
	"${FILESDIR}"/${PN}-2023.06.19.00-unused.patch
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

		# Fails to build against fbthrift for now in libatomic troubles
		-DENABLE_EDEN_SUPPORT=OFF

		# We handle this ourselves
		-DCMAKE_DISABLE_FIND_PACKAGE_Python3=ON
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
