# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

SOLR_PV=4.10.4
DESCRIPTION="Lightweight python wrapper for Apache Solr"
HOMEPAGE="https://pypi.org/project/pysolr/ https://github.com/toastdriven/pysolr/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? ( https://archive.apache.org/dist/lucene/solr/${SOLR_PV}/solr-${SOLR_PV}.tgz )"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/kazoo[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		net-misc/curl
		virtual/jre:*
		$(python_gen_cond_dep '
				dev-python/faulthandler[${PYTHON_USEDEP}]
				dev-python/mock[${PYTHON_USEDEP}]
			' -2)
	)"

src_unpack() {
	unpack "${P}.tar.gz"
}

src_prepare() {
	# utf8 breaks py2.7 for us
	sed -i -e 's/…/.../' run-tests.py || die

	distutils-r1_src_prepare
}

python_configure_all() {
	if use test; then
		mkdir -p "${HOME}/download-cache" || die
		cp "${DISTDIR}/solr-${SOLR_PV}.tgz" "${HOME}/download-cache" || die
	fi
}

python_test() {
	"${EPYTHON}" run-tests.py -v || die "Tests fail with ${EPYTHON}"
}
