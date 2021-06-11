# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Pygments theme making use of JupyterLab CSS variables"
HOMEPAGE="https://github.com/jupyterlab/jupyterlab_pygments"
SRC_URI="https://github.com/jupyterlab/jupyterlab_pygments/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]"
