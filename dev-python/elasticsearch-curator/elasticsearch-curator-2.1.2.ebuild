# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/elasticsearch-curator/elasticsearch-curator-2.1.2.ebuild,v 1.1 2015/02/17 14:13:27 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

MY_PN="curator"
ES_VERSION="1.4.2"

inherit distutils-r1

DESCRIPTION="Tending time-series indices in Elasticsearch"
HOMEPAGE="https://github.com/elasticsearch/curator"
SRC_URI="https://github.com/elasticsearch/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="
	>=dev-python/elasticsearch-py-1.0.0[${PYTHON_USEDEP}]
	<dev-python/elasticsearch-py-2.0.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		virtual/jre:1.7
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/nosexcover[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	ES="${WORKDIR}/elasticsearch-${ES_VERSION}"
	ES_PORT="25123"
	ES_LOG="${ES}/logs/elasticsearch.log"
	PID="${ES}/elasticsearch.pid"

	# run Elasticsearch instance on custom port
	sed -i "s/#http.port: 9200/http.port: ${ES_PORT}/g" ${ES}/config/elasticsearch.yml
	${ES}/bin/elasticsearch -d -p ${PID}

	for i in `seq 10`; do
		grep -q "started" ${ES_LOG} 2> /dev/null
		if [ $? -eq 0 ]; then
			einfo "Elasticsearch started"
			eend 0
			break
		elif grep -q 'BindException\[Address already in use\]' "${ES_LOG}" 2>/dev/null; then
			eend 1
			eerror "Elasticsearch already running"
			die "Cannot start Elasticsearch for tests"
		else
			einfo "Waiting for Elasticsearch"
			eend 1
			sleep 2
			continue
		fi
	done

	export TEST_ES_SERVER="localhost:${ES_PORT}"
	esetup.py test || die "Tests failed on ${EPYTHON}"

	pkill -F ${PID}
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
