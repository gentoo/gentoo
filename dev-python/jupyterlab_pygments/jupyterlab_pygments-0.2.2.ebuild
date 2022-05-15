# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=jupyter
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Pygments theme making use of JupyterLab CSS variables"
HOMEPAGE="
	https://pypi.org/project/jupyterlab-pygments/
	https://github.com/jupyterlab/jupyterlab_pygments/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
"
