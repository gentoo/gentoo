# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
# entry_points is used
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

SRC_URI="https://github.com/novnc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="WebSockets support for any application/server"
HOMEPAGE="https://github.com/novnc/websockify"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/jwcrypto[${PYTHON_USEDEP}] )"

# Backport a patch removing the need for mox3
PATCHES=( "${FILESDIR}/${P}-mock-tests.patch" )

distutils_enable_tests nose

python_install_all() {
	doman docs/${PN}.1
	distutils-r1_python_install_all
}
