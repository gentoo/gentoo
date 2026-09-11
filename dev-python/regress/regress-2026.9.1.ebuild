# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )

RUST_MIN_VER="1.85.0"
CRATES="
	heck@0.5.0
	libc@0.2.175
	memchr@2.7.5
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	pyo3-build-config@0.29.2
	pyo3-ffi@0.29.2
	pyo3-macros-backend@0.29.2
	pyo3-macros@0.29.2
	pyo3@0.29.2
	quote@1.0.40
	regress@0.12.0
	syn@2.0.106
	target-lexicon@0.13.4
	unicode-ident@1.0.18
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
LICENSE+="
	Apache-2.0-with-LLVM-exceptions Unicode-3.0
	|| ( Apache-2.0 MIT )
	|| ( MIT Unlicense )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/regress/regress.*.so"

export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
