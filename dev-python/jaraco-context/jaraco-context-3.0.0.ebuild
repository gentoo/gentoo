# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# upstream uses bad template
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Context managers by jaraco"
HOMEPAGE="https://github.com/jaraco/jaraco.context"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm arm64 ~ia64 ~ppc ~ppc64 ~x86"

RDEPEND="
	>=dev-python/namespace-jaraco-2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-useless-deps.patch
)

python_prepare_all() {
	# used only for apt support that's irrelevant to Gentoo
	sed -i -e '/jaraco\.apt/d' -e '/yg\.lockfile/d' setup.cfg || die
	# pytest plugins
	sed -i -e 's:--flake8 --black --cov::' pytest.ini || die
	distutils-r1_python_prepare_all
}

python_install() {
	rm "${BUILD_DIR}"/lib/jaraco/__init__.py || die
	distutils-r1_python_install
}
