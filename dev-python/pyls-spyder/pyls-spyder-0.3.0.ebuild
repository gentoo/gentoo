# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Spyder extensions for the python language server"
HOMEPAGE="https://github.com/spyder-ide/pyls-spyder
	https://pypi.org/project/pyls-spyder/"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}-gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-python/python-language-server-0.36.2[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/mock )"

distutils_enable_tests pytest
