# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="A Python data analysis library that is optimized for humans instead of machines"
HOMEPAGE="https://github.com/wireservice/agate https://pypi.org/project/agate/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +xml"
RESTRICT="!test? ( test )"

# Other packages have BDEPEND="test? ( dev-python/agate[xml] )"
LEATHER_VERSION_DEP=">=dev-python/leather-0.3.3-r2"
TEST_AGAINST_RDEPEND="xml? ( ${LEATHER_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"
RDEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/pytimeparse-1.1.5[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.1[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.0[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/pyicu-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/python-slugify-1.2.1[${PYTHON_USEDEP}]
	${LEATHER_VERSION_DEP}[${PYTHON_USEDEP}]

	${TEST_AGAINST_RDEPEND}
"
BDEPEND="test? ( ${LEATHER_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

# @FUNCTION: pytest-expect-to-deselect
# @USAGE: readarray -t pytest_args < <(pytest-expect-to-deselect <<<PYTEST_EXPECT_CONTENT)
# @DESCRIPTION:
# Read a pytest-expect pytest --xfail-file file from stdin and write
# equivalent pytest --deselect arguments to stdout for consumption by
# readarray -t. The generated pytest --deselect arguments are appropriate
# for use as described here:
# https://dev.gentoo.org/~mgorny/python-guide/pytest.html#skipping-tests-based-on-paths-names
pytest-expect-to-deselect() {
	while read -r; do
		[[ ${REPLY} =~ ^[u]?\'([^\']*) ]] || continue
		printf -- '%s\n' --deselect "${BASH_REMATCH[1]}" || return
	done
}

python_test() {
	# test_cast_format_locale fails with "locale.Error: unsupported locale setting"
	# which appears to be triggered by these locale settings in the unit tests:
	#
	#   agate-1.6.2/tests/test_data_types.py:257:    def test_cast_format_locale(self):
	#   agate-1.6.2/tests/test_data_types.py-258-        date_type = Date(date_format='%d-%b-%Y', locale='de_DE')
	#   agate-1.6.2/tests/test_data_types.py:381:    def test_cast_format_locale(self):
	#   agate-1.6.2/tests/test_data_types.py-382-        date_type = DateTime(datetime_format='%Y-%m-%d %I:%M %p', locale='ko_KR')

	local -a pytest_args
	readarray -t pytest_args < <(pytest-expect-to-deselect <<<"
pytest-expect file v1
(3, 8, 10, 'final', 0)
u'tests/test_data_types.py::TestDate::test_cast_format_locale': FAIL
u'tests/test_data_types.py::TestDateTime::test_cast_format_locale': FAIL
")

	epytest "${pytest_args[@]}" || die
}
