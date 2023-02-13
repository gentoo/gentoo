# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 xdg-utils

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
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]"
BDEPEND=""

distutils_enable_tests pytest

src_prepare() {
	sed -i -e "s/48.png/48/" \
		-e "s/TerminalOptions=/#TerminalOptions=/" \
		-e "s/Path=/#Path=/" NanoVNASaver.desktop || die
	sed -i "/nanovnasaver/d" setup.py || die
	eapply_user
}

python_install() {
	distutils-r1_python_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
