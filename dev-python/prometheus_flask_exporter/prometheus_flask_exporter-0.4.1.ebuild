# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Provides HTTP request metrics to export into Prometheus"
HOMEPAGE="https://pypi.python.org/pypi/prometheus-flask-exporter https://github.com/rycus86/prometheus_flask_exporter"
SRC_URI="https://github.com/rycus86/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/prometheus_client[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_test() {
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
