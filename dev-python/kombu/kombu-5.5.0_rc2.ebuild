# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="
	https://github.com/celery/kombu/
	https://pypi.org/project/kombu/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="examples"

RDEPEND="
	>=dev-python/amqp-5.1.1[${PYTHON_USEDEP}]
	<dev-python/amqp-6.0.0[${PYTHON_USEDEP}]
	dev-python/tzdata[${PYTHON_USEDEP}]
	dev-python/vine[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		app-arch/brotli[python,${PYTHON_USEDEP}]
		>=dev-python/boto3-1.22.2[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		>=dev-python/msgpack-0.3.0[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		>=dev-python/pymongo-4.1.1[${PYTHON_USEDEP}]
		dev-python/pytest-freezer[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
		>=dev-python/redis-4.2.2[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-celery

src_prepare() {
	distutils-r1_src_prepare

	# unpin deps (notably tzdata, sigh)
	> requirements/default.txt || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		t/unit/transport/test_redis.py::test_Channel::test_connparams_health_check_interval_supported
		t/unit/transport/test_redis.py::test_Channel::test_global_keyprefix_transaction
		# bad filename assumption?
		t/unit/asynchronous/aws/test_connection.py::test_AsyncHTTPSConnection::test_request_with_cert_path_https
	)
	local EPYTEST_IGNORE=(
		# obsolete Pyro4
		t/unit/transport/test_pyro.py
		# unpackaged azure
		t/unit/transport/test_azurestoragequeues.py
		# unpackage google-cloud
		t/unit/transport/test_gcpubsub.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Amazon SQS backend" "dev-python/boto3 dev-python/pycurl"
	optfeature "Etcd backend" dev-python/python-etcd
	optfeature "MongoDB backend" dev-python/pymongo
	optfeature "Redis backend" dev-python/redis
	optfeature "sqlalchemy backend" dev-python/sqlalchemy
	optfeature "yaml backend" dev-python/pyyaml
	optfeature "MessagePack (de)serializer for Python" dev-python/msgpack
	optfeature "brotli compression" "app-arch/brotli[python]"
	optfeature "zstd compression" dev-python/zstandard
}
