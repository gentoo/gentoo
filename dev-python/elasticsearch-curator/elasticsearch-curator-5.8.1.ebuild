# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

MY_PN="curator"
ES_VERSION="7.3.2"

inherit distutils-r1

DESCRIPTION="Tending time-series indices in Elasticsearch"
HOMEPAGE="https://github.com/elasticsearch/curator"
SRC_URI="https://github.com/elasticsearch/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# tests fail in chroot
# https://github.com/elastic/elasticsearch/issues/12018
RESTRICT="test"
IUSE="doc test"

# vulnerable pyyaml
# https://github.com/elastic/curator/issues/1415
RDEPEND="
	>=dev-python/elasticsearch-py-7.0.4[${PYTHON_USEDEP}]
	<dev-python/elasticsearch-py-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/click-6.7[${PYTHON_USEDEP}]
	<dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/certifi-2019.9.11[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.24.2[${PYTHON_USEDEP}]
	<dev-python/urllib3-1.25[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.9.3[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	dev-python/sphinx
	~dev-python/pyyaml-3.13[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		virtual/jre
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	# avoid downloading from net
	sed -e '/^intersphinx_mapping/,+3d' -i docs/conf.py || die

	# requests_aws4auth not in portage
	sed -e '/boto3/d' \
		-e '/requests_aws4auth/d' \
		-e '/tests_require/s/, "coverage", "nosexcover"//g' \
		-i setup.cfg setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C docs -j1 man $(usex doc html "")
}

# running tests in non-chroot environments:
# FEATURES="test -usersandbox" emerge dev-python/elasticsearch-curator
python_test_all() {
	# starts two ES instances (local,remote) and runs the tests
	# https://github.com/elastic/curator/blob/master/travis-run.sh
	local ES_INSTANCES="local remote"
	local ES_PATH="${WORKDIR}/elasticsearch-${ES_VERSION}"

	declare -A ES_PORT
	ES_PORT[local]=9200
	ES_PORT[remote]=9201

	local i transport
	declare -A ES_CONFIG_DIR ES_CONFIG_PATH ES_INSTANCE ES_LOG ES_PID
	for i in ${ES_INSTANCES}; do
		ES_CONFIG_DIR[$i]="${ES_PATH}/$i"
		ES_CONFIG_PATH[$i]="${ES_CONFIG_DIR[$i]}/elasticsearch.yml"
		ES_PID[$i]="${ES_PATH}/$i.pid"
		ES_LOG[$i]="${ES_PATH}/logs/$i.log"
	done

	# configure ES instances
	for i in ${ES_INSTANCES}; do
		mkdir -p "${ES_CONFIG_DIR[$i]}" || die
		cp ${ES_PATH}/config/{jvm.options,log4j2.properties} "${ES_CONFIG_DIR[$i]}"/ || die
		echo 'network.host: 127.0.0.1' > "${ES_CONFIG_PATH[$i]}" || die
		echo "http.port: ${ES_PORT[$i]}" >> "${ES_CONFIG_PATH[$i]}" || die
		echo "cluster.name: $i" >> "${ES_CONFIG_PATH[$i]}" || die
		echo "node.name: $i" >> "${ES_CONFIG_PATH[$i]}" || die
		echo 'node.max_local_storage_nodes: 2' >> "${ES_CONFIG_PATH[$i]}" || die
		transport=$((${ES_PORT[$i]}+100))
		echo "transport.port: ${transport}" >> "${ES_CONFIG_PATH[$i]}" || die
		echo "discovery.seed_hosts: [\"localhost:${transport}\"]" >> "${ES_CONFIG_PATH[$i]}" || die
		echo "discovery.type: single-node" >> "${ES_CONFIG_PATH[$i]}" || die
	done

	echo 'path.repo: /' >> "${ES_CONFIG_PATH[local]}" || die
	echo "reindex.remote.whitelist: localhost:${ES_PORT[remote]}" >> "${ES_CONFIG_PATH[local]}" || die

	# start ES instances
	for i in ${ES_INSTANCES}; do
		ES_PATH_CONF=${ES_CONFIG_DIR[$i]} "${ES_PATH}/bin/elasticsearch" -d -p "${ES_PID[$i]}" || die

		local j
		local es_started=0
		for j in {1..30}; do
			grep -q "started" "${ES_LOG[$i]}" 2> /dev/null
			if [[ $? -eq 0 ]]; then
				einfo "Elasticsearch $i started"
				es_started=1
				eend 0
				break
			elif grep -q 'BindException\[Address already in use\]' "${ES_LOG[$i]}" 2>/dev/null; then
				eend 1
				eerror "Elasticsearch $i already running"
				die "Cannot start Elasticsearch $i for tests"
			else
				einfo "Waiting for Elasticsearch $i"
				eend 1
				sleep 2
				continue
			fi
		done

		[[ $es_started -eq 0 ]] && die "Elasticsearch failed to start"
	done

	export TEST_ES_SERVER="localhost:${ES_PORT[local]}"
	export REMOTE_ES_SERVER="localhost:${ES_PORT[remote]}"

	# run tests
	nosetests -v || die

	for i in ${ES_INSTANCES}; do
		pkill -F ${ES_PID[$i]}
	done
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	doman docs/_build/man/*
	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn ""
	ewarn "For Python 3 support information please read: http://click.pocoo.org/latest/python3/"
	ewarn ""
	ewarn "Example usage on Python 3:"
	ewarn "export LC_ALL=en_US.UTF-8"
	ewarn "export LANG=en_US.UTF-8"
	ewarn "curator ..."
}
