# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

DESCRIPTION="Personal shell command keeper and snippets manager"
HOMEPAGE="https://pypi.org/project/keep/ https://github.com/orkohunter/keep"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/terminaltables[${PYTHON_USEDEP}]
"
