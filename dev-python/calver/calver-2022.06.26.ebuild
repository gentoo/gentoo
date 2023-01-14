# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Setuptools extension for CalVer package versions"
HOMEPAGE="
	https://github.com/di/calver/
	https://pypi.org/project/calver/
"
SRC_URI="
	https://github.com/di/calver/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
