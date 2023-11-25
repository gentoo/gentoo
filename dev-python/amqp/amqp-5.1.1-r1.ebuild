# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN="amqp"
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Low-level AMQP client for Python (fork of amqplib)"
HOMEPAGE="https://github.com/celery/py-amqp https://pypi.org/project/amqp/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="extras"

RDEPEND="
	>=dev-python/vine-5.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pytest-rerunfailures-6.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/sphinx-celery
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# rmq tests require a rabbitmq instance
	t/integration/test_rmq.py
)

EPYTEST_DESELECT=(
	# fails when gssapi is installed (how does that test make sense?!)
	t/unit/test_sasl.py::test_SASL::test_gssapi_missing
)

python_install_all() {
	if use extras; then
		insinto /usr/share/${PF}/extras
		doins -r extra
	fi
	distutils-r1_python_install_all
}
