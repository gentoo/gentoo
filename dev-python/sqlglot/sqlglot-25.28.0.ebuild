# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

CARGO_OPTIONAL=1
CRATES="
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	heck@0.4.1
	indoc@2.0.4
	libc@0.2.150
	lock_api@0.4.11
	memoffset@0.9.0
	once_cell@1.19.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	proc-macro2@1.0.70
	pyo3-build-config@0.20.0
	pyo3-ffi@0.20.0
	pyo3-macros-backend@0.20.0
	pyo3-macros@0.20.0
	pyo3@0.20.0
	quote@1.0.33
	redox_syscall@0.4.1
	scopeguard@1.2.0
	smallvec@1.11.2
	syn@2.0.41
	target-lexicon@0.12.12
	unicode-ident@1.0.12
	unindent@0.2.3
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
"

inherit cargo distutils-r1 pypi optfeature

DESCRIPTION="An easily customizable SQL parser and transpiler"
HOMEPAGE="
	https://sqlglot.com/
	https://github.com/tobymao/sqlglot/
	https://pypi.org/project/sqlglot/
"
SRC_URI+="
	native-extensions? (
		${CARGO_CRATE_URIS}
	)
"

LICENSE="MIT"
LICENSE+=" native-extensions? ("
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016"
LICENSE+=" )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+native-extensions"

BDEPEND="
	native-extensions? (
		${RUST_DEPEND}
		dev-util/maturin[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/sqlglotrs/sqlglotrs.*.so"

src_unpack() {
	cargo_src_unpack
}

src_prepare() {
	# remove fragile timing check
	sed -i -e '/assertLessEqual(time\.time/d' tests/test_parser.py || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile

	if use native-extensions; then
		local DISTUTILS_USE_PEP517=maturin
		cd sqlglotrs || die
		distutils-r1_python_compile
		cd - >/dev/null || die
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# timing, sigh
		# https://github.com/tobymao/sqlglot/issues/3961
		tests/test_generator.py::TestGenerator::test_generate_nested_binary
	)
	local EPYTEST_IGNORE=(
		# Tests require pyspark or duckdb which aren't in the tree.
		# Pandas would be a requirement normally, but it gets ignored by proxy.
		"tests/dataframe/integration/test_dataframe.py"
		"tests/dataframe/integration/test_grouped_data.py"
		"tests/dataframe/integration/test_session.py"
		"tests/test_executor.py"
		"tests/test_optimizer.py"
	)

	# make sure not to use an earlier installed version
	local -x SQLGLOTRS_TOKENIZER=$(usex native-extensions 1 0)
	rm -rf sqlglotrs || die
	epytest
}

pkg_postinst() {
	optfeature "simplifying timedelta expressions" dev-python/python-dateutil
}
