# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1 eutils

DESCRIPTION="Python modules for computational molecular biology"
HOMEPAGE="http://www.biopython.org/ https://pypi.python.org/pypi/biopython/"
SRC_URI="http://www.biopython.org/DIST/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/matplotlib[$(python_gen_usedep 'python*')]
	dev-python/networkx[$(python_gen_usedep 'python*')]
	dev-python/numpy[$(python_gen_usedep 'python*')]
	dev-python/rdflib[$(python_gen_usedep 'python*')]
	dev-python/pygraphviz[$(python_gen_usedep 'python2*')]
	dev-python/reportlab[$(python_gen_usedep 'python*')]
	media-gfx/pydot[$(python_gen_usedep 'python2*')]
	"
DEPEND="${RDEPEND}
	sys-devel/flex"

DOCS=( CONTRIB DEPRECATED NEWS README Doc/. )

python_test() {
	distutils_install_for_testing
	cp -r "${S}"/{Doc,Tests} "${TEST_DIR}"/lib/ || die
	cd "${TEST_DIR}"/lib/Tests || die
	rm test_BioSQL_{psycopg2.py,MySQLdb.py,mysql_connector.py} || die
	${PYTHON} run_tests.py --offline --verbose || die
}

python_install_all() {
	distutils-r1_python_install_all

	dodir /usr/share/${PN}
	cp -r --preserve=mode Scripts Tests "${ED%/}"/usr/share/${PN} || die
}

pkg_postinst() {
	elog "For database support you need to install:"
	optfeature "MySQL" dev-python/mysql-python
	optfeature "PostGreSQL" dev-python/psycopg
	elog
	elog "Some applications need extra packages:"
	optfeature "EMBOSS (The European Molecular Biology Open Software Suite)" sci-biology/emboss
}
