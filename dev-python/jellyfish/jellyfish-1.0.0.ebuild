# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	ahash@0.8.3
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	csv-core@0.1.10
	csv@1.2.2
	getrandom@0.2.10
	indoc@1.0.9
	itoa@1.0.6
	libc@0.2.146
	lock_api@0.4.10
	memchr@2.5.0
	memoffset@0.8.0
	once_cell@1.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	proc-macro2@1.0.60
	pyo3-build-config@0.18.3
	pyo3-ffi@0.18.3
	pyo3-macros-backend@0.18.3
	pyo3-macros@0.18.3
	pyo3@0.18.3
	quote@1.0.28
	redox_syscall@0.3.5
	ryu@1.0.13
	scopeguard@1.1.0
	serde@1.0.164
	smallvec@1.10.0
	syn@1.0.109
	target-lexicon@0.12.8
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	unicode-ident@1.0.9
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unindent@0.1.11
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.48.0
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.48.0
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
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/jellyfish/_rustyfish.*.so"

distutils_enable_tests pytest
