# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

CRATES="
	autocfg@1.1.0
	base64@0.21.5
	bcrypt-pbkdf@0.10.0
	bcrypt@0.15.0
	bitflags@1.3.2
	block-buffer@0.10.4
	blowfish@0.9.1
	byteorder@1.5.0
	cfg-if@1.0.0
	cipher@0.4.4
	cpufeatures@0.2.11
	crypto-common@0.1.6
	digest@0.10.7
	generic-array@0.14.7
	getrandom@0.2.11
	heck@0.4.1
	indoc@2.0.4
	inout@0.1.3
	libc@0.2.151
	lock_api@0.4.11
	memoffset@0.9.0
	once_cell@1.19.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	pbkdf2@0.12.2
	proc-macro2@1.0.70
	pyo3-build-config@0.20.0
	pyo3-ffi@0.20.0
	pyo3-macros-backend@0.20.0
	pyo3-macros@0.20.0
	pyo3@0.20.0
	quote@1.0.33
	redox_syscall@0.4.1
	scopeguard@1.2.0
	sha2@0.10.8
	smallvec@1.11.2
	subtle@2.5.0
	syn@2.0.41
	target-lexicon@0.12.12
	typenum@1.17.0
	unicode-ident@1.0.12
	unindent@0.2.3
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
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
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
"

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/bcrypt/_bcrypt.*.so"

distutils_enable_tests pytest
