# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy )

ES_VERSION="1.7.3"

inherit distutils-r1

DESCRIPTION="official Python low-level client for Elasticsearch"
HOMEPAGE="http://elasticsearch-py.rtfd.org/"
SRC_URI="https://github.com/elasticsearch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		test? ( https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="examples doc test"

RDEPEND=">=dev-python/urllib3-1.8[${PYTHON_USEDEP}]
		<dev-python/urllib3-2.0[${PYTHON_USEDEP}]"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3.1-r1[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
		<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pretty-yaml[${PYTHON_USEDEP}]
		dev-python/nosexcover[${PYTHON_USEDEP}]
		|| ( virtual/jre:1.8 virtual/jre:1.7 ) )"

python_prepare_all() {
	# rename manpage to elasticsearch-py
	sed \
		-e "s@('index', 'elasticsearch'@('index', 'elasticsearch-py'@g" \
		-i docs/conf.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	ES="${WORKDIR}/elasticsearch-${ES_VERSION}"
	ES_PORT="25124"
	ES_LOG="${ES}/logs/elasticsearch.log"
	PID="${ES}/elasticsearch.pid"

	# run Elasticsearch instance on custom port
	sed -i "s/#http.port: 9200/http.port: ${ES_PORT}/g; \
	s/#cluster.name: elasticsearch/cluster.name: gentoo-es-py-test/g" \
	${ES}/config/elasticsearch.yml

	# Elasticsearch 1.6+ needs to set path.repo
	echo "path.repo: /" >> ${ES}/config/elasticsearch.yml

	# start local instance of elasticsearch
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
	esetup.py test

	pkill -F ${PID}
}

python_compile_all() {
	cd docs || die
	emake man $(usex doc html "")
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( example/. )
	doman docs/_build/man/*
	distutils-r1_python_install_all
}
