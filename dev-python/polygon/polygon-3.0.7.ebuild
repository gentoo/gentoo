# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python package to handle polygonal shapes in 2D"
HOMEPAGE="https://www.j-raedler.de/projects/polygon/"
SRC_URI="https://www.bitbucket.org/jraedler/${PN}3/downloads/Polygon3-${PV}.zip"

LICENSE="LGPL-2"
SLOT="3"
IUSE="examples"
KEYWORDS="amd64 ppc x86"

DEPEND="app-arch/unzip"

S=${WORKDIR}/Polygon3-${PV}

DOCS=( doc/{Polygon.txt,Polygon.pdf} )

python_prepare_all() {
	if use examples; then
		mkdir examples || die
		mv doc/{Examples.py,testpoly.gpf} examples || die
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" test/Test.py -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
