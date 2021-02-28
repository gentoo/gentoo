# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="sqlite?,threads(+)"

inherit distutils-r1

DESCRIPTION="RDF library containing a triple store and parser/serializer"
HOMEPAGE="https://github.com/RDFLib/rdflib https://pypi.org/project/rdflib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="berkdb examples sqlite"

RDEPEND="
	dev-python/isodate[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	berkdb? ( dev-python/bsddb3[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
	)"

distutils_enable_tests nose

python_prepare_all() {
	# these tests require internet access
	sed -i -e '/doctest/d' setup.cfg || die
	rm test/test_sparql_service.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
