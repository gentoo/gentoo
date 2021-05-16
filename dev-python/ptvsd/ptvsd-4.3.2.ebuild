# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="Visual Studio remote debugging server for Python"
HOMEPAGE="https://pypi.org/project/ptvsd/ https://github.com/Microsoft/ptvsd/"
SRC_URI="https://github.com/microsoft/ptvsd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
