# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 virtualx xdg

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="https://www.gns3.com/ https://github.com/GNS3/gns3-gui"
SRC_URI="https://github.com/GNS3/gns3-gui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#net-misc/gns3-server version should always match gns3-gui version
RDEPEND="
	>=dev-python/distro-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.9.0[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-1.5.4[${PYTHON_USEDEP}]
	~net-misc/gns3-server-${PV}[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,svg,websockets,widgets,${PYTHON_USEDEP}]
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
