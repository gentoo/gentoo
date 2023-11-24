# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=${PN}-release-${PV}
DESCRIPTION="Python API and tools to manipulate OpenDocument files"
HOMEPAGE="
	https://github.com/eea/odfpy/
	https://pypi.org/project/odfpy/
"
SRC_URI="
	https://github.com/eea/odfpy/archive/release-${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="examples"

RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r examples/.
	fi
	distutils-r1_python_install_all
}
