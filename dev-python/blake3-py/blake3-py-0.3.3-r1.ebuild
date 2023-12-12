# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	arrayref@0.3.7
	arrayvec@0.7.4
	autocfg@1.1.0
	bitflags@1.3.2
	blake3@1.4.0
	block-buffer@0.10.4
	cc@1.0.79
	cfg-if@1.0.0
	constant_time_eq@0.2.6
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	crypto-common@0.1.6
	digest@0.10.7
	either@1.8.1
	generic-array@0.14.7
	hermit-abi@0.2.6
	hex@0.4.3
	indoc@1.0.9
	libc@0.2.146
	lock_api@0.4.10
	memoffset@0.6.5
	memoffset@0.9.0
	num_cpus@1.15.0
	once_cell@1.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	proc-macro2@1.0.60
	pyo3-build-config@0.17.3
	pyo3-ffi@0.17.3
	pyo3-macros-backend@0.17.3
	pyo3-macros@0.17.3
	pyo3@0.17.3
	quote@1.0.28
	rayon-core@1.11.0
	rayon@1.7.0
	redox_syscall@0.3.5
	scopeguard@1.1.0
	smallvec@1.10.0
	subtle@2.5.0
	syn@1.0.109
	target-lexicon@0.12.7
	typenum@1.16.0
	unicode-ident@1.0.9
	unindent@0.1.11
	version_check@0.9.4
	windows-targets@0.48.0
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.48.0
"

inherit cargo distutils-r1

MY_P=blake3-py-${PV}
DESCRIPTION="Python bindings for the BLAKE3 cryptographic hash function"
HOMEPAGE="
	https://github.com/oconnor663/blake3-py/
	https://pypi.org/project/blake3/
"
SRC_URI="
	https://github.com/oconnor663/blake3-py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/${MY_P}

LICENSE="|| ( CC0-1.0 Apache-2.0 )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD MIT
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/blake3/blake3.*.so"

distutils_enable_tests pytest
