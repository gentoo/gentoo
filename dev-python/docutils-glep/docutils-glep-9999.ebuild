# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )
EGIT_REPO_URI="https://github.com/gentoo/docutils-glep.git"

inherit distutils-r1 git-r3

DESCRIPTION="Gentoo GLEP support for docutils"
HOMEPAGE="https://github.com/gentoo/docutils-glep/"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-python/docutils-0.10[${PYTHON_USEDEP}]"
