# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Package for creating, editing, and reading folder tree diagrams"
HOMEPAGE="
	https://github.com/earnestt1234/seedir/
	https://pypi.org/project/seedir/
"
SRC_URI="
	https://github.com/earnestt1234/seedir/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-python/natsort[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
