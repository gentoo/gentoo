# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..13} )

CRATES="
	ahash@0.8.11
	aho-corasick@1.1.3
	any_ascii@0.1.7
	arc-swap@1.7.1
	autocfg@1.3.0
	beef@0.5.2
	bitflags@2.6.0
	bstr@1.10.0
	cfg-if@1.0.0
	countme@3.0.1
	deranged@0.3.11
	derivative@2.2.0
	either@1.13.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-timer@3.0.3
	futures-util@0.3.30
	futures@0.3.30
	getrandom@0.2.15
	glob@0.3.1
	globset@0.4.14
	hashbrown@0.14.5
	heck@0.4.1
	idna@0.5.0
	indoc@2.0.5
	itertools@0.10.5
	itoa@1.0.11
	lexical-sort@0.3.1
	libc@0.2.158
	lock_api@0.4.12
	log@0.4.22
	logos-derive@0.12.1
	logos@0.12.1
	memchr@2.7.4
	memoffset@0.9.1
	num-conv@0.1.0
	once_cell@1.19.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	pep440_rs@0.6.6
	pep508_rs@0.6.1
	percent-encoding@2.3.1
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	portable-atomic@1.7.0
	powerfmt@0.2.0
	proc-macro2@1.0.86
	pyo3-build-config@0.21.2
	pyo3-ffi@0.21.2
	pyo3-macros-backend@0.21.2
	pyo3-macros@0.21.2
	pyo3@0.21.2
	quote@1.0.37
	redox_syscall@0.5.3
	regex-automata@0.4.7
	regex-syntax@0.6.29
	regex-syntax@0.8.4
	regex@1.10.6
	relative-path@1.9.3
	rowan@0.15.16
	rstest@0.19.0
	rstest_macros@0.19.0
	rustc-hash@1.1.0
	rustc_version@0.4.1
	ryu@1.0.18
	scopeguard@1.2.0
	semver@1.0.23
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	slab@0.4.9
	smallvec@1.13.2
	syn@1.0.109
	syn@2.0.77
	taplo@0.13.2
	target-lexicon@0.12.16
	text-size@1.1.1
	thiserror-impl@1.0.63
	thiserror@1.0.63
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing@0.1.40
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-width@0.1.13
	unindent@0.2.3
	unscanny@0.1.0
	url@2.5.2
	urlencoding@2.1.3
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Format your pyproject.toml file (Rust extension)"
HOMEPAGE="
	https://github.com/tox-dev/pyproject-fmt-rust/
	https://pypi.org/project/pyproject-fmt-rust/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions ISC MIT Unicode-DFS-2016
	|| ( Apache-2.0 BSD-2 )
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/pyproject_fmt_rust/_lib.*.so"

src_prepare() {
	sed -i -e '/strip/d' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test_all() {
	cargo_src_test
}
