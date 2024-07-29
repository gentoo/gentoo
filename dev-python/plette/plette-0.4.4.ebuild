# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Structured Pipfile and Pipfile.lock models"
HOMEPAGE="
	https://github.com/sarugaku/plette/
	https://pypi.org/project/plette/
"
# pypi tarballs are missing test data
SRC_URI="
	https://github.com/sarugaku/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	dev-python/cerberus[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
