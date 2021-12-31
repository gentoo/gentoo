# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A module for working with NMR data in Python"
HOMEPAGE="http://nmrglue.com/"
SRC_URI="https://github.com/jjhelmus/nmrglue/releases/download/v${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}"/${P}-nohyper.patch )

python_test() {
	nosetests --verbosity=3 || die
}
