# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_PN="amqp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Low-level AMQP client for Python (fork of amqplib)"
HOMEPAGE="https://github.com/celery/py-amqp https://pypi.org/project/amqp/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="extras"

BDEPEND="
	>=dev-python/vine-5.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/case-1.3.1[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-6.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs dev-python/sphinx_celery
distutils_enable_tests pytest

python_test() {
	# rmq tests require a rabbitmq instance
	epytest --ignore t/integration/test_rmq.py
}

python_install_all() {
	if use extras; then
		insinto /usr/share/${PF}/extras
		doins -r extra
	fi
	distutils-r1_python_install_all
}
