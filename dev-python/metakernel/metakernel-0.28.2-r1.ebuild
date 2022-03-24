# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Metakernel for Jupyter"
HOMEPAGE="https://github.com/Calysto/metakernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${PN}-0.25.0-disable-brittle-tests.patch )

python_prepare_all() {
	# cannot import name 'MetaKernelPython' from 'metakernel_python' (unknown location)
	rm generate_help.py || die
	distutils-r1_python_prepare_all
}
