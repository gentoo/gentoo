# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Standard python logging to output log data as json objects"
HOMEPAGE="
	https://github.com/madzak/python-json-logger/
	https://pypi.org/project/python-json-logger/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	case ${EPYTHON} in
		python3.12)
			EPYTEST_DESELECT+=(
				tests/test_jsonlogger.py::TestJsonLogger::test_custom_object_serialization
				tests/test_jsonlogger.py::TestJsonLogger::test_percentage_format
				tests/test_jsonlogger.py::TestJsonLogger::test_rename_reserved_attrs
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
