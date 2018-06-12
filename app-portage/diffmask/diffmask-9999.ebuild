# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1 git-r3

DESCRIPTION="A utility to maintain package.unmask entries up-to-date with masks"
HOMEPAGE="https://github.com/mgorny/diffmask/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	|| (
		sys-apps/portage[${PYTHON_USEDEP}]
		sys-apps/portage-mgorny[${PYTHON_USEDEP}]
	)"
