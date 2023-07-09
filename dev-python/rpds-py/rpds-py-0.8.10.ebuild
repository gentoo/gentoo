# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..12} )

CRATES="
	archery@0.5.0
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	indoc@1.0.9
	libc@0.2.139
	lock_api@0.4.9
	memoffset@0.9.0
	once_cell@1.17.1
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	proc-macro2@1.0.51
	pyo3-build-config@0.19.1
	pyo3-ffi@0.19.1
	pyo3-macros-backend@0.19.1
	pyo3-macros@0.19.1
	pyo3@0.19.1
	quote@1.0.23
	redox_syscall@0.2.16
	rpds@0.13.0
	scopeguard@1.1.0
	smallvec@1.10.0
	static_assertions@1.1.0
	syn@1.0.109
	target-lexicon@0.12.6
	unicode-ident@1.0.6
	unindent@0.1.11
	windows-sys@0.45.0
	windows-targets@0.42.1
	windows_aarch64_gnullvm@0.42.1
	windows_aarch64_msvc@0.42.1
	windows_i686_gnu@0.42.1
	windows_i686_msvc@0.42.1
	windows_x86_64_gnu@0.42.1
	windows_x86_64_gnullvm@0.42.1
	windows_x86_64_msvc@0.42.1
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Python bindings to Rust's persistent data structures (rpds)"
HOMEPAGE="
	https://github.com/crate-py/rpds/
	https://pypi.org/project/rpds-py/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT MPL-2.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/rpds/rpds.*.so"

distutils_enable_tests pytest
