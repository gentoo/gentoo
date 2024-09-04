# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{10..12} )
PYPI_PN=${PN/-/_}
inherit distutils-r1 pypi

DESCRIPTION="BuildBot common www build tools for packaging releases"
HOMEPAGE="https://buildbot.net/
	https://github.com/buildbot/buildbot
	https://pypi.org/project/buildbot-pkg/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~amd64-linux ~x86-linux"

# No real integration tests for this pkg.
# all tests are related to making releases and final checks for distribution
RESTRICT="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	sed -e "/version/s/=.*$/=\"${PV/_p/.post}\",/" -i setup.py || die
	distutils-r1_src_prepare
}
