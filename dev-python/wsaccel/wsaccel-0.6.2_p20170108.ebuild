# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

COMMIT="0fbd074c257c51b73de05b25ccb6488801320a32"
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Accelerator for ws4py, autobahn and tornado"
HOMEPAGE="https://pypi.org/project/wsaccel/ https://github.com/methane/wsaccel"
SRC_URI="https://github.com/methane/wsaccel/archive/${COMMIT}.zip -> ${P}.zip"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${PN}-${COMMIT}"

python_test() {
	py.test -v || die
}
