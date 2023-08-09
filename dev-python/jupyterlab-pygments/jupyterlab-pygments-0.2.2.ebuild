# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=jupyter
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Pygments theme making use of JupyterLab CSS variables"
HOMEPAGE="
	https://pypi.org/project/jupyterlab-pygments/
	https://github.com/jupyterlab/jupyterlab_pygments/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
"
