# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

CRATES="
	archery@1.2.1
	autocfg@1.4.0
	cc@1.2.22
	heck@0.5.0
	indoc@2.0.6
	libc@0.2.172
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.0
	proc-macro2@1.0.95
	pyo3-build-config@0.25.0
	pyo3-ffi@0.25.0
	pyo3-macros-backend@0.25.0
	pyo3-macros@0.25.0
	pyo3@0.25.0
	python3-dll-a@0.2.13
	quote@1.0.40
	rpds@1.1.1
	shlex@1.3.0
	syn@2.0.101
	target-lexicon@0.13.2
	triomphe@0.1.14
	unicode-ident@1.0.18
	unindent@0.2.4
"

RUST_MIN_VER="1.77.1"

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
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/rpds/rpds.*.so"

export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

distutils_enable_tests pytest
