# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )

RUST_MIN_VER=1.86
CRATES="
	aho-corasick@1.1.5
	alloca@0.4.0
	anes@0.1.6
	anstyle@1.0.14
	autocfg@1.5.1
	bumpalo@3.20.3
	cast@0.3.0
	cc@1.6.0
	cfg-if@1.0.5
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.6.7
	clap_builder@4.6.7
	clap_lex@1.1.1
	criterion-plot@0.8.2
	criterion@0.8.2
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	crunchy@0.2.4
	either@1.18.0
	find-msvc-tools@0.1.14
	futures-core@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	half@2.7.1
	heck@0.5.0
	itertools@0.13.0
	itoa@1.0.18
	js-sys@0.3.106
	libc@0.2.190
	memchr@2.8.3
	num-traits@0.2.19
	once_cell@1.21.4
	oorandom@11.1.5
	page_size@0.6.0
	pin-project-lite@0.2.17
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	portable-atomic@1.15.0
	proc-macro2@1.0.107
	pyo3-build-config@0.29.3
	pyo3-ffi@0.29.3
	pyo3-macros-backend@0.29.3
	pyo3-macros@0.29.3
	pyo3@0.29.3
	quote@1.0.47
	rayon-core@1.13.0
	rayon@1.12.0
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	rustversion@1.0.23
	same-file@1.0.6
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.151
	shlex@2.0.1
	slab@0.4.12
	syn@2.0.119
	syn@3.0.6
	target-lexicon@0.13.5
	tinytemplate@1.2.1
	unicode-ident@1.0.26
	walkdir@2.5.0
	wasm-bindgen-macro-support@0.2.129
	wasm-bindgen-macro@0.2.129
	wasm-bindgen-shared@0.2.129
	wasm-bindgen@0.2.129
	web-sys@0.3.106
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.61.2
	zerocopy-derive@0.8.59
	zerocopy@0.8.59
	zmij@1.0.23
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Python bindings for lzokay library"
HOMEPAGE="
	https://github.com/vlaci/lzallright
	https://pypi.org/project/lzallright
"
# sdist doesn't build (so didn't even get to check re tests)
SRC_URI="
	https://github.com/vlaci/lzallright/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/lzallright/_lzallright.*"

# dev-libs/lzokay is bundled, but it has no .pc (https://github.com/AxioDL/lzokay/issues/9)
# and the cxx crate it uses for binding generation needs sources available.

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
