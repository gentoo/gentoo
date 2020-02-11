# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Python client library for Core API"
HOMEPAGE="https://github.com/core-api/python-client"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/coreschema[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
dev-python/setuptools[${PYTHON_USEDEP}]"
