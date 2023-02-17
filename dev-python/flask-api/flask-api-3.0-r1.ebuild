# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Browsable web APIs for Flask"
HOMEPAGE="
	https://github.com/flask-api/flask-api/
	https://pypi.org/project/Flask-API/
"
# pypi mirror don't have docs folder
SRC_URI="
	https://github.com/flask-api/flask-api/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_install_all() {
	local DOCS=( docs/about/release-notes.md docs/api-guide/* docs/index.md )
	distutils-r1_python_install_all
}
