# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
CARGO_OPTIONAL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
CRATE_PV=28.7.0

inherit cargo distutils-r1 pypi optfeature

DESCRIPTION="An easily customizable SQL parser and transpiler"
HOMEPAGE="
	https://sqlglot.com/
	https://github.com/tobymao/sqlglot/
	https://pypi.org/project/sqlglot/
"
SRC_URI+="
	native-extensions? (
		https://github.com/gentoo-crate-dist/sqlglot/releases/download/v${CRATE_PV}/sqlglot-${CRATE_PV}-crates.tar.xz
	)
"

LICENSE="MIT"
LICENSE+=" native-extensions? ("
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
"
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

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/sqlglotrs/sqlglotrs.*.so"

pkg_setup() {
	use native-extensions && rust_pkg_setup
}

src_unpack() {
	cargo_src_unpack
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
