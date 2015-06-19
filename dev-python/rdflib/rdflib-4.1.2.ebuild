# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rdflib/rdflib-4.1.2.ebuild,v 1.14 2015/06/07 09:55:57 maekke Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="sqlite?"
DISTUTILS_NO_PARALLEL_BUILD=true
# The usual required for tests
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="RDF library containing a triple store and parser/serializer"
HOMEPAGE="https://github.com/RDFLib/rdflib http://pypi.python.org/pypi/rdflib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="berkdb examples mysql redland sqlite test"

RDEPEND="
	dev-python/isodate[${PYTHON_USEDEP}]
	dev-python/html5lib[$(python_gen_usedep 'python2*')]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	berkdb? ( dev-python/bsddb3[${PYTHON_USEDEP}] )
	mysql? ( dev-python/mysql-python[$(python_gen_usedep 'python2*')] )
	redland? ( dev-libs/redland-bindings[python,$(python_gen_usedep 'python2*')] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/sparql-wrapper[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.1-r1[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Upstream manufactured .pyc files which promptly break distutils' src_test
	find -name "*.py[oc~]" -delete || die
	distutils-r1_python_prepare_all
}

python_test() {
	if python_is_python3; then
		pushd "${BUILD_DIR}/src/" > /dev/null
		if [[ "${EPYTHON}" == 'python3.4' ]]; then
			sed -e 's:test_rdfpipe_bytes_vs_str:_&:' \
				-e 's:test_rdfpipe_mdata_open:_&:' \
				-i test/test_issue375.py || die
			sed -e 's:testHTML:_&:' \
				-i test/test_xmlliterals.py || die
		fi
		"${PYTHON}" ./run_tests.py || die "Tests failed under ${EPYTHON}"
		popd > /dev/null
	else
		"${PYTHON}" ./run_tests.py || die "Tests failed under ${EPYTHON}"
	fi
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
