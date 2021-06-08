# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A sphinx extension for embedding block diagrams using blockdiag"
HOMEPAGE="https://github.com/blockdiag/sphinxcontrib-blockdiag"
SRC_URI="https://github.com/blockdiag/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

RDEPEND="
	>=dev-python/sphinx-2.0[${PYTHON_USEDEP}]
	>=dev-python/blockdiag-1.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/sphinx-testing[${PYTHON_USEDEP}]
	)"

distutils_enable_tests nose

RDEPEND+="
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i -e /build-base/d setup.cfg || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
