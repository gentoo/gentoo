# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

CARGO_OPTIONAL=1
RUST_MIN_VER="1.86"
CRATES="
	ahash@0.8.12
	aho-corasick@1.1.3
	anes@0.1.6
	anstyle@1.0.11
	autocfg@1.5.0
	bitflags@2.9.1
	bumpalo@3.19.0
	cast@0.3.0
	cfg-if@1.0.1
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.41
	clap_builder@4.5.41
	clap_lex@0.7.5
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	either@1.15.0
	getrandom@0.3.3
	half@2.6.0
	hermit-abi@0.5.2
	is-terminal@0.4.16
	itertools@0.10.5
	itoa@1.0.15
	js-sys@0.3.77
	libc@0.2.174
	log@0.4.27
	memchr@2.7.5
	num-traits@0.2.19
	once_cell@1.21.3
	oorandom@11.1.5
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	proc-macro2@1.0.95
	pyo3-build-config@0.25.1
	pyo3-ffi@0.25.1
	quote@1.0.40
	r-efi@5.3.0
	rayon-core@1.12.1
	rayon@1.10.0
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustversion@1.0.21
	ryu@1.0.20
	same-file@1.0.6
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.141
	syn@2.0.104
	target-lexicon@0.13.2
	tinytemplate@1.2.1
	unicode-ident@1.0.18
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.14.2+wasi-0.2.4
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	web-sys@0.3.77
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
	wit-bindgen-rt@0.39.0
	zerocopy-derive@0.8.26
	zerocopy@0.8.26
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
KEYWORDS="~amd64"
IUSE="+native-extensions"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	native-extensions? (
		${RUST_DEPEND}
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	)
	test? (
		$(python_gen_cond_dep '
			dev-python/time-machine[${PYTHON_USEDEP}]
		' 'python*')
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-order )
distutils_enable_tests pytest

EPYTEST_IGNORE=( benchmarks )

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/whenever/_whenever.*.so"

src_unpack() {
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
