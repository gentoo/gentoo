# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="A utility to maintain package.unmask entries up-to-date with masks"
HOMEPAGE="https://github.com/mgorny/diffmask/"
SRC_URI="https://github.com/mgorny/diffmask/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	|| (
		sys-apps/portage[${PYTHON_USEDEP}]
		sys-apps/portage-mgorny[${PYTHON_USEDEP}]
	)"
