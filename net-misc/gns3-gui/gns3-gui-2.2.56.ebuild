# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 virtualx xdg

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="https://www.gns3.com https://github.com/GNS3/gns3-gui"
SRC_URI="https://github.com/GNS3/gns3-gui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

#net-misc/gns3-server version should always match gns3-gui version
RDEPEND="
	>=dev-python/distro-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.23.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-6.1.0[${PYTHON_USEDEP}]
	>=dev-python/truststore-0.10.0[${PYTHON_USEDEP}]
	~net-misc/gns3-server-${PV}[${PYTHON_USEDEP}]
	dev-python/pyqt6[gui,network,svg,websockets,widgets,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/pyqt6[testlib] )
"

distutils_enable_tests pytest

src_prepare() {
	default

	# newer python packages are fine
	sed -i -e 's/[<>=].*//' requirements.txt || die
}

src_test() {
	virtx distutils-r1_src_test
}
