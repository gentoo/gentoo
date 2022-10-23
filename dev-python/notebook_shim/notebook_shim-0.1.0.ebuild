# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=jupyter
inherit distutils-r1

DESCRIPTION="A shim layer for notebook traits and config"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/jupyter_server-1.8[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/jupyter_packaging-0.9[${PYTHON_USEDEP}]
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
