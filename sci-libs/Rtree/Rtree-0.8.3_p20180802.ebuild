# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

EGIT_COMMIT_HASH="c6437a8ae182cb58aef1d0a4465bfc0c6f75b273"

DESCRIPTION="R-Tree spatial index for Python GIS"
HOMEPAGE="https://github.com/Toblerity/rtree"
SRC_URI="https://github.com/Toblerity/rtree/archive/${EGIT_COMMIT_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sci-libs/libspatialindex"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/rtree-${EGIT_COMMIT_HASH}"

python_test() {
	pytest -vv || die
}
