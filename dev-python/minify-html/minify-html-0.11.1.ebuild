# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..12} )

CRATES="
	aho-corasick@0.7.20
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	convert_case@0.4.0
	css-minify@0.3.1
	derive_more@0.99.17
	hashbrown@0.12.3
	indexmap@1.9.3
	indoc@1.0.9
	lazy_static@1.4.0
	libc@0.2.143
	lock_api@0.4.9
	memchr@2.5.0
	memoffset@0.6.5
	minify-js@0.4.3
	minimal-lexical@0.2.1
	nom@7.1.3
	once_cell@1.17.1
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	parse-js@0.10.3
	proc-macro2@1.0.56
	pyo3-build-config@0.17.3
	pyo3-ffi@0.17.3
	pyo3-macros-backend@0.17.3
	pyo3-macros@0.17.3
	pyo3@0.17.3
	quote@1.0.26
	redox_syscall@0.2.16
	rustc-hash@1.1.0
	rustc_version@0.4.0
	scopeguard@1.1.0
	semver@1.0.17
	smallvec@1.10.0
	syn@1.0.109
	target-lexicon@0.12.7
	unicode-ident@1.0.8
	unindent@0.1.11
	windows-sys@0.45.0
	windows-targets@0.42.2
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_msvc@0.42.2
	windows_i686_gnu@0.42.2
	windows_i686_msvc@0.42.2
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_msvc@0.42.2
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Extremely fast and smart HTML + JS + CSS minifier"
HOMEPAGE="
	https://github.com/wilsonzlin/minify-html/
	https://pypi.org/project/minify-html/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/minify_html/minify_html.*.so"
