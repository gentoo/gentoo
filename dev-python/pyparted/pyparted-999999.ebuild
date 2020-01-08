# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1 git-r3

DESCRIPTION="Python bindings for sys-block/parted"
HOMEPAGE="https://github.com/rhinstaller/pyparted/"
EGIT_REPO_URI="https://github.com/rhinstaller/pyparted/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=sys-block/parted-3.1
	dev-python/decorator[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
RESTRICT="test"
