# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="A module for working with NMR data in Python"
HOMEPAGE="https://nmrglue.com/"
SRC_URI="https://github.com/jjhelmus/nmrglue/releases/download/v${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests nose
