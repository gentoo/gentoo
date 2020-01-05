# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit bash-completion-r1 distutils-r1 eutils

DESCRIPTION="Asynchronous task queue/job queue based on distributed message passing"
HOMEPAGE="http://celeryproject.org/ https://pypi.org/project/celery/"
# The pypi tarball lacks CONTRIBUTING.rst required for documentation build.
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/celery/celery/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# There are a number of other optional 'extras' which overlap with those of kombu, however
# there has been no apparent expression of interest or demand by users for them. See requires.txt
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/kombu-5.0[${PYTHON_USEDEP}]
	>=dev-python/kombu-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/billiard-3.6.0[${PYTHON_USEDEP}]
	<dev-python/billiard-4.0.0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	>=dev-python/vine-1.3.0[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		>=dev-python/case-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/eventlet-0.24.1[${PYTHON_USEDEP}]
		dev-python/gevent[$(python_gen_usedep python2_7)]
		>=dev-python/pymongo-3.7[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.3.1[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		>=dev-python/redis-py-3.2.0[${PYTHON_USEDEP}]
		>=dev-db/redis-2.8.0
		>=dev-python/boto-2.13.3[${PYTHON_USEDEP}]
		>=dev-python/boto3-1.4.6[${PYTHON_USEDEP}]
		>=dev-python/moto-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-13.1.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
		>=dev-python/unittest2-0.5.1[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/docutils[${PYTHON_USEDEP}]
		>=dev-python/sphinx_celery-2.0[$(python_gen_usedep 'python3*')]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/typing[${PYTHON_USEDEP}]' python2_7)
	)"

# testsuite needs it own source
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Loosen requirements
	sed -e 's|==|>=|' \
		-e 's|pytest>=4.3.1,<4.4.0|pytest>=4.3.1|' \
		-i requirements/*.txt || die

	# Suppress KeyError: 'refdoc'
	sed -e 's|^[[:space:]]*return domain.resolve_xref(env, node\['\''refdoc'\''\], app.builder,$|            if '\''refdoc'\'' not in node:\n                return None\n\0|' \
		-i docs/_ext/celerydocs.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_setup -3
		mkdir docs/.build || die
		emake -C docs html
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	# Main celeryd init.d and conf.d
	newinitd "${FILESDIR}/celery.initd-r2" celery
	newconfd "${FILESDIR}/celery.confd-r2" celery

	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi

	use doc && local HTML_DOCS=( docs/_build/html/. )

	newbashcomp extra/bash-completion/celery.bash ${PN}

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "zookeeper support" dev-python/kazoo
	optfeature "msgpack support" dev-python/msgpack
	#optfeature "rabbitmq support" dev-python/librabbitmq
	#optfeature "slmq support" dev-python/softlayer_messaging
	optfeature "eventlet support" dev-python/eventlet
	#optfeature "couchbase support" dev-python/couchbase
	optfeature "redis support" dev-db/redis dev-python/redis-py
	optfeature "gevent support" dev-python/gevent
	optfeature "auth support" dev-python/pyopenssl
	optfeature "pyro support" dev-python/pyro:4
	optfeature "yaml support" dev-python/pyyaml
	optfeature "memcache support" dev-python/pylibmc
	optfeature "mongodb support" dev-python/pymongo
	optfeature "sqlalchemy support" dev-python/sqlalchemy
	optfeature "sqs support" dev-python/boto
	#optfeature "cassandra support" dev-python/cassandra-driver
}
