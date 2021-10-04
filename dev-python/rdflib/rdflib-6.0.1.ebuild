# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite?,threads(+)"
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 optfeature

DESCRIPTION="RDF library containing a triple store and parser/serializer"
HOMEPAGE="https://github.com/RDFLib/rdflib https://pypi.org/project/rdflib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"
IUSE="examples sqlite"

RDEPEND="
	dev-python/isodate[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/berkeleydb[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests --install nose

python_prepare_all() {
	# these tests require internet access
	sed -e '/doctest/d' -i setup.cfg || die
	rm test/{test_sparql_service.py,test_graph.py,jsonld/test_onedotone.py} || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	optfeature "support for sys-libs/db (Berkeley DB for MySQL)" dev-python/berkeleydb
}
