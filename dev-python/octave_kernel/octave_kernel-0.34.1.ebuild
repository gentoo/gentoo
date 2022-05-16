# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 virtualx

DESCRIPTION="Jupyter kernel for octave"
HOMEPAGE="
	https://github.com/Calysto/octave_kernel/
	https://pypi.org/project/octave-kernel/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/metakernel-0.24.0[${PYTHON_USEDEP}]
	sci-mathematics/octave"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/jupyter_kernel_test[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests --install unittest

python_test() {
	distutils_install_for_testing --via-venv
	virtx eunittest
}
