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
	aho-corasick@1.1.4
	alloca@0.4.0
	anes@0.1.6
	anstyle@1.0.13
	autocfg@1.5.0
	bumpalo@3.19.0
	cast@0.3.0
	cc@1.2.49
	cfg-if@1.0.4
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.53
	clap_builder@4.5.53
	clap_lex@0.7.6
	criterion-plot@0.8.1
	criterion@0.8.1
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	either@1.15.0
	find-msvc-tools@0.1.5
	getrandom@0.3.4
	half@2.7.1
	itertools@0.13.0
	itoa@1.0.15
	js-sys@0.3.83
	libc@0.2.178
	memchr@2.7.6
	num-traits@0.2.19
	once_cell@1.21.3
	oorandom@11.1.5
	page_size@0.6.0
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	proc-macro2@1.0.103
	pyo3-build-config@0.27.2
	pyo3-ffi@0.27.2
	quote@1.0.42
	r-efi@5.3.0
	rayon-core@1.13.0
	rayon@1.11.0
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	rustversion@1.0.22
	ryu@1.0.20
	same-file@1.0.6
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	shlex@1.3.0
	syn@2.0.111
	target-lexicon@0.13.3
	tinytemplate@1.2.1
	unicode-ident@1.0.22
	version_check@0.9.5
	walkdir@2.5.0
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-macro-support@0.2.106
	wasm-bindgen-macro@0.2.106
	wasm-bindgen-shared@0.2.106
	wasm-bindgen@0.2.106
	web-sys@0.3.83
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.61.2
	wit-bindgen@0.46.0
	zerocopy-derive@0.8.31
	zerocopy@0.8.31
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
