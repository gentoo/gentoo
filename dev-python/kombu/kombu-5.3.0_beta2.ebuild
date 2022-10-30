# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

MY_PV="${PV//_beta/b}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="
	https://github.com/celery/kombu/
	https://pypi.org/project/kombu/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="examples"

RDEPEND="
	>=dev-python/py-amqp-5.1.1[${PYTHON_USEDEP}]
	<dev-python/py-amqp-6.0.0[${PYTHON_USEDEP}]
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
		dev-python/Pyro4[${PYTHON_USEDEP}]
		dev-python/pytest-freezegun[${PYTHON_USEDEP}]
		dev-python/python-zstandard[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
		>=dev-python/redis-py-4.2.2[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_celery

EPYTEST_IGNORE=(
	# Unpackaged azure-servicebus
	t/unit/transport/test_azureservicebus.py
	# Unpackaged librabbitmq
	t/unit/transport/test_librabbitmq.py
	# Unpackaged python-consul
	t/unit/transport/test_consul.py
	# AttributeError: test_Etcd instance has no attribute 'patch'
	t/unit/transport/test_etcd.py
)

python_test() {
	local EPYTEST_DESELECT

	# AttributeError: 'str' object has no attribute 'load'
	[[ ${EPYTHON} == python3.10 ]] && \
		EPYTEST_DESELECT+=( t/unit/utils/test_compat.py::test_entrypoints )

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
	optfeature "Pyro 4 backend" dev-python/Pyro4
	optfeature "Redis backend" dev-python/redis-py
	optfeature "sqlalchemy backend" dev-python/sqlalchemy
	optfeature "yaml backend" dev-python/pyyaml
	optfeature "MessagePack (de)serializer for Python" dev-python/msgpack
	optfeature "brotli compression" "app-arch/brotli[python]"
	optfeature "zstd compression" dev-python/python-zstandard
}
