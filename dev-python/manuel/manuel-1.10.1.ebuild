# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="rdepend"
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Lets you mix and match traditional doctests with custom test syntax"
HOMEPAGE="https://github.com/benji-york/manuel/ https://pypi.org/project/manuel/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/zope-testing[${PYTHON_USEDEP}] )"

distutils_enable_tests setup.py
