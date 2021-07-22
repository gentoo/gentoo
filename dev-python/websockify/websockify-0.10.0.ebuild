# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="WebSockets support for any application/server"
HOMEPAGE="https://github.com/novnc/websockify"
SRC_URI="
	https://github.com/novnc/websockify/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/jwcrypto[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# TODO: incompatible with current jwcrypto? (not a regression)
		tests/test_token_plugins.py::JWSTokenTestCase::test_asymmetric_jwe_token_plugin
	)
	epytest ${deselect[@]/#/--deselect }
}

python_install_all() {
	doman docs/${PN}.1
	distutils-r1_python_install_all
}
