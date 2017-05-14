# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

EGIT_REPO_URI="https://github.com/mgorny/gpyutils.git"
inherit distutils-r1 git-r3

DESCRIPTION="Utitilies for maintaining Python packages"
HOMEPAGE="https://github.com/mgorny/gpyutils/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=app-portage/gentoopm-0.2.9[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
