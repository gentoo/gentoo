# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Execute the first function that matches the given arguments"
HOMEPAGE="
	https://github.com/kalekundert/signature_dispatch/
	https://pypi.org/project/signature-dispatch/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

RDEPEND="
	dev-python/typeguard[${PYTHON_USEDEP}]
"

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
