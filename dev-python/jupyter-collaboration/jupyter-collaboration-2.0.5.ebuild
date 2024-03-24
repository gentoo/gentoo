# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_1{1..2} )

inherit distutils-r1 pypi

DESCRIPTION="JupyterLab Extension enabling Real-Time Collaboration"
HOMEPAGE="https://github.com/jupyterlab/jupyter-collaboration"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
RDEPEND="dev-python/pycrdt-websocket[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab-4[${PYTHON_USEDEP}]
	>=dev-python/jupyter-ydoc-2[${PYTHON_USEDEP}]
	dev-python/jupyter-server-fileid[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/hatch-jupyter-builder[${PYTHON_USEDEP}]
	test? (
		  dev-python/pytest-jupyter[${PYTHON_USEDEP}]
		  dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.5-no-node-for-version.patch"
)

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	# hatchling cannot install into /etc while specifying prefix as /usr
	mv -v "${ED}"{/usr,}/etc || die
}
