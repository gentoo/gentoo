# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Jupyter Notebook as a Jupyter Server Extension"
HOMEPAGE="https://jupyter.org/"
SRC_URI="https://github.com/jupyterlab/nbclassic/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jupyter_server[${PYTHON_USEDEP}]
	<dev-python/notebook-7[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Defining 'pytest_plugins' in a non-top-level conftest is no longer supported:
	mv ${PN}/conftest.py . || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	# move /usr/etc stuff to /etc
	mv "${ED}/usr/etc" "${ED}/etc" || die
}
