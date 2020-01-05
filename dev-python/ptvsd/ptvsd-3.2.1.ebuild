# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Visual Studio remote debugging server for Python"
HOMEPAGE="https://pypi.org/project/ptvsd/ https://github.com/Microsoft/ptvsd/"
SRC_URI="https://files.pythonhosted.org/packages/59/de/54ad88ba555ce66920165949febf4810359c000c4c73568a6215603b437d/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
