# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

MY_PN="curator"
ES_VERSION="2.4.0"

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
	>=dev-python/elasticsearch-py-2.3.0[${PYTHON_USEDEP}]
	<dev-python/elasticsearch-py-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/click-3.3[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.8.3[${PYTHON_USEDEP}]
	dev-python/voluptuous[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		|| ( virtual/jre:1.8 virtual/jre:1.7 )
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/nosexcover[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	ES="${WORKDIR}/elasticsearch-${ES_VERSION}"
	ES_PORT="25123"
	ES_LOG="${ES}/logs/elasticsearch.log"
	PID="${ES}/elasticsearch.pid"

	# run Elasticsearch instance on custom port
	sed -i "s/# http.port: 9200/http.port: ${ES_PORT}/g; \
		s/# cluster.name: my-application/cluster.name: gentoo-es-curator-test/g" \
		${ES}/config/elasticsearch.yml || die

	# Elasticsearch 1.6+ needs to set path.repo
	grep -q "^path.repo" "${ES}/config/elasticsearch.yml"
	if [ $? -ne 0 ]; then
		echo "path.repo: /" >> "${ES}/config/elasticsearch.yml" || die
	fi

	# start local instance of elasticsearch
	${ES}/bin/elasticsearch -d -p ${PID} || die

	local i
	for i in {1..10}; do
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

python_prepare_all() {
	# avoid downloading from net
	sed -e '/^intersphinx_mapping/,+3d' -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	cd docs || die
	emake man $(usex doc html "")
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	doman docs/_build/man/*
	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn ""
	ewarn "For Python 3 support information please read: http://click.pocoo.org/3/python3/"
	ewarn ""
	ewarn "Example usage on Python 3:"
	ewarn "export LC_ALL=en_US.UTF-8"
	ewarn "export LANG=en_US.UTF-8"
	ewarn "curator ..."
}
