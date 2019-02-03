# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
EGIT_REPO_URI="https://github.com/dbcli/${PN}.git"
inherit distutils-r1 git-r3

DESCRIPTION="Python helpers for common CLI tasks"

HOMEPAGE="http://cli-helpers.rtfd.io/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/backports-csv-1.0[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/terminaltables-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
"
