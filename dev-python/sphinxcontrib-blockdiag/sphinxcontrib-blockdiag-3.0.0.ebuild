# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A sphinx extension for embedding block diagrams using blockdiag"
HOMEPAGE="
	https://github.com/blockdiag/sphinxcontrib-blockdiag/
	https://pypi.org/project/sphinxcontrib-blockdiag/
"
SRC_URI="
	https://github.com/blockdiag/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/sphinx-2.0[${PYTHON_USEDEP}]
	>=dev-python/blockdiag-1.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/sphinx-testing[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_prepare_all() {
	sed -i -e "/build-base/d" setup.cfg || die
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	rm -rf sphinxcontrib || die
	distutils_write_namespace sphinxcontrib
	eunittest
}
