# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_PN=SPARQLWrapper
DESCRIPTION="Wrapper around a SPARQL service"
HOMEPAGE="https://pypi.org/project/SPARQLWrapper/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
# the vast majority of tests access random Internet sites
RESTRICT="test"

RDEPEND=">=dev-python/rdflib-4[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	# disable sys.path hack
	sed -i -e '/^# prefer local/,/^# end of hack/d' test/*.py || die

	# urllib2
	rm test/wrapper_test.py || die
	# connection timeout
	rm test/fuseki2__v3_6_0__agrovoc__test.py || die
	# HTTP 401
	rm test/graphdbEnterprise__v8_9_0__rs__test.py || die
	# returns some HTML page
	rm test/stardog__lindas__test.py || die

	# require rdflib-jsonld, apparently
	sed -i -e 's:test.*JSONLD:_&:' \
		test/*.py || die
	# some plugin error, probably the same
	sed -e 's:testConstruct.*JSON:_&:' \
		-e 's:testDescribe.*JSON:_&:' \
		-i test/fuseki2__v3_8_0__stw__test.py || die

	distutils-r1_src_prepare
}

src_test() {
	cd test || die
	2to3 -n -w --no-diffs *.py || die
	distutils-r1_src_test
}
