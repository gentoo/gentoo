# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi optfeature

DESCRIPTION="An easily customizable SQL parser and transpiler"
HOMEPAGE="
	https://sqlglot.com/
	https://github.com/tobymao/sqlglot/
	https://pypi.org/project/sqlglot/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

EPYTEST_IGNORE=(
	# Tests require pyspark or duckdb which aren't in the tree.
	# Pandas would be a requirement normally, but it gets ignored by proxy.
	"tests/dataframe/integration/test_dataframe.py"
	"tests/dataframe/integration/test_grouped_data.py"
	"tests/dataframe/integration/test_session.py"
	"tests/test_executor.py"
	"tests/test_optimizer.py"
)

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "simplifying timedelta expressions" dev-python/python-dateutil
}
