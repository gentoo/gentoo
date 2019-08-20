# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7} )

EGIT_REPO_URI="https://github.com/bgloyer/pacvis.git"
inherit distutils-r1 git-r3

DESCRIPTION="Displays dependency graphs of packages"
HOMEPAGE="https://github.com/bgloyer/pacvis.git"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="www-servers/tornado[${PYTHON_USEDEP}]"
