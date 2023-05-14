# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Library to export Django metrics for Prometheus"
HOMEPAGE="
	https://github.com/korfuri/django-prometheus/
	https://pypi.org/project/django-prometheus/
"

LICENSE="Apache-1.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/prometheus_client-0.7[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i "/pytest-runner/d" setup.py || die
	distutils-r1_python_prepare_all
}
