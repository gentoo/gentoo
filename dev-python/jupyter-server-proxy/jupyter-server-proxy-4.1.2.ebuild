# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="Jupyter notebook server extension to proxy web services"
HOMEPAGE="https://github.com/jupyterhub/jupyter-server-proxy"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Connection refused, even without network-sandbox
RESTRICT="test"

RDEPEND="
	dev-python/aiohttp[${PYTHON_USEDEP}]
	>=dev-python/jupyter-server-1.0[${PYTHON_USEDEP}]
	>=dev-python/simpervisor-1.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-5.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/hatch-jupyter-builder-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab-4.0.6[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed \
		-e "/--cov.*,/d" \
		-e "/--no-cov.*,/d" \
		-e "/--html.*,/d" \
		-i pyproject.toml || die
	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
