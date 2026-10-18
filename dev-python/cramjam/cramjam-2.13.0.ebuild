# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYPI_VERIFY_REPO=https://github.com/milesgranger/cramjam
PYTHON_COMPAT=( python3_{12..15} )

RUST_MIN_VER="1.83.0"
# Note: you need to use top-level Cargo.lock to generate the crate list.
CRATES="
	adler2@2.0.1
	alloc-no-stdlib@2.0.4
	alloc-stdlib@0.2.4
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	bitflags@2.13.2
	blosc2-rs@0.4.0+2.15.2
	blosc2-sys@0.4.0+2.15.2
	brotli-decompressor@4.0.3
	brotli@7.0.0
	bumpalo@3.20.3
	bzip2-sys@0.1.13+1.0.8
	bzip2@0.5.2
	cbindgen@0.27.0
	cc@1.5.1
	cfg-if@1.0.5
	clap@4.5.61
	clap_builder@4.5.61
	clap_lex@1.0.1
	cmake@0.1.58
	colorchoice@1.0.5
	copy_dir@0.1.3
	crc32fast@1.5.2
	equivalent@1.0.2
	errno@0.3.14
	fastrand@2.5.0
	find-msvc-tools@0.1.14
	flate2@1.1.10
	getrandom@0.3.4
	hashbrown@0.16.1
	heck@0.4.1
	heck@0.5.0
	indexmap@2.13.1
	is_terminal_polyfill@1.70.2
	isal-rs@0.5.3+496255c
	isal-sys@0.5.3+496255c
	itoa@1.0.18
	jobserver@0.1.34
	libc@0.2.189
	libcramjam@0.7.0
	libcramjam@0.8.0
	libdeflate-sys@1.19.3
	linux-raw-sys@0.12.1
	lock_api@0.4.14
	log@0.4.34
	lz4-sys@1.11.1+lz4-1.10.0
	lz4@1.28.1
	lzma-sys@0.1.20
	memchr@2.8.3
	miniz_oxide@0.9.1
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pkg-config@0.3.34
	portable-atomic@1.15.0
	proc-macro2@1.0.107
	pyo3-build-config@0.29.2
	pyo3-ffi@0.29.2
	pyo3-macros-backend@0.29.2
	pyo3-macros@0.29.2
	pyo3@0.29.2
	quote@1.0.47
	r-efi@5.3.0
	redox_syscall@0.5.18
	rustix@1.1.5
	rustversion@1.0.23
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.151
	serde_spanned@0.6.9
	shlex@2.0.1
	simd-adler32@0.3.10
	smallvec@1.16.2
	snap@1.1.2
	strsim@0.11.1
	syn@2.0.119
	syn@3.0.6
	target-lexicon@0.13.5
	tempfile@3.27.0
	toml@0.8.23
	toml_datetime@0.6.11
	toml_edit@0.22.27
	toml_write@0.1.2
	unicode-ident@1.0.26
	utf8parse@0.2.2
	walkdir@2.5.0
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-macro-support@0.2.129
	wasm-bindgen-macro@0.2.129
	wasm-bindgen-shared@0.2.129
	wasm-bindgen@0.2.129
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.61.2
	winnow@0.7.15
	wit-bindgen@0.46.0
	xz2@0.1.7
	zlib-rs@0.6.8
	zmij@1.0.23
	zstd-safe@7.3.0
	zstd-sys@2.1.0+zstd.1.5.7
	zstd@0.13.3
"

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
	Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc ~x86"

DEPEND="
	app-arch/bzip2:=
	app-arch/libdeflate:=
	app-arch/lz4:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	dev-libs/isa-l:=
"
#	dev-libs/c-blosc2:=
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis )
# horrible workaround for https://github.com/milesgranger/cramjam/issues/201
EPYTEST_RERUNS=5
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/cramjam/cramjam.*.so"

src_unpack() {
	pypi_src_unpack
	cargo_crate_unpack
	cargo_gen_config
}

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
	)
	local features_s=${features[*]}

	DISTUTILS_ARGS=(
		--no-default-features
		--features="${features_s// /,}"
	)
}
