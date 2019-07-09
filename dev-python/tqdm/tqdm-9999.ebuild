# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1 git-r3

DESCRIPTION="Add a progress meter to your loops in a second."
HOMEPAGE="https://github.com/tqdm/tqdm"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tqdm/tqdm"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
