# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )

EGIT_REPO_URI="https://github.com/mgorny/gpyutils.git"
inherit distutils-r1 git-r3

DESCRIPTION="Utitilies for maintaining Python packages"
HOMEPAGE="https://github.com/mgorny/gpyutils/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=app-portage/gentoopm-0.3.2[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
