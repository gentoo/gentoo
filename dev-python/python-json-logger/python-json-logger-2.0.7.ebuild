# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Standard python logging to output log data as json objects"
HOMEPAGE="
	https://github.com/madzak/python-json-logger/
	https://pypi.org/project/python-json-logger/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86"

distutils_enable_tests unittest
