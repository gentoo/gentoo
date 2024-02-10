# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10,11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 systemd

DESCRIPTION=".onion discovery via SRV DNS lookups for use with postfix"
HOMEPAGE="https://pypi.org/project/onionrouter/ https://github.com/ehloonion/onionrouter/"
if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/ehloonion/onionrouter.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://pypi.io/packages/source/${PN::1}/${PN}/${P}.tar.gz"
fi
IUSE="test"
RESTRICT="!test? ( test )"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="$(python_gen_cond_dep '
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
')"
BDEPEND="$(python_gen_cond_dep '
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
')"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	systemd_dounit "${FILESDIR}/${PN}.service"
	insinto /etc/onionrouter
	doins "${S}/onionrouter/configs/onionrouter.ini"
}
