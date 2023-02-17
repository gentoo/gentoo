# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Official Elasticsearch client library for Python"
HOMEPAGE="
	https://ela.st/es-python
	https://github.com/elastic/elasticsearch-py
	https://pypi.org/project/elasticsearch/
"
# Use bundled jdk for the test elasticsearch as there is no convenient way to ensure system jdk17 is used
SRC_URI="
	https://github.com/elastic/elasticsearch-py/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	test? (
		  amd64? ( https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${PV}-linux-x86_64.tar.gz )
	)
"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~x86"

RESTRICT="
	!amd64? ( test )
	!test? ( test )
"

RDEPEND="
	>=dev-python/aiohttp-3[${PYTHON_USEDEP}] <dev-python/aiohttp-4[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.21.1[${PYTHON_USEDEP}] <dev-python/urllib3-2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		  ${RDEPEND}
		  dev-python/mapbox-vector-tile[${PYTHON_USEDEP}]
		  dev-python/multidict[${PYTHON_USEDEP}]
		  dev-python/numpy[${PYTHON_USEDEP}]
		  dev-python/pandas[${PYTHON_USEDEP}]
		  dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		  dev-python/python-dateutil[${PYTHON_USEDEP}]
		  >=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
		  >=dev-python/requests-2[${PYTHON_USEDEP}] <dev-python/requests-3[${PYTHON_USEDEP}]
		  dev-python/unasync[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# REST api tests are a black hole for effort. It downloads the tests so its an ever moving target
	# It also requires effort to blacklist tests for apis which are license restricted.
	"test_elasticsearch/test_server/test_rest_api_spec.py"
	# Counting deprecation warnings from python is bound to fail even if all are fixed in this package
	# Not worth it
	"test_elasticsearch/test_client/test_deprecated_options.py"
	# Requires a network connection. I could've used PROPERTIES=test_network,
	# but it would complicate the RESTRICT statement with the elasticsearch binary being limited to amd64 and arm64
	"test_elasticsearch/test_connection.py"
	"test_elasticsearch/test_async/test_connection.py"
)

EPYTEST_DESELECT=(
	# Not motivated to figure these out, upstream CI doesnt test with the daemon running so it hasnt been caught there

	## elasticsearch.exceptions.RequestError: RequestError(400, 'illegal_argument_exception',
	## 'index [.ds-ilm-history-5-2023.02.17-000001] is the write index for data stream [ilm-history-5] and cannot be deleted')
	"test_elasticsearch/test_server/test_clients.py::TestUnicode::test_indices_analyze"
	## elasticsearch.exceptions.RequestError: RequestError(400, 'illegal_argument_exception',
	## 'unable to remove composable templates [.deprecation-indexing-template] as they are in use by a data streams [.logs-deprecation.elasticsearch-default]')
	"test_elasticsearch/test_async/test_server/test_helpers.py::TestAsyncDataStreamReindex::test_reindex_index_datastream[create]"
	## elasticsearch.exceptions.NotFoundError: NotFoundError(404, 'index_template_missing_exception',
	## 'index_template [.deprecation-indexing-template] missing')
	"test_elasticsearch/test_async/test_server/test_helpers.py::TestScan::test_scan_auth_kwargs_forwarded"
	## elasticsearch.exceptions.RequestError: RequestError(400, 'illegal_argument_exception',
	## 'Cannot delete policy [.deprecation-indexing-ilm-policy]. It is in use by one or more indices:
	## [.ds-.logs-deprecation.elasticsearch-default-2023.02.17-000001]')
	"test_elasticsearch/test_async/test_server/test_helpers.py::TestParentChildReindex::test_children_are_reindexed_correctly"
	## elasticsearch.exceptions.RequestError: RequestError(400, 'illegal_argument_exception',
	## 'Cannot delete policy [.deprecation-indexing-ilm-policy]. It is in use by one or more indices:
	## [.ds-.logs-deprecation.elasticsearch-default-2023.02.17-000001]')
	"test_elasticsearch/test_async/test_server/test_helpers.py::TestAsyncDataStreamReindex::test_reindex_index_datastream_op_type_index"
)

distutils_enable_sphinx docs/sphinx dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_prepare() {
	# Replace added pytest options with setting asyncio_mode to auto.
	# Test suite hasnt set asyncio parameters so its needed here.
	sed -i '/[tool:pytest]/,/^$/ { s/addopts.*/asyncio_mode = auto/ }' setup.cfg || die

	# Catches warnings from other tests causing the assertation to fail unduly
	sed -i '/TestStreamingBulk/,/class/ { /test_all_documents_get_inserted/,/async def/ { /assert w == \[\]/ d } }' \
		test_elasticsearch/test_async/test_server/test_helpers.py || die

	default
}

src_test() {
	local es_port="25124"

	export ES_DIR="${WORKDIR}/elasticsearch-${PV}"
	export ES_INSTANCE="gentoo-es-py-test"
	export ELASTIC_PASSWORD="changeme"
	export ELASTICSEARCH_URL="https://elastic:${ELASTIC_PASSWORD}@localhost:${es_port}"

	# Default behavior sets these depending on available memory.
	# On my system its not reliable and leads to an instant OOM :D
	# So lets add a reasonable limit
	export ES_JAVA_OPTS="-Xmx4g"

	cp -r "${S}/.ci/certs" "${ES_DIR}/config" || die

	cat > "${ES_DIR}/config/elasticsearch.yml" <<-EOF || die
		# Run elasticsearch on custom port
		http.port: ${es_port}
		cluster.routing.allocation.disk.threshold_enabled: false
		bootstrap.memory_lock: true
		node.attr.testattr: test
		repositories.url.allowed_urls: http://snapshot.test*
		action.destructive_requires_name: false
		ingest.geoip.downloader.enabled: false

		xpack.license.self_generated.type: basic
		xpack.security.enabled: true
		xpack.security.http.ssl.enabled: true
		xpack.security.http.ssl.verification_mode: certificate
		xpack.security.http.ssl.key: certs/testnode.key
		xpack.security.http.ssl.certificate: certs/testnode.crt
		xpack.security.http.ssl.certificate_authorities: certs/ca.crt
		xpack.security.transport.ssl.enabled: true
		xpack.security.transport.ssl.verification_mode: certificate
		xpack.security.transport.ssl.key: certs/testnode.key
		xpack.security.transport.ssl.certificate: certs/testnode.crt
		xpack.security.transport.ssl.certificate_authorities: certs/ca.crt
	EOF

	# Set password in keystore
	printf "y\n${ELASTIC_PASSWORD}\n" | ${ES_DIR}/bin/elasticsearch-keystore add "bootstrap.password" || die

	local es_instance="gentoo-py-test"
	local es_log="${ES_DIR}/logs/${es_instance}.log"
	local es_temp="${T}/es_temp"
	local pid="${ES_DIR}/elasticsearch.pid"

	mkdir ${es_temp} || die

	ebegin "Starting Elasticsearch for ${EPYTHON}"

	# start local instance of elasticsearch
	"${ES_DIR}"/bin/elasticsearch -d -v -p "${pid}" \
			   -Ecluster.name="${es_instance}" -Epath.repo="${es_temp}" || die

	local i es_started=0
	for i in {1..20}; do
		grep -q "\] started" ${es_log} 2> /dev/null
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
			sleep 2
			continue
		fi
	done

	[[ ${es_started} -eq 0 ]] && die "Elasticsearch failed to start"

	distutils-r1_src_test

	pkill -F ${pid} || die

}
