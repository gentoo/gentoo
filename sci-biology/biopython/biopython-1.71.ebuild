# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1 eutils

DESCRIPTION="Python modules for computational molecular biology"
HOMEPAGE="https://www.biopython.org/ https://pypi.org/project/biopython/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/pydot[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/flex"

DOCS=( CONTRIB DEPRECATED NEWS README Doc/. )

python_test() {
	distutils_install_for_testing
	cp -r "${S}"/{Doc,Tests} "${TEST_DIR}"/lib/ || die
	cd "${TEST_DIR}"/lib/Tests || die
	rm test_BioSQL_{psycopg2.py,MySQLdb.py,mysql_connector.py} || die
	"${EPYTHON}" run_tests.py --offline --verbose || die
}

python_install_all() {
	# remove files causing ecompressdir to fail
	rm Doc/examples/ls_orchid.gbk.bz2 || die

	distutils-r1_python_install_all

	dodir /usr/share/${PN}
	cp -r --preserve=mode Scripts Tests "${ED}"/usr/share/${PN} || die
}

pkg_postinst() {
	elog "For database support you need to install:"
	optfeature "MySQL" dev-python/mysql-python
	optfeature "PostGreSQL" dev-python/psycopg

	elog "Some applications need extra packages:"
	optfeature "EMBOSS (The European Molecular Biology Open Software Suite)" sci-biology/emboss
}
