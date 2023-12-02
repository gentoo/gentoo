# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..12} pypy3 )

CRATES="
	ahash@0.8.6
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	csv-core@0.1.11
	csv@1.3.0
	getrandom@0.2.11
	heck@0.4.1
	indoc@2.0.4
	itoa@1.0.9
	libc@0.2.150
	lock_api@0.4.11
	memchr@2.6.4
	memoffset@0.9.0
	once_cell@1.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	proc-macro2@1.0.69
	pyo3-build-config@0.20.0
	pyo3-ffi@0.20.0
	pyo3-macros-backend@0.20.0
	pyo3-macros@0.20.0
	pyo3@0.20.0
	quote@1.0.33
	redox_syscall@0.4.1
	ryu@1.0.15
	scopeguard@1.2.0
	serde@1.0.192
	serde_derive@1.0.192
	smallvec@1.11.2
	syn@2.0.39
	target-lexicon@0.12.12
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unindent@0.2.3
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	zerocopy-derive@0.7.26
	zerocopy@0.7.26
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
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/jellyfish/_rustyfish.*.so"

distutils_enable_tests pytest
