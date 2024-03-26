# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Tool + pre-commit hook to automatically upgrade syntax for newer Pythons"
HOMEPAGE="
	https://github.com/asottile/pyupgrade/
	https://pypi.org/project/pyupgrade/
"
# no tests in sdist, as of 3.3.2
SRC_URI="
	https://github.com/asottile/pyupgrade/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/tokenize-rt-5.2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
