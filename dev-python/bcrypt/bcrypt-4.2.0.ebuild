# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

CRATES="
	autocfg@1.3.0
	base64@0.22.1
	bcrypt-pbkdf@0.10.0
	bcrypt@0.15.1
	block-buffer@0.10.4
	blowfish@0.9.1
	byteorder@1.5.0
	cfg-if@1.0.0
	cipher@0.4.4
	cpufeatures@0.2.12
	crypto-common@0.1.6
	digest@0.10.7
	generic-array@0.14.7
	getrandom@0.2.15
	heck@0.5.0
	indoc@2.0.5
	inout@0.1.3
	libc@0.2.155
	memoffset@0.9.1
	once_cell@1.19.0
	pbkdf2@0.12.2
	portable-atomic@1.7.0
	proc-macro2@1.0.86
	pyo3-build-config@0.22.2
	pyo3-ffi@0.22.2
	pyo3-macros-backend@0.22.2
	pyo3-macros@0.22.2
	pyo3@0.22.2
	quote@1.0.36
	sha2@0.10.8
	subtle@2.6.1
	syn@2.0.72
	target-lexicon@0.12.15
	typenum@1.17.0
	unicode-ident@1.0.12
	unindent@0.2.3
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	zeroize@1.8.1
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Modern password hashing for software and servers"
HOMEPAGE="
	https://github.com/pyca/bcrypt/
	https://pypi.org/project/bcrypt/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~loong ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	>=dev-python/setuptools-rust-1.7.0[${PYTHON_USEDEP}]
"

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/bcrypt/_bcrypt.*.so"

distutils_enable_tests pytest

export UNSAFE_PYO3_SKIP_VERSION_CHECK=1

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
