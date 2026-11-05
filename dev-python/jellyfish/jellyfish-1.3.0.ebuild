# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )

RUST_MIN_VER="1.87.0"
CRATES="
	ahash@0.8.12
	autocfg@1.5.1
	cfg-if@1.0.5
	csv-core@0.1.13
	csv@1.4.0
	getrandom@0.3.4
	heck@0.5.0
	itoa@1.0.18
	libc@0.2.190
	memchr@2.8.3
	num-traits@0.2.19
	once_cell@1.21.4
	portable-atomic@1.15.0
	proc-macro2@1.0.107
	pyo3-build-config@0.30.1
	pyo3-ffi@0.30.1
	pyo3-macros-backend@0.30.1
	pyo3-macros@0.30.1
	pyo3@0.30.1
	quote@1.0.47
	r-efi@5.3.0
	ryu@1.0.23
	serde_core@1.0.229
	serde_derive@1.0.229
	smallvec@1.16.3
	syn@2.0.119
	syn@3.0.9
	target-lexicon@0.13.5
	tinyvec@1.13.3
	unicode-ident@1.0.27
	unicode-normalization@0.1.25
	unicode-segmentation@1.13.3
	version_check@0.9.5
	wasip2@1.0.4+wasi-0.2.12
	wit-bindgen@0.57.1
	zerocopy-derive@0.8.63
	zerocopy@0.8.63
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
	Apache-2.0-with-LLVM-exceptions Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
	|| ( Apache-2.0 MIT )
	|| ( MIT Unlicense )
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/jellyfish/_rustyfish.*.so"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

python_test_all() {
	cargo_src_test
}
