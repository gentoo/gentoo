# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

# this version is untagged in github, and pypi doesn't has tests
COMMIT=7b2091f77741fa1d94251979bc4a4f2676b4d2d1

DESCRIPTION="Python package to handle polygonal shapes in 2D"
HOMEPAGE="https://www.j-raedler.de/projects/polygon/
	https://github.com/jraedler/Polygon3"
SRC_URI="
	https://github.com/jraedler/Polygon3/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
S="${WORKDIR}/Polygon3-${COMMIT}"

LICENSE="LGPL-2"
SLOT="3"
KEYWORDS="amd64 ppc x86"
IUSE="examples"

DOCS=( doc/{Polygon.txt,Polygon.pdf} )

src_prepare() {
	if use examples; then
		mkdir examples || die
		mv doc/{Examples.py,testpoly.gpf} examples || die
	fi

	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" test/Test.py -v || die "Tests failed under ${EPYTHON}"
}

src_install() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_src_install
}
