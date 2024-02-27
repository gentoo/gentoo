# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P="Yapsy-${PV}"
DESCRIPTION="A fat-free DIY Python plugin management toolkit"
HOMEPAGE="
	https://github.com/tibonihoo/yapsy/
	https://pypi.org/project/Yapsy/
"
SRC_URI="mirror://sourceforge/yapsy/${MY_P}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc
distutils_enable_tests unittest

PATCHES=(
	# https://github.com/tibonihoo/yapsy/commit/29286320673f9e853559cf20aeb3456e541afbd4
	"${FILESDIR}/${P}-py312.patch"
)
