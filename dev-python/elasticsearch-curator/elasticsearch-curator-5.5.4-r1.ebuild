# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

MY_PN="curator"
ES_VERSION="6.3.2"

inherit distutils-r1

DESCRIPTION="Tending time-series indices in Elasticsearch"
HOMEPAGE="https://github.com/elasticsearch/curator"
SRC_URI="https://github.com/elasticsearch/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${ES_VERSION}.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# tests fail in chroot
# https://github.com/elastic/elasticsearch/issues/12018
RESTRICT="test"
IUSE="doc test"

# require >=elasticsearch-py-6.1.0 because starting with version 5.5.2, the package
# was renamed to elasticsearch5 so elasticsearch-curator cannot find it #667526
#
# require <click-7.0
# https://github.com/elastic/curator/issues/1279
RDEPEND="
	>=dev-python/elasticsearch-py-6.1.0[${PYTHON_USEDEP}]
	<dev-python/elasticsearch-py-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/click-6.7[${PYTHON_USEDEP}]
	<dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/certifi-2018.04.16[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.20[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.9.3[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		virtual/jre:1.8
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/nosexcover[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	# avoid downloading from net
	sed -e '/^intersphinx_mapping/,+3d' -i docs/conf.py || die

	# requests_aws4auth not in portage
	sed -e '/boto3/d' \
		-e '/requests_aws4auth/d' \
		-i setup.cfg setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C docs -j1 man $(usex doc html "")
}

# running tests in non-chroot environments:
# FEATURES="test -usersandbox" emerge dev-python/elasticsearch-curator
python_test() {
	ES="${WORKDIR}/elasticsearch-${ES_VERSION}"
	ES_PORT="25123"
	ES_INSTANCE="gentoo-es-curator-test"
	ES_LOG="${ES}/logs/${ES_INSTANCE}.log"
	PID="${ES}/elasticsearch.pid"

	# run Elasticsearch instance on custom port
	sed -i "s/#http.port: 9200/http.port: ${ES_PORT}/g; \
		s/#cluster.name: my-application/cluster.name: ${ES_INSTANCE}/g" \
		"${ES}/config/elasticsearch.yml" || die

	# start local instance of elasticsearch
	"${ES}/bin/elasticsearch" -d -p "${PID}" -Epath.repo=/ || die

	local i
	local es_started=0
	for i in {1..20}; do
		grep -q "started" "${ES_LOG}" 2> /dev/null
		if [[ $? -eq 0 ]]; then
			einfo "Elasticsearch started"
			es_started=1
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

	[[ $es_started -eq 0 ]] && die "Elasticsearch failed to start"

	export TEST_ES_SERVER="localhost:${ES_PORT}"
	esetup.py test || die

	pkill -F ${PID}
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
