# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

CRATES="
	aho-corasick@1.0.4
	anes@0.1.6
	annotate-snippets@0.6.1
	anstyle@1.0.2
	autocfg@1.1.0
	bitflags@2.4.0
	bumpalo@3.12.0
	cast@0.3.0
	cc@1.0.83
	cfg-if@1.0.0
	chic@1.2.2
	ciborium-io@0.2.0
	ciborium-ll@0.2.0
	ciborium@0.2.0
	clap@4.4.0
	clap_builder@4.4.0
	clap_lex@0.5.1
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-deque@0.8.1
	crossbeam-epoch@0.9.9
	crossbeam-utils@0.8.10
	difference@2.0.0
	either@1.6.1
	equivalent@1.0.1
	errno-dragonfly@0.1.2
	errno@0.3.2
	glob@0.3.0
	half@1.8.2
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.2
	indexmap@2.4.0
	indoc@2.0.4
	is-terminal@0.4.9
	itertools@0.10.5
	itertools@0.13.0
	itoa@1.0.2
	js-sys@0.3.58
	lazy_static@1.4.0
	libc@0.2.149
	linux-raw-sys@0.4.10
	log@0.4.17
	memchr@2.7.4
	memoffset@0.6.5
	memoffset@0.9.0
	num-traits@0.2.15
	once_cell@1.16.0
	oorandom@11.1.3
	paste@1.0.15
	peg-macros@0.8.4
	peg-runtime@0.8.3
	peg@0.8.4
	plotters-backend@0.3.2
	plotters-svg@0.3.1
	plotters@0.3.1
	portable-atomic@1.4.3
	proc-macro2@1.0.86
	pyo3-build-config@0.22.2
	pyo3-ffi@0.22.2
	pyo3-macros-backend@0.22.2
	pyo3-macros@0.22.2
	pyo3@0.22.2
	quote@1.0.37
	rayon-core@1.12.1
	rayon@1.10.0
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.6
	rustix@0.38.19
	ryu@1.0.10
	same-file@1.0.6
	scopeguard@1.1.0
	serde@1.0.208
	serde_derive@1.0.208
	serde_json@1.0.125
	serde_spanned@0.6.7
	syn@1.0.109
	syn@2.0.75
	target-lexicon@0.12.15
	termcolor@1.1.3
	thiserror-impl@1.0.63
	thiserror@1.0.63
	tinytemplate@1.2.1
	toml@0.8.19
	toml_datetime@0.6.8
	toml_edit@0.22.20
	trybuild@1.0.99
	unicode-ident@1.0.1
	unindent@0.2.3
	walkdir@2.3.2
	wasm-bindgen-backend@0.2.81
	wasm-bindgen-macro-support@0.2.81
	wasm-bindgen-macro@0.2.81
	wasm-bindgen-shared@0.2.81
	wasm-bindgen@0.2.81
	web-sys@0.3.58
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	winnow@0.6.18
"

inherit cargo distutils-r1 pypi

DESCRIPTION="A concrete syntax tree with AST-like properties for Python"
HOMEPAGE="
	https://github.com/Instagram/LibCST/
	https://pypi.org/project/libcst/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT Apache-2.0 PSF-2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	>=dev-python/pyyaml-5.2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/black[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/libcst/native.*"

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		libcst/codemod/tests/test_codemod_cli.py::TestCodemodCLI::test_codemod_formatter_error_input
	)
	local EPYTEST_IGNORE=(
		# fuzzing, require hypothesmith
		libcst/tests/test_fuzz.py
		# require pyre-check
		libcst/metadata/tests/test_type_inference_provider.py
		# requires `python -m libcst.codegen.generate` which has extra
		# deps and needs patching to work in our venv
		# TODO: figure out if we don't need that for revdeps anyway
		libcst/codegen/tests/test_codegen_clean.py
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# https://github.com/Instagram/LibCST/issues/1278
				libcst/codemod/commands/tests/test_rename_typing_generic_aliases.py::TestRenameCommand::test_rename_typing_generic_alias
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	# fixtures
	ln -s "${S}/native" . || die

	nonfatal epytest
	local ret=${?}

	rm native || die

	[[ ${ret} -ne 0 ]] && die "Tests failed on ${EPYTHON}"
}

python_test_all() {
	cd native || die
	cargo_src_test
}
