# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python S-expression emulation using tuple-like objects"
HOMEPAGE="
	https://pypi.org/project/etuples/
	https://github.com/pythological/etuples/
"
# tests not in sdist, as of 0.3.9
SRC_URI="
	https://github.com/pythological/etuples/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~riscv x86"

RDEPEND="
	dev-python/cons[${PYTHON_USEDEP}]
	dev-python/multipledispatch[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
