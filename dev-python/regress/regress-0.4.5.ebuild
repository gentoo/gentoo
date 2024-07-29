# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..13} )

CRATES="
	ahash@0.8.3
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	hashbrown@0.13.2
	heck@0.4.1
	indoc@2.0.4
	libc@0.2.140
	lock_api@0.4.9
	memchr@2.5.0
	memoffset@0.9.0
	once_cell@1.17.1
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	proc-macro2@1.0.52
	pyo3-build-config@0.20.0
	pyo3-ffi@0.20.0
	pyo3-macros-backend@0.20.0
	pyo3-macros@0.20.0
	pyo3@0.20.0
	quote@1.0.26
	redox_syscall@0.2.16
	regress@0.7.1
	scopeguard@1.1.0
	smallvec@1.10.0
	syn@2.0.12
	target-lexicon@0.12.6
	unicode-ident@1.0.8
	unindent@0.2.3
	version_check@0.9.4
	windows-sys@0.45.0
	windows-targets@0.42.2
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_msvc@0.42.2
	windows_i686_gnu@0.42.2
	windows_i686_msvc@0.42.2
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_msvc@0.42.2
"

inherit cargo distutils-r1

DESCRIPTION="Python bindings to the Rust regress crate"
HOMEPAGE="
	https://pypi.org/project/regress/
	https://github.com/crate-py/regress
"
SRC_URI="
	https://github.com/crate-py/regress/releases/download/v${PV}/${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/regress/regress.*.so"
