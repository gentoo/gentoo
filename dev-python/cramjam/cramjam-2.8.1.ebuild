# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: this package is a mess. You need to use top-level Cargo.lock
# to generate the crate list.
CRATES="
	adler@1.0.2
	aho-corasick@1.1.2
	alloc-no-stdlib@2.0.4
	alloc-stdlib@0.2.2
	anstream@0.3.2
	anstyle-parse@0.2.0
	anstyle-query@1.0.0
	anstyle-wincon@1.0.1
	anstyle@1.0.0
	assert_cmd@1.0.8
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.1
	brotli-decompressor@2.3.4
	brotli@3.3.4
	bstr@0.2.17
	bytesize@1.2.0
	bzip2-sys@0.1.11+1.0.8
	bzip2@0.4.4
	cbindgen@0.24.5
	cc@1.0.79
	cfg-if@1.0.0
	clap@3.2.25
	clap@4.2.7
	clap_builder@4.2.7
	clap_derive@4.2.0
	clap_lex@0.2.4
	clap_lex@0.4.1
	colorchoice@1.0.0
	crc32fast@1.3.2
	difflib@0.4.0
	doc-comment@0.3.3
	either@1.9.0
	errno-dragonfly@0.1.2
	errno@0.3.1
	fastrand@2.0.1
	flate2@1.0.26
	float-cmp@0.9.0
	hashbrown@0.12.3
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.3.1
	indexmap@1.9.3
	indoc@2.0.4
	inline-c-macro@0.1.5
	inline-c@0.1.7
	io-lifetimes@1.0.10
	is-terminal@0.4.7
	itertools@0.10.5
	itoa@1.0.9
	jobserver@0.1.26
	lazy_static@1.4.0
	libc@0.2.150
	libdeflate-sys@1.19.0
	libdeflater@1.19.0
	linux-raw-sys@0.3.6
	linux-raw-sys@0.4.11
	lock_api@0.4.9
	log@0.4.20
	lz4-sys@1.9.4
	lz4@1.24.0
	lzma-sys@0.1.20
	memchr@2.6.4
	memoffset@0.9.0
	miniz_oxide@0.7.1
	normalize-line-endings@0.3.0
	num-traits@0.2.17
	once_cell@1.17.1
	os_str_bytes@6.6.1
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	pest@2.7.5
	pkg-config@0.3.27
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@2.1.5
	proc-macro2@1.0.70
	pyo3-build-config@0.20.0
	pyo3-ffi@0.20.0
	pyo3-macros-backend@0.20.0
	pyo3-macros@0.20.0
	pyo3@0.20.0
	quote@1.0.33
	redox_syscall@0.2.16
	redox_syscall@0.4.1
	regex-automata@0.1.10
	regex-automata@0.4.3
	regex-syntax@0.8.2
	regex@1.10.2
	rustc_version@0.3.3
	rustix@0.37.25
	rustix@0.38.25
	ryu@1.0.15
	scopeguard@1.1.0
	semver-parser@0.10.2
	semver@0.11.0
	serde@1.0.193
	serde_derive@1.0.193
	serde_json@1.0.99
	smallvec@1.10.0
	snap@1.1.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.39
	target-lexicon@0.11.2
	target-lexicon@0.12.7
	tempfile@3.8.1
	termcolor@1.4.0
	termtree@0.4.1
	textwrap@0.16.0
	thiserror-impl@1.0.50
	thiserror@1.0.50
	toml@0.5.11
	ucd-trie@0.1.6
	unicode-ident@1.0.8
	unindent@0.2.3
	utf8parse@0.2.1
	wait-timeout@0.2.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.0
	xz2@0.1.7
	zstd-safe@7.0.0
	zstd-sys@2.0.8+zstd.1.5.5
	zstd@0.13.0
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..12} )

inherit cargo distutils-r1

DESCRIPTION="Thin Python bindings to de/compression algorithms in Rust"
HOMEPAGE="
	https://github.com/milesgranger/cramjam/
	https://pypi.org/project/cramjam/
"
# pypi sdist is missing libcramjam/Cargo.lock
SRC_URI="
	https://github.com/milesgranger/cramjam/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/${P}/cramjam-python

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT MPL-2.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/cramjam/cramjam.*.so"

src_prepare() {
	sed -i -e '/strip/d' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# random health check failures
		# https://github.com/milesgranger/cramjam/issues/141
		tests/test_variants.py::test_variants_different_dtypes
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
