# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYPI_VERIFY_REPO=https://github.com/crate-py/rpds
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

CRATES="
	archery@1.2.2
	autocfg@1.5.0
	cc@1.2.34
	heck@0.5.0
	indoc@2.0.6
	libc@0.2.175
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	pyo3-build-config@0.27.1
	pyo3-ffi@0.27.1
	pyo3-macros-backend@0.27.1
	pyo3-macros@0.27.1
	pyo3@0.27.1
	python3-dll-a@0.2.14
	quote@1.0.40
	rpds@1.2.0
	shlex@1.3.0
	syn@2.0.106
	target-lexicon@0.13.2
	triomphe@0.1.14
	unicode-ident@1.0.18
	unindent@0.2.4
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
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/rpds/rpds.*.so"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}
