# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Official Python low-level client for Elasticsearch"
HOMEPAGE="https://github.com/elastic/elasticsearch-py"
SRC_URI="
	https://github.com/elastic/elasticsearch-py/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${PV}-no-jdk-linux-x86_64.tar.gz
	)
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="async doc"

PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.0[${PYTHON_USEDEP}]
	<dev-python/urllib3-2.0.0[${PYTHON_USEDEP}]
	async? (
		>=dev-python/aiohttp-3[${PYTHON_USEDEP}]
		<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	)"
BDEPEND="
	test? (
		>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
		<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
		virtual/jre:*
		async? (
			dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			dev-python/unasync[${PYTHON_USEDEP}]
		)
	)"

distutils_enable_sphinx docs/sphinx \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

src_prepare() {
	default_src_prepare

	sed -e '/addopts/d' -i setup.cfg || die
}

src_test() {
	local es_port="25124"

	export ES_DIR="${WORKDIR}/elasticsearch-${PV}"
	export ES_INSTANCE="gentoo-es-py-test"
	export ES_JAVA_HOME=$(java-config -g JAVA_HOME || die)
	export ELASTIC_PASSWORD="changeme"
	export ELASTICSEARCH_URL="https://elastic:${ELASTIC_PASSWORD}@localhost:${es_port}"

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

	# Deselect tests which require a non-free license in the server to succeed
	local EPYTEST_DESELECT=(
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[token/11_invalidation[{0,1}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[token/10_basic[{1..4}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/jobs_get_result_record[{1..6}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/jobs_get_result_influencer[{1..8}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/datafeed_cat_apis[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/filter_crud[10]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/preview_data_frame_analytics[{3..5}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/custom_all_field[{0,1}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/data_frame_analytics_crud[{1,5,6,13,29,38,39,40,42,62,76,77,78,80,81,82,83}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/start_data_frame_analytics[{0,1,2,3,4,6,7,8}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/jobs_get_result_categories[{0,1,2,3,4,5,6,7}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/forecast[{1,2,3,4,5,6}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/explain_data_frame_analytics[{3,5,6,7,8}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/delete_expired_data[{0,1,2,3}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/upgrade_job_snapshot[{0,1}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/inference_processor[{0,1}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/jobs_get_result_buckets[{0,1,2,3,4,5,6,7,8,9,10,11}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/trained_model_cat_apis[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/revert_model_snapshot[{0,1}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/calendar_crud[{0,7,8,12,13,17,18}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/stop_data_frame_analytics[{0,1,2,3,4,5}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/jobs_get[{0,1,2,3,4}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/preview_datafeed[{0,1,2,3,7,8,9}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/data_frame_analytics_cat_apis[{0,1,2,3}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/reset_job[{0,1}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/ml_anomalies_default_mappings[{0,1}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/get_model_snapshots[{0,1,2,3,4,5,6,7}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/get_datafeeds[{0,1,2,3}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/job_cat_apis[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[change_password/11_token[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[searchable_snapshots/10_usage[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[graph/10_basic[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[data_stream/10_data_stream_resolvability[4]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[xpack/20_info[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[authenticate/10_field_level_security[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[set_security_user/10_small_users_one_index[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[terms_enum/10_basic[{0..9}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[security/hidden-index/14_security-tokens-7_read[{0,1,2}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[security/hidden-index/13_security-tokens_read[{0,1,2}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/jobs_get_result_records[{0..6}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[ml/jobs_get_result_influencers[{0..8}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[license/20_put_license[{5,7,8}]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[license/30_enterprise_license[0]
		test_elasticsearch/test_server/test_rest_api_spec.py::test_rest_api_spec[token/10_basic[0]
	)

	use async || EPYTEST_DESELECT+=(
		test_elasticsearch/test_async test_elasticsearch/test_types/async_types.py
	)

	distutils-r1_src_test
}

python_test() {
	local es_instance="gentoo-py-test"
	local es_log="${ES_DIR}/logs/${es_instance}-${EPYTHON}.log"
	local es_temp="${T}/es_temp-${EPYTHON}"
	local pid="${ES_DIR}/elasticsearch.pid"

	mkdir ${es_temp} || die

	ebegin "Starting Elasticsearch for ${EPYTHON}"

	# start local instance of elasticsearch
	"${ES_DIR}"/bin/elasticsearch -d -p "${pid}" -Ecluster.name="${es_instance}-${EPYTHON}" -Epath.repo="${es_temp}" || die

	local i es_started=0
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
			sleep 2
			continue
		fi
	done

	[[ ${es_started} -eq 0 ]] && die "Elasticsearch failed to start"

	epytest

	pkill -F ${pid} || die
}
