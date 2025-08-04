# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: you need to use top-level Cargo.lock to generate the crate list.
CRATES="
	adler2@2.0.0
	alloc-no-stdlib@2.0.4
	alloc-stdlib@0.2.2
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	autocfg@1.4.0
	bitflags@2.9.0
	blosc2-rs@0.4.0+2.15.2
	blosc2-sys@0.4.0+2.15.2
	brotli-decompressor@4.0.2
	brotli@7.0.0
	bumpalo@3.17.0
	bzip2-sys@0.1.13+1.0.8
	bzip2@0.4.4
	cbindgen@0.27.0
	cc@1.2.16
	cfg-if@1.0.0
	clap@4.5.31
	clap_builder@4.5.31
	clap_lex@0.7.4
	cmake@0.1.54
	colorchoice@1.0.3
	copy_dir@0.1.3
	crc32fast@1.4.2
	equivalent@1.0.2
	errno@0.3.10
	fastrand@2.3.0
	flate2@1.1.0
	getrandom@0.3.1
	hashbrown@0.15.2
	heck@0.4.1
	heck@0.5.0
	indexmap@2.7.1
	indoc@2.0.5
	is_terminal_polyfill@1.70.1
	isal-rs@0.5.3+496255c
	isal-sys@0.5.3+496255c
	itoa@1.0.14
	jobserver@0.1.32
	libc@0.2.170
	libcramjam@0.7.0
	libcramjam@0.8.0
	libdeflate-sys@1.19.3
	linux-raw-sys@0.4.15
	lock_api@0.4.12
	log@0.4.26
	lz4-sys@1.11.1+lz4-1.10.0
	lz4@1.28.1
	lzma-sys@0.1.20
	memchr@2.7.4
	memoffset@0.9.1
	miniz_oxide@0.8.5
	once_cell@1.20.3
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	pkg-config@0.3.31
	portable-atomic@1.11.0
	proc-macro2@1.0.93
	pyo3-build-config@0.25.0
	pyo3-ffi@0.25.0
	pyo3-macros-backend@0.25.0
	pyo3-macros@0.25.0
	pyo3@0.25.0
	python3-dll-a@0.2.13
	quote@1.0.38
	redox_syscall@0.5.9
	rustix@0.38.44
	rustversion@1.0.21
	ryu@1.0.19
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.218
	serde_derive@1.0.218
	serde_json@1.0.139
	serde_spanned@0.6.8
	shlex@1.3.0
	smallvec@1.14.0
	snap@1.1.1
	strsim@0.11.1
	syn@2.0.98
	target-lexicon@0.13.2
	tempfile@3.17.1
	toml@0.8.20
	toml_datetime@0.6.8
	toml_edit@0.22.24
	unicode-ident@1.0.17
	unindent@0.2.3
	utf8parse@0.2.2
	walkdir@2.5.0
	wasi@0.13.3+wasi-0.2.2
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	winapi-util@0.1.9
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
	winnow@0.7.3
	wit-bindgen-rt@0.33.0
	xz2@0.1.7
	zstd-safe@7.2.3
	zstd-sys@2.0.14+zstd.1.5.7
	zstd@0.13.3
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

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
	Unicode-3.0
"
SLOT="0"

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
		# https://github.com/milesgranger/cramjam/issues/204#issuecomment-2692307708
		# blosc2-shared
		# use-system-blosc2-shared
	)
	local features_s=${features[*]}

	DISTUTILS_ARGS=(
		--no-default-features
		--features="${features_s// /,}"
	)
}
