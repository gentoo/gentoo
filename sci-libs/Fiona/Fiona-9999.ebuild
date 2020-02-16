# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 git-r3

DESCRIPTION="OGR's neat, nimble, no-nonsense API"
HOMEPAGE="https://pypi.org/project/Fiona/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Toblerity/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=sci-libs/gdal-1.8
	dev-python/click[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/scriptname.patch )

python_test() {
	esetup.py test
}
