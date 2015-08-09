# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="AMQP Messaging Framework for Python"
HOMEPAGE="http://pypi.python.org/pypi/kombu https://github.com/celery/kombu"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="amqplib doc examples test"

RDEPEND=">=dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
		>=dev-python/py-amqp-1.3.0[${PYTHON_USEDEP}]
		<dev-python/py-amqp-2.0[${PYTHON_USEDEP}]
		amqplib? ( >=dev-python/amqplib-1.0.2[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/beanstalkc[$(python_gen_usedep python2_7)]
		dev-python/couchdb-python[$(python_gen_usedep python2_7)]
		>=dev-python/sphinxcontrib-issuetracker-0.9[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile_all() {
	if use doc; then
		emake -C docs html || die "kombu docs failed installation"
	fi
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	use doc && local HTML_DOCS=( docs/.build/html/. )
	distutils-r1_python_install_all
}
