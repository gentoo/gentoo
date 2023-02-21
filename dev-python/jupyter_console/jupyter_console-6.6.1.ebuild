# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A terminal-based console frontend for Jupyter kernels"
HOMEPAGE="https://jupyter.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/ipykernel-6.14[${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-3.0.30[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-17[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.4[${PYTHON_USEDEP}]
"
# util-linux provides script(1)
BDEPEND="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		sys-apps/util-linux
	)
"

distutils_enable_tests pytest
