# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} pypy )

inherit distutils-r1 git-r3

DESCRIPTION="A utility to maintain package.unmask entries up-to-date with masks"
HOMEPAGE="https://github.com/mgorny/diffmask/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-apps/portage[${PYTHON_USEDEP}]"
