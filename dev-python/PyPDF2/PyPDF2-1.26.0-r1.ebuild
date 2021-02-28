# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Python library to work with pdf files"
HOMEPAGE="https://pypi.org/project/PyPDF2/ https://github.com/mstamy2/PyPDF2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="examples"

PATCHES=( "${FILESDIR}/${P}-py3-tests.patch" )

python_test() {
	"${EPYTHON}" -m unittest Tests.tests || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r Sample_Code/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
