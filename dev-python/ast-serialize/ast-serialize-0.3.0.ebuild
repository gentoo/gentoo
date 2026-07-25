# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYPI_VERIFY_REPO=https://github.com/mypyc/ast_serialize
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

RUST_MIN_VER="1.91"
CRATES="
	aho-corasick@1.1.4
	anyhow@1.0.100
	attribute-derive-macro@0.10.5
	attribute-derive@0.10.5
	bitflags@2.10.0
	block-buffer@0.10.4
	bstr@1.12.1
	castaway@0.2.4
	cfg-if@1.0.4
	collection_literals@1.0.3
	compact_str@0.9.0
	cpufeatures@0.2.17
	crypto-common@0.1.7
	derive-where@1.6.0
	digest@0.10.7
	either@1.15.0
	equivalent@1.0.2
	generic-array@0.14.7
	get-size-derive2@0.7.4
	get-size2@0.7.4
	getopts@0.2.24
	getrandom@0.2.17
	hashbrown@0.16.1
	heck@0.5.0
	indexmap@2.13.0
	indoc@2.0.7
	interpolator@0.5.0
	is-macro@0.3.7
	itertools@0.14.0
	itoa@1.0.17
	libc@0.2.180
	log@0.4.29
	manyhow-macros@0.11.4
	manyhow@0.11.4
	memchr@2.7.6
	once_cell@1.21.3
	ordermap@1.1.0
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_shared@0.11.3
	portable-atomic@1.13.0
	ppv-lite86@0.2.21
	proc-macro-utils@0.10.0
	proc-macro2@1.0.106
	pyo3-build-config@0.28.2
	pyo3-ffi@0.28.2
	pyo3-macros-backend@0.28.2
	pyo3-macros@0.28.2
	pyo3@0.28.2
	quote-use-macros@0.8.4
	quote-use@0.8.4
	quote@1.0.44
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	regex-automata@0.4.13
	rustc-hash@2.1.1
	rustversion@1.0.22
	ryu@1.0.22
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	sha1@0.10.6
	siphasher@1.0.1
	smallvec@1.15.1
	static_assertions@1.1.0
	syn@2.0.114
	target-lexicon@0.13.5
	thiserror-impl@2.0.18
	thiserror@2.0.18
	tinyvec@1.10.0
	tinyvec_macros@0.1.1
	typenum@1.19.0
	unicode-ident@1.0.22
	unicode-normalization@0.1.25
	unicode-width@0.2.2
	unicode_names2@1.3.0
	unicode_names2_generator@1.3.0
	version_check@0.9.5
	wasi@0.11.1+wasi-snapshot-preview1
	zerocopy-derive@0.8.33
	zerocopy@0.8.33
"

declare -A GIT_CRATES=(
	[ruff_python_ast]='https://github.com/astral-sh/ruff;5e4a3d9c3b381df20f6a52caef0f56ed0ebc74be;ruff-%commit%/crates/ruff_python_ast'
	[ruff_python_parser]='https://github.com/astral-sh/ruff;5e4a3d9c3b381df20f6a52caef0f56ed0ebc74be;ruff-%commit%/crates/ruff_python_parser'
	[ruff_python_trivia]='https://github.com/astral-sh/ruff;5e4a3d9c3b381df20f6a52caef0f56ed0ebc74be;ruff-%commit%/crates/ruff_python_trivia'
	[ruff_source_file]='https://github.com/astral-sh/ruff;5e4a3d9c3b381df20f6a52caef0f56ed0ebc74be;ruff-%commit%/crates/ruff_source_file'
	[ruff_text_size]='https://github.com/astral-sh/ruff;5e4a3d9c3b381df20f6a52caef0f56ed0ebc74be;ruff-%commit%/crates/ruff_text_size'
)

inherit cargo distutils-r1 pypi

DESCRIPTION="Python bindings for mypy AST serialization"
HOMEPAGE="
	https://github.com/mypyc/ast_serialize/
	https://pypi.org/project/ast-serialize/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~s390 ~sparc ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/ast_serialize/ast_serialize.*"

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}
