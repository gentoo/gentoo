# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

CRATES="
	ahash@0.8.12
	aho-corasick@1.1.3
	autocfg@1.3.0
	base64@0.22.1
	bitflags@2.9.1
	bitvec@1.0.1
	bumpalo@3.19.0
	cc@1.0.101
	cfg-if@1.0.0
	displaydoc@0.2.5
	enum_dispatch@0.3.13
	form_urlencoded@1.2.1
	funty@2.0.0
	getrandom@0.3.3
	heck@0.5.0
	hex@0.4.3
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	indoc@2.0.5
	itoa@1.0.11
	jiter@0.10.0
	js-sys@0.3.77
	lexical-parse-float@1.0.5
	lexical-parse-integer@1.0.5
	lexical-util@1.0.6
	libc@0.2.155
	litemap@0.7.3
	log@0.4.27
	memchr@2.7.4
	memoffset@0.9.1
	num-bigint@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	once_cell@1.19.0
	percent-encoding@2.3.1
	portable-atomic@1.6.0
	proc-macro2@1.0.86
	pyo3-build-config@0.25.1
	pyo3-ffi@0.25.1
	pyo3-macros-backend@0.25.1
	pyo3-macros@0.25.1
	pyo3@0.25.1
	python3-dll-a@0.2.14
	quote@1.0.36
	r-efi@5.2.0
	radium@0.7.0
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.1
	rustversion@1.0.17
	ryu@1.0.18
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.140
	smallvec@1.15.1
	speedate@0.16.0
	stable_deref_trait@1.2.0
	static_assertions@1.1.0
	strum@0.27.1
	strum_macros@0.27.1
	syn@2.0.82
	synstructure@0.13.1
	tap@1.0.1
	target-lexicon@0.13.2
	tinystr@0.7.6
	unicode-ident@1.0.12
	unindent@0.2.3
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	uuid@1.17.0
	version_check@0.9.5
	wasi@0.14.2+wasi-0.2.4
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	wit-bindgen-rt@0.39.0
	write16@1.0.0
	writeable@0.5.5
	wyz@0.5.1
	yoke-derive@0.7.4
	yoke@0.7.4
	zerocopy-derive@0.8.25
	zerocopy@0.8.25
	zerofrom-derive@0.1.4
	zerofrom@0.1.4
	zerovec-derive@0.10.3
	zerovec@0.10.4
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Core validation logic for pydantic written in Rust"
HOMEPAGE="
	https://github.com/pydantic/pydantic-core/
	https://pypi.org/project/pydantic_core/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0 Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/typing-extensions-4.13.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/dirty-equals-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.63.0[${PYTHON_USEDEP}]
		>=dev-python/inline-snapshot-0.13.3[${PYTHON_USEDEP}]
		>=dev-python/pydantic-1.10.4[${PYTHON_USEDEP}]
		>=dev-python/typing-inspection-0.4.1[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{mock,timeout} )
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/pydantic_core/_pydantic_core.*.so"

src_prepare() {
	distutils-r1_src_prepare

	sed -i -e '/--benchmark/d' pyproject.toml || die
	sed -i -e '/^strip/d' Cargo.toml || die
}

python_test() {
	local EPYTEST_IGNORE=(
		tests/benchmarks
	)
	local EPYTEST_DESELECT=(
		# TODO: recursion till segfault
		tests/serializers/test_functions.py::test_recursive_call
	)

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# different repr() in exception
				# https://github.com/pypy/pypy/issues/5220
				tests/validators/test_arguments.py::test_error_display
				tests/validators/test_definitions_recursive.py::test_error_inside_definition_wrapper
				tests/validators/test_string.py::test_invalid_regex
				tests/validators/test_string.py::test_backtracking_regex_rust_unsupported
				tests/validators/test_union.py::test_empty_choices
			)
			;;
	esac

	rm -rf pydantic_core || die
	# tests link to libpython, so they fail to link on pypy3
	[[ ${EPYTHON} != pypy3* ]] && cargo_src_test
	epytest -o xfail_strict=False -o addopts=
}
