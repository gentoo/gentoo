# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A plugin for pytest that provides access to test session metadata"
HOMEPAGE="https://github.com/pytest-dev/pytest-metadata/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
