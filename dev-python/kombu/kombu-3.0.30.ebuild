# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="https://pypi.python.org/pypi/kombu https://github.com/celery/kombu"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="amqplib doc examples msgpack sqs test"

# couchdb backend support possible via dev-python/couchdb-python
# ditto dev-python/kazoo(>=1.3.1) and dev-python/beanstalkc
PY27_GEN_USEDEP=$(python_gen_usedep python2_7)
PYPY_GEN_USEDEP=$(python_gen_usedep python2_7 pypy)
RDEPEND="
	>=dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/py-amqp-1.4.7[${PYTHON_USEDEP}]
	<dev-python/py-amqp-2.0[${PYTHON_USEDEP}]
	dev-python/pyro:4[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/pyzmq-13.1.0[${PYTHON_USEDEP}]' python2_7 python{3_3,3_4})
	amqplib? ( >=dev-python/amqplib-1.0.2[${PYTHON_USEDEP}] )
	sqs? ( >=dev-python/boto-2.13.3[${PY27_GEN_USEDEP}] )
	msgpack? ( >=dev-python/msgpack-0.3.0[${PYTHON_USEDEP}] )"
# Fix to https://github.com/celery/kombu/issues/474 obliges dev-python/pymongo to >=-3.0.2
DEPEND="${RDEPEND}
	>=dev-python/setuptools-0.7[${PYTHON_USEDEP}]
	test? (
		>=dev-python/unittest2-0.5.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose-cover3[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.0[${PYTHON_USEDEP}]
		>=dev-python/mock-0.7.0[${PYPY_GEN_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		>=dev-python/redis-py-2.10.3[${PYTHON_USEDEP}]
		>=dev-python/pymongo-3.0.2[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}] )
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/beanstalkc[${PY27_GEN_USEDEP}]
		dev-python/couchdb-python[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-issuetracker-0.9[${PYTHON_USEDEP}] )"

# kazoo and sqlalchemy are optional packages for tests.
# Refrain for now, no established demand for it from users

# Req'd for test phase
DISTUTILS_IN_SOURCE_BUILD=1

PY27_REQUSE="$(python_gen_useflags 'python2.7')"
REQUIRED_USE="
	sqs? ( ${PY27_REQUSE} )
	doc? ( ${PY27_REQUSE} amqplib sqs )"	# 2 deps in doc build are py2 capable only

PATCHES=(
	"${FILESDIR}"/${PN}-NA-tests-fix.patch
	)

pkg_setup() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( python2.7 )
}

python_prepare_all() {
	https://github.com/celery/kombu/issues/246
	sed -e 's:kombu.transports:kombu.transport:' -i funtests/tests/test_django.py
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# Doc build must be done by py2.7
	# Doc build misses and skips only content re librabbitmq which is not in portage
	if use doc; then
		emake -C docs html || die "kombu docs failed installation"
	fi
}

python_test() {
	export DJANGO_SETTINGS_MODULE="django.conf"
	# https://github.com/celery/kombu/issues/474
	# tests need </pymongo-3.0; known to cause some breakage
	if python_is_python3; then
		2to3 --no-diffs -w build/lib/kombu/transport/
		nosetests --py3where=build/lib kombu/tests || die "Tests failed under ${EPYTHON}"
	else
		nosetests "${S}"/kombu/tests || die "Tests failed under ${EPYTHON}"
		# funtests appears to be coded only for py2, a kind of 2nd tier. pypy fails 6.
		# https://github.com/celery/kombu/issues/411
		# Fix to https://github.com/celery/kombu/issues/474 breaks the 
		# funtests under >=dev-python/pymongo-3.0.2
#		if [[ "${EPYTHON}" == python2.7 ]]; then
#			pushd funtests > /dev/null
#			esetup.py test
#			popd > /dev/null
#		fi
	fi
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	use doc && local HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}
