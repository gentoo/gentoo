# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_USE_SETUPTOOLS=bdepend
ES_VERSION="7.5.2"

inherit distutils-r1

MY_PN=${PN/-py/}
DESCRIPTION="Official Python low-level client for Elasticsearch"
HOMEPAGE="https://github.com/elastic/elasticsearch-py"
SRC_URI="https://github.com/elasticsearch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${ES_VERSION}-no-jdk-linux-x86_64.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

# tests fail in chroot
# https://github.com/elastic/elasticsearch/issues/12018
RESTRICT="test"

RDEPEND=">=dev-python/urllib3-1.21.1[${PYTHON_USEDEP}]"

DEPEND="test? ( ${RDEPEND}
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pretty-yaml[${PYTHON_USEDEP}]
	virtual/jre:* )"

BDEPEND=">=dev-python/sphinx-1.3.1-r1"

python_prepare_all() {
	sed -e '/coverage/d' \
		-e '/nosexcover/d' \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C docs -j1 man $(usex doc html "")
}

# FEATURES="test -usersandbox" emerge dev-python/elasticsearch-py
python_test() {
	local es="${WORKDIR}/elasticsearch-${ES_VERSION}"
	local es_port="25124"
	local es_instance="gentoo-es-py-test"
	local es_log="${es}/logs/${es_instance}.log"
	local pid="${es}/elasticsearch.pid"
	export JAVA_HOME=$(java-config -g JAVA_HOME)

	# run Elasticsearch instance on custom port
	sed -i "s/#http.port: 9200/http.port: ${es_port}/g; \
		s/#cluster.name: my-application/cluster.name: ${es_instance}/g" \
		"${es}/config/elasticsearch.yml" || die

	# start local instance of elasticsearch
	"${es}"/bin/elasticsearch -d -p "${pid}" -Epath.repo=/ || die

	local i
	local es_started=0
	for i in {1..20}; do
		grep -q "started" ${es_log} 2> /dev/null
		if [[ $? -eq 0 ]]; then
			einfo "Elasticsearch started"
			es_started=1
			eend 0
			break
		elif grep -q 'BindException\[Address already in use\]' "${es_log}" 2>/dev/null; then
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

	[[ $es_started -eq 0 ]] && die "Elasticsearch failed to start"

	export TEST_ES_SERVER="localhost:${es_port}"
	nosetests -v || die

	pkill -F ${pid} || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	use examples && dodoc -r example
	doman docs/_build/man/*
	distutils-r1_python_install_all
}
