# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit git-r3 distutils-r1

DESCRIPTION="Python utilities for working with DMR"
HOMEPAGE="https://github.com/n0mjs710/dmr_utils"
SRC_URI=""
EGIT_REPO_URI="https://github.com/n0mjs710/dmr_utils.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

PDEPEND="dev-python/bitarray["${PYTHON_USEDEP}"]"
