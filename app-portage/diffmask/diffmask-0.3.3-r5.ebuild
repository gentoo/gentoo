# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A utility to maintain package.unmask entries up-to-date with masks"
HOMEPAGE="https://github.com/mgorny/diffmask/"
SRC_URI="https://github.com/mgorny/diffmask/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
"
