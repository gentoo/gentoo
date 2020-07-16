# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Jupyter kernel for octave"
HOMEPAGE="https://github.com/Calysto/octave_kernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/metakernel[${PYTHON_USEDEP}]
	sci-mathematics/octave
"
DEPEND="${RDEPEND}"
