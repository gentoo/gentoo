# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
EGIT_REPO_URI="https://github.com/Robpol86/${PN}.git"
inherit distutils-r1 git-r3

DESCRIPTION="Generate simple tables in terminals from a nested list of strings"

HOMEPAGE="https://robpol86.github.io/terminaltables"
SRC_URI=""
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
