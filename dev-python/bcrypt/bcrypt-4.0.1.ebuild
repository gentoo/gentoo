# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
DISTUTILS_USE_PEP517=setuptools

CRATES="
	autocfg-1.1.0
	base64-0.13.0
	bcrypt-0.13.0
	bcrypt-pbkdf-0.8.1
	bitflags-1.3.2
	block-buffer-0.10.3
	blowfish-0.9.1
	byteorder-1.4.3
	cfg-if-1.0.0
	cipher-0.4.3
	cpufeatures-0.2.5
	crypto-common-0.1.6
	digest-0.10.5
	generic-array-0.14.6
	getrandom-0.2.7
	indoc-0.3.6
	indoc-impl-0.3.6
	inout-0.1.3
	instant-0.1.12
	libc-0.2.134
	lock_api-0.4.9
	once_cell-1.15.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	paste-0.1.18
	paste-impl-0.1.18
	pbkdf2-0.10.1
	proc-macro-hack-0.5.19
	proc-macro2-1.0.46
	pyo3-0.15.2
	pyo3-build-config-0.15.2
	pyo3-macros-0.15.2
	pyo3-macros-backend-0.15.2
	quote-1.0.21
	redox_syscall-0.2.16
	scopeguard-1.1.0
	sha2-0.10.6
	smallvec-1.10.0
	subtle-2.4.1
	syn-1.0.102
	typenum-1.15.0
	unicode-ident-1.0.4
	unindent-0.1.10
	version_check-0.9.4
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	zeroize-1.5.7
"

inherit cargo distutils-r1

DESCRIPTION="Modern password hashing for software and servers"
HOMEPAGE="
	https://github.com/pyca/bcrypt/
	https://pypi.org/project/bcrypt/
"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	$(cargo_crate_uris)
"

SLOT="0"
LICENSE="Apache-2.0"
LICENSE+=" Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-DFS-2016"
LICENSE+=" Unlicense"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
"

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/bcrypt/_bcrypt.*.so"

distutils_enable_tests pytest
