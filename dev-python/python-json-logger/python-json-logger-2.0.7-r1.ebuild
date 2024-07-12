# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Standard python logging to output log data as json objects"
HOMEPAGE="
	https://github.com/madzak/python-json-logger/
	https://pypi.org/project/python-json-logger/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/madzak/python-json-logger/pull/188
	"${FILESDIR}/${P}-py312.patch"
	# https://github.com/madzak/python-json-logger/pull/192
	"${FILESDIR}/${P}-py313.patch"
)

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
