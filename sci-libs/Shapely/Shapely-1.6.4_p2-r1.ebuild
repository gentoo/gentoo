# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} )

inherit distutils-r1

DESCRIPTION="Geometric objects, predicates, and operations"
HOMEPAGE="https://pypi.org/project/Shapely/"

MY_PV="$(ver_cut 1-3).post$(ver_cut 5)"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/Toblerity/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/geos-3.3"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}/${P}-test_operations.patch" ) # bug 701624

S="${WORKDIR}/${PN}-${MY_PV}"

python_prepare_all() {
	# fix install path for Cython definition file
	sed -i \
		-e "s|\(data_files.*\)'shapely'|\1'share/shapely'|" \
		setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}/lib" || die
	cp -r "${S}/tests" . || die
	py.test tests || die
}
