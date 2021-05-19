# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Black plugin for the Python Language Server"
HOMEPAGE="https://github.com/rupert/pyls-black
	https://pypi.org/project/pyls-black/"
SRC_URI="https://github.com/rupert/${PN}/archive/v${PV}.tar.gz -> ${P}-gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/python-language-server[${PYTHON_USEDEP}]
	<dev-python/black-21[${PYTHON_USEDEP}]
"

distutils_enable_tests --install pytest
