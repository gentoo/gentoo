# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python extension module to (re)mount /boot"
HOMEPAGE="https://github.com/mgorny/pymountboot/"
SRC_URI="
	https://github.com/mgorny/pymountboot/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND=">=sys-apps/util-linux-2.20"
DEPEND="${RDEPEND}"
