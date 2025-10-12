# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

RUST_MIN_VER="1.82.0"
CRATES="
	ahash@0.8.12
	autocfg@1.5.0
	cc@1.2.41
	cfg-if@1.0.3
	csv-core@0.1.12
	csv@1.3.1
	find-msvc-tools@0.1.4
	getrandom@0.3.3
	heck@0.5.0
	indoc@2.0.6
	itoa@1.0.15
	libc@0.2.177
	memchr@2.7.6
	memoffset@0.9.1
	num-traits@0.2.19
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	pyo3-build-config@0.26.0
	pyo3-ffi@0.26.0
	pyo3-macros-backend@0.26.0
	pyo3-macros@0.26.0
	pyo3@0.26.0
	python3-dll-a@0.2.14
	quote@1.0.41
	r-efi@5.3.0
	ryu@1.0.20
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	shlex@1.3.0
	smallvec@1.15.1
	syn@2.0.106
	target-lexicon@0.13.3
	tinyvec@1.10.0
	tinyvec_macros@0.1.1
	unicode-ident@1.0.19
	unicode-normalization@0.1.24
	unicode-segmentation@1.12.0
	unindent@0.2.4
	version_check@0.9.5
	wasi@0.14.7+wasi-0.2.4
	wasip2@1.0.1+wasi-0.2.4
	wit-bindgen@0.46.0
	zerocopy-derive@0.8.27
	zerocopy@0.8.27
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
	Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/jellyfish/_rustyfish.*.so"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test_all() {
	cargo_src_test
}
