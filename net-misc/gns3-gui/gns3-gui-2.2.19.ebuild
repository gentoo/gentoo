# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 desktop xdg

DESCRIPTION="Graphical Network Simulator"
HOMEPAGE="https://www.gns3.com/ https://github.com/GNS3/gns3-gui"
SRC_URI="https://github.com/GNS3/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#net-misc/gns3-server version should always match gns3-gui version
RDEPEND="
	>=dev-python/distro-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.7.0[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-0.14.4[${PYTHON_USEDEP}]
	~net-misc/gns3-server-${PV}[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,svg,websockets,widgets,${PYTHON_USEDEP}]
"

src_prepare() {
	default

	# newer python packages are fine
	sed -i -e 's/[<>=].*//' requirements.txt || die
}

python_install_all() {
	distutils-r1_python_install_all

	doicon "resources/images/gns3.ico"
	make_desktop_entry "gns3" "GNS3" "gns3.ico" "Utility"
}
