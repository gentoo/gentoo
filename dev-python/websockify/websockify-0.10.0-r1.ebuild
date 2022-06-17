# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="WebSockets support for any application/server"
HOMEPAGE="https://github.com/novnc/websockify"
SRC_URI="
	https://github.com/novnc/websockify/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/jwcrypto[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${P}-fix-jwcrypto-1.3.patch"
)

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO: incompatible with current jwcrypto? (not a regression)
	tests/test_token_plugins.py::JWSTokenTestCase::test_asymmetric_jwe_token_plugin
)

python_install_all() {
	doman docs/${PN}.1
	distutils-r1_python_install_all
}
