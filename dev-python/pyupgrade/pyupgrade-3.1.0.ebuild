# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Tool + pre-commit hook to automatically upgrade syntax for newer Pythons"
HOMEPAGE="
	https://github.com/asottile/pyupgrade/
	https://pypi.org/project/pyupgrade/
"
SRC_URI="
	https://github.com/asottile/pyupgrade/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/tokenize-rt[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
