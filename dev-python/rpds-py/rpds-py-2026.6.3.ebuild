# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYPI_VERIFY_REPO=https://github.com/crate-py/rpds
PYTHON_COMPAT=( python3_{12..15} )

CRATES="
	archery@1.2.2
	heck@0.5.0
	libc@0.2.177
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.103
	pyo3-build-config@0.29.0
	pyo3-ffi@0.29.0
	pyo3-macros-backend@0.29.0
	pyo3-macros@0.29.0
	pyo3@0.29.0
	quote@1.0.42
	rpds@1.2.1
	smallvec@1.15.1
	syn@2.0.111
	target-lexicon@0.13.3
	triomphe@0.1.15
	unicode-ident@1.0.22
"

RUST_MIN_VER="1.85.0"

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
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/rpds/rpds.*.so"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}
