# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 )
inherit git-r3 distutils-r1

DESCRIPTION="tool for reading, displaying and saving data from the NanoVNA"
HOMEPAGE="https://github.com/mihtjel/nanovna-saver"
SRC_URI=""

LICENSE="GPL-3+"
SLOT="0"
EGIT_REPO_URI="https://github.com/mihtjel/nanovna-saver.git"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND=""

src_prepare() {
	sed -i 's#==5.11.2##' setup.py
	default
}
