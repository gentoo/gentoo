# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} )

RUST_MIN_VER="1.87.0"
CRATES="
	allocator-api2@0.2.21
	anyhow@1.0.102
	bitflags@2.11.0
	bitvec@1.0.1
	block-buffer@0.10.4
	bytemuck@1.25.0
	cc@1.2.60
	cfg-if@1.0.4
	chacha20@0.10.0
	cpufeatures@0.2.17
	cpufeatures@0.3.0
	crunchy@0.2.4
	crypto-common@0.1.7
	digest@0.10.7
	equivalent@1.0.2
	find-msvc-tools@0.1.9
	foldhash@0.1.5
	foldhash@0.2.0
	funty@2.0.0
	generic-array@0.14.7
	getrandom@0.3.4
	getrandom@0.4.1
	half@2.7.1
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	hex@0.4.3
	id-arena@2.3.0
	indexmap@2.13.0
	itoa@1.0.17
	jobserver@0.1.34
	leb128fmt@0.1.0
	libc@0.2.182
	log@0.4.29
	lru@0.16.3
	memchr@2.7.6
	once_cell@1.21.3
	pkg-config@0.3.33
	portable-atomic@1.13.1
	prettyplease@0.2.37
	proc-macro2@1.0.106
	pyo3-build-config@0.28.2
	pyo3-ffi@0.28.2
	pyo3-macros-backend@0.28.2
	pyo3-macros@0.28.2
	pyo3@0.28.2
	quote@1.0.44
	r-efi@5.3.0
	radium@0.7.0
	rand@0.10.0
	rand_core@0.10.0
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	sha2@0.10.9
	shlex@1.3.0
	syn@2.0.117
	tap@1.0.1
	target-lexicon@0.13.5
	typenum@1.19.0
	unicode-ident@1.0.24
	unicode-xid@0.2.6
	version_check@0.9.5
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	wyz@0.5.1
	zerocopy-derive@0.8.40
	zerocopy@0.8.40
	zmij@1.0.21
	zstd-safe@7.2.4
	zstd-sys@2.0.16+zstd.1.5.7
	zstd@0.13.3
"

inherit cargo distutils-r1 pypi

DESCRIPTION="A sleek Python library for your binary data"
HOMEPAGE="
	https://github.com/scott-griffiths/tibs/
	https://pypi.org/project/tibs/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	tests/test_benchmarks.py
)

QA_FLAGS_IGNORED="usr/lib/python3.*/site-packages/tibs/tibs.abi3.*"
