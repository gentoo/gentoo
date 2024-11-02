# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: you need to use top-level Cargo.lock to generate the crate list.
CRATES="
	adler2@2.0.0
	alloc-no-stdlib@2.0.4
	alloc-stdlib@0.2.2
	atty@0.2.14
	autocfg@1.4.0
	bitflags@1.3.2
	bitflags@2.6.0
	blosc2-rs@0.3.1+2.15.1
	blosc2-sys@0.3.1+2.15.1
	brotli-decompressor@4.0.1
	brotli@7.0.0
	bzip2-sys@0.1.11+1.0.8
	bzip2@0.4.4
	cbindgen@0.24.5
	cc@1.1.30
	cfg-if@1.0.0
	clap@3.2.25
	clap_lex@0.2.4
	cmake@0.1.51
	copy_dir@0.1.3
	crc32fast@1.4.2
	errno@0.3.9
	fastrand@2.1.1
	flate2@1.0.34
	hashbrown@0.12.3
	heck@0.4.1
	heck@0.5.0
	hermit-abi@0.1.19
	indexmap@1.9.3
	indoc@2.0.5
	isal-rs@0.5.3+496255c
	isal-sys@0.5.3+496255c
	itoa@1.0.11
	jobserver@0.1.32
	libc@0.2.159
	libcramjam@0.6.0
	libdeflate-sys@1.19.3
	libdeflater@1.19.3
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.22
	lz4-sys@1.11.1+lz4-1.10.0
	lz4@1.28.0
	lzma-sys@0.1.20
	memchr@2.7.4
	memoffset@0.9.1
	miniz_oxide@0.8.0
	once_cell@1.20.2
	os_str_bytes@6.6.1
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	pkg-config@0.3.31
	portable-atomic@1.9.0
	proc-macro2@1.0.87
	pyo3-build-config@0.22.5
	pyo3-ffi@0.22.5
	pyo3-macros-backend@0.22.5
	pyo3-macros@0.22.5
	pyo3@0.22.5
	python3-dll-a@0.2.10
	quote@1.0.37
	redox_syscall@0.5.7
	rustix@0.38.37
	ryu@1.0.18
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	shlex@1.3.0
	smallvec@1.13.2
	snap@1.1.1
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.79
	target-lexicon@0.12.16
	tempfile@3.13.0
	termcolor@1.4.1
	textwrap@0.16.1
	toml@0.5.11
	unicode-ident@1.0.13
	unindent@0.2.3
	walkdir@2.5.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
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
	xz2@0.1.7
	zstd-safe@7.2.1
	zstd-sys@2.0.13+zstd.1.5.6
	zstd@0.13.2
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit cargo distutils-r1 pypi

DESCRIPTION="Thin Python bindings to de/compression algorithms in Rust"
HOMEPAGE="
	https://github.com/milesgranger/cramjam/
	https://pypi.org/project/cramjam/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT MPL-2.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~riscv ~sparc ~x86"

DEPEND="
	app-arch/bzip2:=
	app-arch/libdeflate:=
	app-arch/lz4:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	dev-libs/c-blosc2:=
	dev-libs/isa-l:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/cramjam/cramjam.*.so"

src_prepare() {
	sed -i -e '/strip/d' pyproject.toml || die
	distutils-r1_src_prepare
	export UNSAFE_PYO3_SKIP_VERSION_CHECK=1

	# strip all the bundled C libraries
	find "${ECARGO_VENDOR}"/*-sys-* \
		-name '*.c' -delete || die

	# https://github.com/10XGenomics/lz4-rs/pull/39
	pushd "${ECARGO_VENDOR}"/lz4-sys* >/dev/null || Die
	eapply -p2 "${FILESDIR}/lz4-sys-unbundle-lz4.patch"
	popd >/dev/null || die

	# https://github.com/milesgranger/isal-rs/pull/25 (cheap workaround)
	sed -i -e '/default/d' "${ECARGO_VENDOR}"/isal-sys*/Cargo.toml || die

	# enable system libraries where supported
	export ZSTD_SYS_USE_PKG_CONFIG=1

	# unpin C library versions
	sed -i -e '/exactly_version/d' \
		"${ECARGO_VENDOR}"/libdeflate-sys-*/build.rs || die

	# bzip2-sys requires a pkg-config file
	# https://github.com/alexcrichton/bzip2-rs/issues/104
	mkdir "${T}/pkg-config" || die
	export PKG_CONFIG_PATH=${T}/pkg-config${PKG_CONFIG_PATH+:${PKG_CONFIG_PATH}}
	cat >> "${T}/pkg-config/bzip2.pc" <<-EOF || die
		Name: bzip2
		Version: 9999
		Description:
		Libs: -lbz2
	EOF

	local features=(
		extension-module

		snappy
		lz4
		bzip2
		brotli
		zstd

		xz-shared
		igzip-shared
		ideflate-shared
		izlib-shared
		use-system-isal-shared
		gzip-shared
		zlib-shared
		deflate-shared
		blosc2-shared
		use-system-blosc2-shared
	)
	local features_s=${features[*]}

	DISTUTILS_ARGS=(
		--no-default-features
		--features="${features_s// /,}"
	)
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
