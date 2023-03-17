# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Jupyter notebook server extension to proxy web services"
HOMEPAGE="https://github.com/jupyterhub/jupyter-server-proxy"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
# The GitHub tarball includes the tests, but does not have the js stuff we need

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/aiohttp[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-1.0[${PYTHON_USEDEP}]
	>=dev-python/simpervisor-0.4[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/jupyter_packaging[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
