# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm
PYTHON_COMPAT=( python3_{8..11} pypy3 )
inherit distutils-r1

DESCRIPTION="Python tool configuration"
HOMEPAGE="
	https://pypi.org/project/pytoolconfig/
	https://github.com/bageljrkhanofemus/pytoolconfig
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.8 3.9 )
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{8..10} )
"

distutils_enable_tests pytest
