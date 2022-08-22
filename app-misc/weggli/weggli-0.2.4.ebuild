# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	ansi_term-0.12.1
	assert_cmd-2.0.2
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.3.2
	bstr-0.2.17
	bumpalo-3.9.1
	cast-0.2.7
	cc-1.0.72
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	clap-2.34.0
	colored-2.0.0
	criterion-0.3.5
	criterion-plot-0.4.4
	crossbeam-channel-0.5.2
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.6
	crossbeam-utils-0.8.6
	csv-1.1.6
	csv-core-0.1.10
	ctor-0.1.21
	difference-2.0.0
	difflib-0.4.0
	doc-comment-0.3.3
	either-1.6.1
	float-cmp-0.8.0
	ghost-0.1.2
	half-1.8.2
	hermit-abi-0.1.19
	indoc-0.3.6
	indoc-impl-0.3.6
	instant-0.1.12
	inventory-0.1.11
	inventory-impl-0.1.11
	itertools-0.10.3
	itoa-0.4.8
	itoa-1.0.1
	js-sys-0.3.55
	lazy_static-1.4.0
	libc-0.2.112
	lock_api-0.4.5
	log-0.4.14
	memchr-2.4.1
	memoffset-0.6.5
	nix-0.17.0
	normalize-line-endings-0.3.0
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.1
	oorandom-11.1.3
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	paste-0.1.18
	paste-impl-0.1.18
	plotters-0.3.1
	plotters-backend-0.3.2
	plotters-svg-0.3.1
	predicates-1.0.8
	predicates-2.1.0
	predicates-core-1.0.2
	predicates-tree-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-1.0.36
	pyo3-0.13.2
	pyo3-macros-0.13.2
	pyo3-macros-backend-0.13.2
	quote-1.0.14
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.10
	regex-1.5.4
	regex-automata-0.1.10
	regex-syntax-0.6.25
	rustc-hash-1.1.0
	rustc_version-0.4.0
	ryu-1.0.9
	same-file-1.0.6
	scopeguard-1.1.0
	semver-1.0.4
	serde-1.0.133
	serde_cbor-0.11.2
	serde_derive-1.0.133
	serde_json-1.0.74
	simplelog-0.10.2
	smallvec-1.7.0
	strsim-0.8.0
	syn-1.0.85
	termcolor-1.1.2
	termtree-0.2.4
	textwrap-0.11.0
	time-0.1.44
	tinytemplate-1.2.1
	tree-sitter-0.20.2
	unicode-width-0.1.9
	unicode-xid-0.2.2
	unindent-0.1.7
	vec_map-0.8.2
	void-1.0.2
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.10.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.78
	wasm-bindgen-backend-0.2.78
	wasm-bindgen-macro-0.2.78
	wasm-bindgen-macro-support-0.2.78
	wasm-bindgen-shared-0.2.78
	web-sys-0.3.55
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

# We can inherit distutils-r1 here and build the Python
# module. Unfortunately the Python module seems to not include the
# tree-sitter grammar. Patching the .so to need the system's
# libtree-sitter-cpp seems to work, but it is not correct because the
# weggli grammar has some minor modifications.
inherit cargo flag-o-matic

DESCRIPTION="a fast and robust semantic search tool for C and C++ codebases"
HOMEPAGE="https://github.com/googleprojectzero/weggli"
SRC_URI="
	https://github.com/googleprojectzero/weggli/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default

	# 854741
	filter-lto
}
