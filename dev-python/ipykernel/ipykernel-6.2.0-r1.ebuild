# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="https://github.com/ipython/ipykernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/debugpy-1.0.0[${PYTHON_USEDEP}]
	<dev-python/debugpy-2.0[${PYTHON_USEDEP}]
	>=dev-python/ipython-7.23.1[${PYTHON_USEDEP}]
	<dev-python/ipython-8.0[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.1.0[${PYTHON_USEDEP}]
	<dev-python/traitlets-6.0[${PYTHON_USEDEP}]
	<dev-python/jupyter_client-8.0[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.2[${PYTHON_USEDEP}]
	<www-servers/tornado-7.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-inline-0.1.0[${PYTHON_USEDEP}]
	<dev-python/matplotlib-inline-0.2.0[${PYTHON_USEDEP}]
"
# RDEPEND seems specifically needed in BDEPEND, at least jupyter
# bug #816486
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose_warnings_filters[${PYTHON_USEDEP}]
		dev-python/ipyparallel[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:^TIMEOUT = .*:TIMEOUT = 120:' ipykernel/tests/*.py || die
	distutils-r1_src_prepare
}
