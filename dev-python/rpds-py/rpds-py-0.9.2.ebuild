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
	libc@0.2.147
	lock_api@0.4.10
	memoffset@0.9.0
	once_cell@1.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	proc-macro2@1.0.66
	pyo3-build-config@0.19.1
	pyo3-ffi@0.19.1
	pyo3-macros-backend@0.19.1
	pyo3-macros@0.19.1
	pyo3@0.19.1
	quote@1.0.31
	redox_syscall@0.3.5
	rpds@0.13.0
	scopeguard@1.1.0
	smallvec@1.11.0
	static_assertions@1.1.0
	syn@1.0.109
	target-lexicon@0.12.9
	unicode-ident@1.0.11
	unindent@0.1.11
	windows-targets@0.48.1
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.48.0
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
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/rpds/rpds.*.so"

distutils_enable_tests pytest
