# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="A utility to maintain package.unmask entries up-to-date with masks"
HOMEPAGE="https://github.com/projg2/diffmask/"
SRC_URI="https://github.com/projg2/diffmask/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips ~x86"

RDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
"
