# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..13} pypy3 )

CRATES="
	ahash@0.8.11
	autocfg@1.3.0
	bitflags@2.5.0
	cfg-if@1.0.0
	csv-core@0.1.11
	csv@1.3.0
	getrandom@0.2.15
	heck@0.4.1
	indoc@2.0.5
	itoa@1.0.11
	libc@0.2.155
	lock_api@0.4.12
	memchr@2.7.2
	memoffset@0.9.1
	once_cell@1.19.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	portable-atomic@1.6.0
	proc-macro2@1.0.84
	pyo3-build-config@0.20.3
	pyo3-ffi@0.20.3
	pyo3-macros-backend@0.20.3
	pyo3-macros@0.20.3
	pyo3@0.20.3
	quote@1.0.36
	redox_syscall@0.5.1
	ryu@1.0.18
	scopeguard@1.2.0
	serde@1.0.203
	serde_derive@1.0.203
	smallvec@1.13.2
	syn@2.0.66
	target-lexicon@0.12.14
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-segmentation@1.11.0
	unindent@0.2.3
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.52.5
	zerocopy-derive@0.7.34
	zerocopy@0.7.34
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
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/jellyfish/_rustyfish.*.so"

distutils_enable_tests pytest

export UNSAFE_PYO3_SKIP_VERSION_CHECK=1

python_test_all() {
	cargo_src_test
}
