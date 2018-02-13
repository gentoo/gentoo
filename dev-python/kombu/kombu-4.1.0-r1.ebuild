# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="https://pypi.python.org/pypi/kombu https://github.com/celery/kombu"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc examples mongodb msgpack redis sqs test yaml"

# couchdb backend support possible via dev-python/couchdb-python
# ditto dev-python/kazoo(>=1.3.1)
RDEPEND="
	>=dev-python/py-amqp-2.1.4[${PYTHON_USEDEP}]
	<dev-python/py-amqp-3.0[${PYTHON_USEDEP}]
	dev-python/pyro:4[${PYTHON_USEDEP}]
	sqs? ( >=dev-python/boto3-1.4.4[${PYTHON_USEDEP}] )
	msgpack? ( >=dev-python/msgpack-0.3.0[${PYTHON_USEDEP}] )
	mongodb? ( >=dev-python/pymongo-3.0.2[${PYTHON_USEDEP}] )
	redis? ( >=dev-python/redis-py-2.10.3[${PYTHON_USEDEP}] )
	yaml? ( >=dev-python/pyyaml-3.10[${PYTHON_USEDEP}] )"
# Fix to https://github.com/celery/kombu/issues/474 obliges dev-python/pymongo to >=-3.0.2
DEPEND="${RDEPEND}
	>=dev-python/setuptools-20.6.7[${PYTHON_USEDEP}]
	test? (
		>=dev-python/case-1.5.2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}] )
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/couchdb-python[${PYTHON_USEDEP}]
		>=dev-python/sphinx_celery-1.1[${PYTHON_USEDEP}] )"

# kazoo is optional for tests.
# Refrain for now, no established demand for it from users

# Req'd for test phase
DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
)

python_prepare_all() {
	# AttributeError: test_Etcd instance has no attribute 'patch'
	rm t/unit/transport/test_etcd.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# Doc build misses and skips only content re librabbitmq which is not in portage
	if use doc; then
		emake -C docs html || die "kombu docs failed installation"
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r examples/.
	fi
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
