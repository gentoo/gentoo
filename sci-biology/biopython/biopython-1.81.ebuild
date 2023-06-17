# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Python modules for computational molecular biology"
HOMEPAGE="https://www.biopython.org/ https://pypi.org/project/biopython/"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]
	>=dev-python/reportlab-3.5.13-r1[${PYTHON_USEDEP}]
	dev-python/pydot[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/flex"

DOCS=( {CONTRIB,DEPRECATED,NEWS,README}.rst Doc/. )

python_test() {
	distutils_install_for_testing
	cp -r {Doc,Tests} "${TEST_DIR}"/lib/ || die

	# need to create symlinks for doctests
	mkdir -p "${TEST_DIR}"/lib/Bio/Align || die
	ln -r -s "${S}"/Bio/Align/substitution_matrices \
		"${TEST_DIR}"/lib/Bio/Align/substitution_matrices || die

	cd "${TEST_DIR}"/lib/Tests || die
	rm test_BioSQL_{psycopg2.py,MySQLdb.py,mysql_connector.py} || die
	"${EPYTHON}" run_tests.py --offline --verbose || die
}

python_install_all() {
	# remove files causing ecompressdir to fail
	rm Doc/examples/ls_orchid.gbk.{gz,bz2} || die

	distutils-r1_python_install_all

	dodir /usr/share/${PN}
	cp -r --preserve=mode Scripts Tests "${ED}"/usr/share/${PN} || die
}

pkg_postinst() {
	optfeature_header "For database support you need to install:"
	optfeature "MySQL database support" dev-python/mysqlclient
	optfeature "PostgreSQL database support" dev-python/psycopg:2

	optfeature_header "Some applications need extra packages:"
	optfeature "EMBOSS (The European Molecular Biology Open Software Suite)" sci-biology/emboss
}
