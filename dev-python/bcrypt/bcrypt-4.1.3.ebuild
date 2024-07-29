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
	bitflags@2.5.0
	block-buffer@0.10.4
	blowfish@0.9.1
	byteorder@1.5.0
	cfg-if@1.0.0
	cipher@0.4.4
	cpufeatures@0.2.12
	crypto-common@0.1.6
	digest@0.10.7
	generic-array@0.14.7
	getrandom@0.2.14
	heck@0.4.1
	indoc@2.0.5
	inout@0.1.3
	libc@0.2.154
	lock_api@0.4.12
	memoffset@0.9.1
	once_cell@1.19.0
	parking_lot@0.12.2
	parking_lot_core@0.9.10
	pbkdf2@0.12.2
	portable-atomic@1.6.0
	proc-macro2@1.0.81
	pyo3-build-config@0.21.2
	pyo3-ffi@0.21.2
	pyo3-macros-backend@0.21.2
	pyo3-macros@0.21.2
	pyo3@0.21.2
	quote@1.0.36
	redox_syscall@0.5.1
	scopeguard@1.2.0
	sha2@0.10.8
	smallvec@1.13.2
	subtle@2.5.0
	syn@2.0.60
	target-lexicon@0.12.14
	typenum@1.17.0
	unicode-ident@1.0.12
	unindent@0.2.3
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.52.5
	zeroize@1.7.0
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
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
"

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/bcrypt/_bcrypt.*.so"

distutils_enable_tests pytest

export UNSAFE_PYO3_SKIP_VERSION_CHECK=1

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
