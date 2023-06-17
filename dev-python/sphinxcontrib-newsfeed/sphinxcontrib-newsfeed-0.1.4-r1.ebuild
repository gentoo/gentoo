# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="News Feed extension for Sphinx"
HOMEPAGE="
	https://github.com/prometheusresearch/sphinxcontrib-newsfeed/
	https://pypi.org/project/sphinxcontrib-newsfeed/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		docinto examples
		dodoc -r demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
