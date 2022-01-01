# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/python-xmp-toolkit/${PN}.git"
else
	SRC_URI="https://github.com/python-xmp-toolkit/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Library for working with XMP metadata"
HOMEPAGE="https://github.com/python-xmp-toolkit/python-xmp-toolkit/ https://pypi.org/project/python-xmp-toolkit/"

LICENSE="BSD"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		media-libs/exempi )"
RDEPEND="dev-python/pytz[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${P}-test.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}
