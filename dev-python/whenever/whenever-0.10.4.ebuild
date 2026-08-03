# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYPI_VERIFY_REPO=https://github.com/ariebovenberg/whenever
PYTHON_COMPAT=( python3_{12..15} )

CARGO_OPTIONAL=1
RUST_MIN_VER="1.93.0"
CRATES="
	ahash@0.8.12
	aho-corasick@1.1.4
	alloca@0.4.0
	anes@0.1.6
	anstyle@1.0.14
	autocfg@1.5.1
	bumpalo@3.20.3
	cast@0.3.0
	cc@1.3.0
	cfg-if@1.0.4
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.6.2
	clap_builder@4.6.2
	clap_lex@1.1.0
	criterion-plot@0.8.2
	criterion@0.8.2
	crossbeam-deque@0.8.7
	crossbeam-epoch@0.9.20
	crossbeam-utils@0.8.22
	crunchy@0.2.4
	either@1.16.0
	find-msvc-tools@0.1.9
	futures-core@0.3.33
	futures-task@0.3.33
	futures-util@0.3.33
	getrandom@0.3.4
	half@2.7.1
	itertools@0.13.0
	itoa@1.0.18
	js-sys@0.3.103
	libc@0.2.186
	memchr@2.8.3
	num-traits@0.2.19
	once_cell@1.21.4
	oorandom@11.1.5
	page_size@0.6.0
	pin-project-lite@0.2.17
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	proc-macro2@1.0.107
	pyo3-build-config@0.29.0
	pyo3-ffi@0.29.0
	quote@1.0.47
	r-efi@5.3.0
	rayon-core@1.13.0
	rayon@1.12.0
	regex-automata@0.4.16
	regex-syntax@0.8.11
	regex@1.13.1
	rustversion@1.0.23
	same-file@1.0.6
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.150
	shlex@2.0.1
	slab@0.4.12
	syn@2.0.119
	syn@3.0.0
	target-lexicon@0.13.5
	tinytemplate@1.2.1
	unicode-ident@1.0.24
	version_check@0.9.5
	walkdir@2.5.0
	wasip2@1.0.4+wasi-0.2.12
	wasm-bindgen-macro-support@0.2.126
	wasm-bindgen-macro@0.2.126
	wasm-bindgen-shared@0.2.126
	wasm-bindgen@0.2.126
	web-sys@0.3.103
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.61.2
	wit-bindgen@0.57.1
	zerocopy-derive@0.8.54
	zerocopy@0.8.54
	zmij@1.0.23
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Modern datetime library for Python"
HOMEPAGE="
	https://github.com/ariebovenberg/whenever/
	https://pypi.org/project/whenever/
"
SRC_URI+="
	native-extensions? (
		${CARGO_CRATE_URIS}
	)
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
if [[ ${PV} != *_[ab]* ]]; then
	KEYWORDS="~amd64"
fi
IUSE="+native-extensions"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	native-extensions? (
		${RUST_DEPEND}
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/time-machine[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-order )
distutils_enable_tests pytest

EPYTEST_IGNORE=( benchmarks )

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/whenever/_whenever.*.so"

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}

src_configure() {
	if ! use native-extensions; then
		export WHENEVER_NO_BUILD_RUST_EXT=1
	fi
}

python_test() {
	rm -rf whenever || die
	epytest
}
