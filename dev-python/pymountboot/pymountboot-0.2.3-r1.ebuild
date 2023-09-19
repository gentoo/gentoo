# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python extension module to (re)mount /boot"
HOMEPAGE="https://github.com/projg2/pymountboot/"
SRC_URI="
	https://github.com/projg2/pymountboot/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

DEPEND="
	>=sys-apps/util-linux-2.20
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
