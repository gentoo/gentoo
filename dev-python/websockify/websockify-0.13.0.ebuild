# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="WebSockets support for any application/server"
HOMEPAGE="
	https://github.com/novnc/websockify/
	https://pypi.org/project/websockify/
"
SRC_URI="
	https://github.com/novnc/websockify/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	dev-python/jwcrypto[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/redis[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/websockify-0.13.0-fix-test-with-jwcrypto-1.5.7.patch
)

python_install_all() {
	doman docs/${PN}.1
	distutils-r1_python_install_all
}
