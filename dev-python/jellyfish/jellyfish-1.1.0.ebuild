# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..13} pypy3 )

CRATES="
	ahash@0.8.11
	autocfg@1.3.0
	cfg-if@1.0.0
	csv-core@0.1.11
	csv@1.3.0
	getrandom@0.2.15
	heck@0.5.0
	indoc@2.0.5
	itoa@1.0.11
	libc@0.2.155
	memchr@2.7.4
	memoffset@0.9.1
	num-traits@0.2.19
	once_cell@1.19.0
	portable-atomic@1.7.0
	proc-macro2@1.0.86
	pyo3-build-config@0.22.2
	pyo3-ffi@0.22.2
	pyo3-macros-backend@0.22.2
	pyo3-macros@0.22.2
	pyo3@0.22.2
	quote@1.0.36
	ryu@1.0.18
	serde@1.0.204
	serde_derive@1.0.204
	smallvec@1.13.2
	syn@2.0.72
	target-lexicon@0.12.15
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-segmentation@1.11.0
	unindent@0.2.3
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Python module for doing approximate and phonetic matching of strings"
HOMEPAGE="
	https://github.com/jamesturk/jellyfish/
	https://pypi.org/project/jellyfish/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/jellyfish/_rustyfish.*.so"

distutils_enable_tests pytest

export UNSAFE_PYO3_SKIP_VERSION_CHECK=1

python_test_all() {
	cargo_src_test
}
