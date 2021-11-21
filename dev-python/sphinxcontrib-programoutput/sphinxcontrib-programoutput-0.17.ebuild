# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Extension to sphinx to include program output"
HOMEPAGE="
	https://github.com/NextThought/sphinxcontrib-programoutput/
	https://pypi.org/project/sphinxcontrib-programoutput/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest
distutils_enable_sphinx doc

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
