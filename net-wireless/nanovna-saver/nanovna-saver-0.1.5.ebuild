# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 )
inherit distutils-r1

DESCRIPTION="tool for reading, displaying and saving data from the NanoVNA"
HOMEPAGE="https://github.com/mihtjel/nanovna-saver"
SRC_URI=""

LICENSE="GPL-3+"
SLOT="0"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mihtjel/nanovna-saver.git"
else
	SRC_URI="https://github.com/mihtjel/nanovna-saver/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND=""
